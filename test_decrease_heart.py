import os
import sys
sys.path.append(os.path.dirname(__file__))

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "src.settings")
import django
django.setup()

from rest_framework.test import APIRequestFactory, force_authenticate
from app.api_views import decrease_heart
from django.contrib.auth.models import User
import json

factory = APIRequestFactory()
request = factory.post('/api/v1/user/decrease-heart/')
user = User.objects.first()
force_authenticate(request, user=user)

response = decrease_heart(request)
print("STATUS:", response.status_code)
print("DATA:", response.data)
