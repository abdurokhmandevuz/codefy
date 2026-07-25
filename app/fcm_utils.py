import json
import os
import logging
from django.conf import settings

logger = logging.getLogger(__name__)

def send_fcm_notification(title, body):
    try:
        import firebase_admin
        from firebase_admin import credentials, messaging

        cred_json_str = os.getenv('FIREBASE_CREDENTIALS')
        cert_path = os.path.join(settings.BASE_DIR, 'firebase_service_account.json')

        if not firebase_admin._apps:
            if cred_json_str:
                try:
                    cred_dict = json.loads(cred_json_str)
                    cred = credentials.Certificate(cred_dict)
                    firebase_admin.initialize_app(cred)
                except Exception as ex:
                    logger.error(f"Failed to load FIREBASE_CREDENTIALS env: {ex}")
                    return False
            elif os.path.exists(cert_path):
                cred = credentials.Certificate(cert_path)
                firebase_admin.initialize_app(cred)
            else:
                logger.warning("No Firebase credentials found")
                return False

        message = messaging.Message(
            notification=messaging.Notification(
                title=title,
                body=body,
            ),
            topic='all_users',
        )

        response = messaging.send(message)
        logger.info(f"Successfully sent FCM push: {response}")
        return True
    except Exception as e:
        logger.error(f"Error sending FCM push: {e}")
        return False
