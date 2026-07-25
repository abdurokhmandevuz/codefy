from django.db import migrations
from django.contrib.auth.hashers import make_password

def create_admin_user(apps, schema_editor):
    User = apps.get_model('auth', 'User')
    hashed_pwd = make_password('adminpassword123')
    if not User.objects.filter(username='admin').exists():
        User.objects.create(
            username='admin',
            email='admin@codefy.uz',
            password=hashed_pwd,
            is_staff=True,
            is_superuser=True
        )
    else:
        user = User.objects.get(username='admin')
        user.password = hashed_pwd
        user.is_staff = True
        user.is_superuser = True
        user.save()

class Migration(migrations.Migration):

    dependencies = [
        ('app', '0008_lessonprogress_current_step'),
    ]

    operations = [
        migrations.RunPython(create_admin_user),
    ]
