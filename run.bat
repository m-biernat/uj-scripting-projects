@echo off
start cmd /k "title rasa && venv\Scripts\activate && rasa run --enable-api"
start cmd /k "title rasa actions && venv\Scripts\activate && rasa run actions"
start cmd /k "title api && venv\Scripts\activate && python api.py"
start cmd /k "title bot && venv\Scripts\activate && python bot.py"
