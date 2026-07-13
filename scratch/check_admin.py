import os
import django
from django.test import RequestFactory

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'src.settings')
django.setup()

from django.contrib import admin
request = RequestFactory().get('/admin/')
request.user = django.contrib.auth.models.User.objects.get(username='admin')

app_list = admin.site.get_app_list(request)
for app in app_list:
    print(app['name'])
    for m in app['models']:
        print(" -", m['object_name'])
