import re

with open('app/migrations/0001_initial.py', 'r', encoding='utf-8') as f:
    content = f.read()

content = re.sub(r"(?s)\s+migrations\.CreateModel\(\s+name='PracticeCard',.*?\]\s+\),\n", '\n', content)
content = re.sub(r"(?s)\s+migrations\.CreateModel\(\s+name='PracticeTask',.*?\]\s+\),\n", '\n', content)
content = re.sub(r"(?s)\s+migrations\.CreateModel\(\s+name='PracticeTaskProgress',.*?\]\s+\),\n", '\n', content)

with open('app/migrations/0001_initial.py', 'w', encoding='utf-8') as f:
    f.write(content)
