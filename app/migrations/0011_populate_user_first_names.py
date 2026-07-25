from django.db import migrations

def populate_user_names(apps, schema_editor):
    User = apps.get_model('auth', 'User')
    for user in User.objects.all():
        if not user.first_name and user.email:
            user.first_name = user.email.split('@')[0]
            user.save()

class Migration(migrations.Migration):

    dependencies = [
        ('app', '0010_seed_lessons_data'),
    ]

    operations = [
        migrations.RunPython(populate_user_names),
    ]
