import os
import environ
from .base import *

# Initialize environment variables
env = environ.Env(
    DEBUG=(bool, False)
)

# Read environment variables from .env file if it exists
environ.Env.read_env()

# Security
SECRET_KEY = env('SECRET_KEY', default='django-insecure-change-this-key-in-production')
DEBUG = env('DEBUG', default=False)

# Allowed hosts
ALLOWED_HOSTS = env.list('DJANGO_ALLOWED_HOSTS', default=['91.99.193.112', 'localhost', '127.0.0.1', '*'])

# CORS Configuration
CORS_ALLOWED_ORIGINS = env.list('CORS_ALLOWED_ORIGINS', default=[
    "http://localhost:3000",
    "http://127.0.0.1:3000",
])

# Database Configuration
# Use SQLite if DB_HOST is not provided, otherwise use PostgreSQL
if env('DB_HOST', default=''):
    DATABASES = {
        'default': {
            'ENGINE': 'django.db.backends.postgresql_psycopg2',
            'NAME': env('DB_NAME', default='trucksigns_db'),
            'USER': env('DB_USER', default='trucksigns_user'),
            'PASSWORD': env('DB_PASSWORD', default=''),
            'HOST': env('DB_HOST', default='localhost'),
            'PORT': env('DB_PORT', default='5432'),
        }
    }
else:
    # Use SQLite for simpler setup
    DATABASES = {
        'default': {
            'ENGINE': 'django.db.backends.sqlite3',
            'NAME': os.path.join(BASE_DIR, 'db.sqlite3'),
        }
    }

# Stripe Configuration
STRIPE_PUBLISHABLE_KEY = env('STRIPE_PUBLISHABLE_KEY', default='')
STRIPE_SECRET_KEY = env('STRIPE_SECRET_KEY', default='')

# Email Configuration
EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
EMAIL_HOST = 'smtp.gmail.com'
EMAIL_USE_TLS = True
EMAIL_PORT = 587
EMAIL_HOST_USER = env('EMAIL_HOST_USER', default='')
EMAIL_HOST_PASSWORD = env('EMAIL_HOST_PASSWORD', default='')

# Admin Configuration
CURRENT_ADMIN_DOMAIN = env('CURRENT_ADMIN_DOMAIN', default='http://localhost:8000')
EMAIL_ADMIN = env('EMAIL_ADMIN', default='admin@trucksigns.com')

# Cloudinary Configuration (optional for media storage)
if env('CLOUD_NAME', default=''):
    CLOUDINARY_STORAGE = {
        'CLOUD_NAME': env('CLOUD_NAME'),
        'API_KEY': env('CLOUD_API_KEY'),
        'API_SECRET': env('CLOUD_API_SECRET'),
    }
    DEFAULT_FILE_STORAGE = 'cloudinary_storage.storage.MediaCloudinaryStorage'
else:
    # Use local media storage
    MEDIA_URL = '/media/'
    MEDIA_ROOT = os.path.join(ROOT_BASE_DIR, 'media')

# Static files configuration for production
STATIC_URL = '/static/'
STATIC_ROOT = os.path.join(ROOT_BASE_DIR, 'static')

# Enable WhiteNoise for static files serving
MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'whitenoise.middleware.WhiteNoiseMiddleware',  # Add WhiteNoise
    'django.contrib.sessions.middleware.SessionMiddleware',
    'corsheaders.middleware.CorsMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

# WhiteNoise settings (simplified for compatibility)
STATICFILES_STORAGE = 'whitenoise.storage.CompressedStaticFilesStorage'

# Security settings for production
if not DEBUG:
    SECURE_BROWSER_XSS_FILTER = True
    SECURE_CONTENT_TYPE_NOSNIFF = True
    X_FRAME_OPTIONS = 'DENY'
    SECURE_HSTS_SECONDS = 86400
    SECURE_HSTS_INCLUDE_SUBDOMAINS = True
    SECURE_HSTS_PRELOAD = True

# Logging Configuration
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'verbose': {
            'format': '{levelname} {asctime} {module} {process:d} {thread:d} {message}',
            'style': '{',
        },
        'simple': {
            'format': '{levelname} {message}',
            'style': '{',
        },
    },
    'handlers': {
        'console': {
            'class': 'logging.StreamHandler',
            'formatter': 'simple',
        },
    },
    'root': {
        'handlers': ['console'],
        'level': 'INFO',
    },
    'loggers': {
        'django': {
            'handlers': ['console'],
            'level': env('DJANGO_LOG_LEVEL', default='INFO'),
            'propagate': False,
        },
    },
}
