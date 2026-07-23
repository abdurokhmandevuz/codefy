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
            
            if not supabase_user_id:
                raise exceptions.AuthenticationFailed('User ID not found in Supabase response')
                
            # Find or create Django user
            # We use the Supabase UUID as the Django username
            user, created = User.objects.get_or_create(
                username=supabase_user_id,
                defaults={
                    'email': email,
                    'is_active': True,
                }
            )
            
            # Ensure UserProfile exists
            from app.models import UserProfile
            UserProfile.objects.get_or_create(user=user)
            
            # Cache the result for 5 minutes
            cache.set(cache_key, supabase_user_id, 300)
            
            return (user, None)
            
        except requests.RequestException:
            raise exceptions.AuthenticationFailed('Could not reach Supabase auth server')
