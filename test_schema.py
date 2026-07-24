import os
import sys

# Add src and the root to python path so it can find 'src' and 'app'
sys.path.append(os.path.dirname(__file__))
sys.path.append(os.path.join(os.path.dirname(__file__), 'src'))

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "src.settings")
import django
django.setup()

from django.test import Client
c = Client()
try:
    response = c.get('/api/schema/')
    print("Schema Response:", response.status_code)
except Exception as e:
    import traceback
    traceback.print_exc()

try:
    response = c.get('/api/docs/')
    print("Docs Response:", response.status_code)
except Exception as e:
    import traceback
    traceback.print_exc()
