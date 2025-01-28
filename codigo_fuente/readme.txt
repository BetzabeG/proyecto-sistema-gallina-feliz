1. verifica el nombre de la base de datos en settings.py

2. debe hacer correr los comandos en el cmd para que le de la url del sistema

rmdir /s /q venv
python -m venv venv
venv\Scripts\activate
pip install django
python -m pip install --upgrade pip
python -m django --version
python manage.py makemigrations
pip install psycopg
python manage.py makemigrations
python manage.py migrate
python manage.py runserver



