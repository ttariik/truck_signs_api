#!/usr/bin/env bash
set -e

echo "Starting Truck Signs API..."

# Wait for database if DB_HOST is set
if [ ! -z "$DB_HOST" ]; then
    echo "Waiting for PostgreSQL to be available on $DB_HOST:${DB_PORT:-5432}..."
    while ! nc -z "$DB_HOST" "${DB_PORT:-5432}"; do
        sleep 1
        echo "Still waiting for database..."
    done
    echo "PostgreSQL is active!"
fi

# Collect static files
echo "Collecting static files..."
python manage.py collectstatic --noinput

# Run database migrations
echo "Running database migrations..."
python manage.py makemigrations
python manage.py migrate

echo "Database migrations completed!"

# Check if we should create a superuser
if [ "$DJANGO_SUPERUSER_EMAIL" ] && [ "$DJANGO_SUPERUSER_PASSWORD" ]; then
    echo "Creating superuser..."
    python manage.py shell << EOF
from django.contrib.auth import get_user_model
User = get_user_model()
if not User.objects.filter(email='$DJANGO_SUPERUSER_EMAIL').exists():
    User.objects.create_superuser('admin', '$DJANGO_SUPERUSER_EMAIL', '$DJANGO_SUPERUSER_PASSWORD')
    print('Superuser created successfully')
else:
    print('Superuser already exists')
EOF
fi

# Start the application
echo "Starting Gunicorn server..."
exec gunicorn truck_signs_designs.wsgi:application \
    --bind 0.0.0.0:8000 \
    --workers 3 \
    --timeout 120 \
    --keep-alive 2 \
    --max-requests 1000 \
    --max-requests-jitter 100