import os
import django

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "src.settings")
django.setup()

from django.db import connection

def create_tables():
    with connection.cursor() as cursor:
        try:
            cursor.execute("""
            CREATE TABLE IF NOT EXISTS "app_practicecard" (
                "id" integer NOT NULL PRIMARY KEY AUTOINCREMENT,
                "title" varchar(100) NOT NULL,
                "description" text NOT NULL,
                "icon_emoji" varchar(10) NOT NULL,
                "order" integer NOT NULL
            );
            """)
            print("PracticeCard created")
        except Exception as e:
            print("PracticeCard:", e)

        try:
            cursor.execute("""
            CREATE TABLE IF NOT EXISTS "app_practicetask" (
                "id" integer NOT NULL PRIMARY KEY AUTOINCREMENT,
                "title" varchar(200) NOT NULL,
                "description" text NOT NULL,
                "initial_code" text NOT NULL,
                "expected_output" varchar(200) NOT NULL,
                "difficulty" varchar(50) NOT NULL,
                "xp_reward" integer NOT NULL,
                "order" integer NOT NULL,
                "card_id" bigint NOT NULL REFERENCES "app_practicecard" ("id") DEFERRABLE INITIALLY DEFERRED
            );
            """)
            print("PracticeTask created")
        except Exception as e:
            print("PracticeTask:", e)

        try:
            cursor.execute("""
            CREATE TABLE IF NOT EXISTS "app_practicetaskprogress" (
                "id" integer NOT NULL PRIMARY KEY AUTOINCREMENT,
                "is_completed" bool NOT NULL,
                "completed_at" datetime NOT NULL,
                "task_id" bigint NOT NULL REFERENCES "app_practicetask" ("id") DEFERRABLE INITIALLY DEFERRED,
                "user_id" integer NOT NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED
            );
            """)
            print("PracticeTaskProgress created")
        except Exception as e:
            print("PracticeTaskProgress:", e)

if __name__ == "__main__":
    create_tables()
