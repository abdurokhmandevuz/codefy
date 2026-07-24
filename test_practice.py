import os
import sys
sys.path.append(os.path.dirname(__file__))

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "src.settings")
import django
django.setup()

from rest_framework.test import APIRequestFactory, force_authenticate
from app.api_views import get_practice_cards
from django.contrib.auth.models import User

factory = APIRequestFactory()
request = factory.get('/api/v1/practice/')
user = User.objects.first()
if not user:
    user = User.objects.create(username='test_user')

force_authenticate(request, user=user)

response = get_practice_cards(request)
print("STATUS CODE:", response.status_code)
import json
from rest_framework.renderers import JSONRenderer
with open('out.json', 'wb') as f:
    f.write(JSONRenderer().render(response.data))
