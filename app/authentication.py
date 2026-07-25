import requests
from django.conf import settings
from rest_framework import authentication
from rest_framework import exceptions
from django.contrib.auth.models import User
from django.core.cache import cache

class SupabaseAuthentication(authentication.BaseAuthentication):
    def authenticate(self, request):
        auth_header = request.headers.get('Authorization')
        
        if not auth_header or not auth_header.startswith('Bearer '):
            return None # Authentication not attempted
            
        token = auth_header.split(' ')[1]
        
        # Check cache first to avoid hitting Supabase API on every request
        cache_key = f'supabase_user_{token}'
        cached_user_id = cache.get(cache_key)
        
        if cached_user_id:
            try:
                user = User.objects.get(username=cached_user_id)
                return (user, None)
            except User.DoesNotExist:
                pass

        # Validate token with Supabase
        supabase_url = getattr(settings, 'SUPABASE_URL', None)
        supabase_anon_key = getattr(settings, 'SUPABASE_ANON_KEY', None)
        
        if not supabase_url or not supabase_anon_key:
            raise exceptions.AuthenticationFailed('Supabase credentials not configured on server')
            
        try:
            response = requests.get(
                f'{supabase_url}/auth/v1/user',
                headers={
                    'Authorization': f'Bearer {token}',
                    'apikey': supabase_anon_key
                },
                timeout=5
            )
            
            if response.status_code != 200:
                raise exceptions.AuthenticationFailed('Invalid or expired Supabase token')
                
            user_data = response.json()
            supabase_user_id = user_data.get('id')
            email = user_data.get('email', '')
            user_metadata = user_data.get('user_metadata', {})
            
            full_name = user_metadata.get('full_name', '')
            first_name = user_metadata.get('first_name', '')
            last_name = user_metadata.get('last_name', '')
            
            if not first_name and full_name:
                parts = full_name.strip().split(' ')
                first_name = parts[0]
                if len(parts) > 1:
                    last_name = ' '.join(parts[1:])
                    
            if not first_name and email:
                first_name = email.split('@')[0]
            
            if not supabase_user_id:
                raise exceptions.AuthenticationFailed('User ID not found in Supabase response')
                
            # Find or create Django user
            user, created = User.objects.get_or_create(
                username=supabase_user_id,
                defaults={
                    'email': email,
                    'first_name': first_name,
                    'last_name': last_name,
                    'is_active': True,
                }
            )
            
            # Update user info if missing or updated
            updated = False
            if user.email != email and email:
                user.email = email
                updated = True
            if not user.first_name and first_name:
                user.first_name = first_name
                updated = True
            if not user.last_name and last_name:
                user.last_name = last_name
                updated = True
                
            if updated:
                user.save()
            
            # Ensure UserProfile exists
            from app.models import UserProfile
            UserProfile.objects.get_or_create(user=user)
            
            # Cache the result for 5 minutes
            cache.set(cache_key, supabase_user_id, 300)
            
            return (user, None)
            
        except requests.RequestException:
            raise exceptions.AuthenticationFailed('Could not reach Supabase auth server')
