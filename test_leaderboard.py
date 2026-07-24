import os
import sys
sys.path.append(os.path.dirname(__file__))

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "src.settings")
import django
django.setup()

from django.contrib.auth.models import User
from app.models import UserProfile

user = User.objects.first()
profile = user.userprofile
try:
    url = profile.avatar.url if profile.avatar else None
    print("Avatar URL:", url)
except Exception as e:
    print("Error:", type(e), e)
