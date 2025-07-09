import os
from datetime import timedelta

class Config:
    """Base configuration class."""
    
    # Security
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'your-secret-key-change-in-production'
    
    # Database
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL') or 'sqlite:///hierosecret.db'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    
    # File uploads
    UPLOAD_FOLDER = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'uploads')
    MAX_CONTENT_LENGTH = 16 * 1024 * 1024  # 16MB
    ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif'}
    
    # JWT
    JWT_EXPIRATION_DELTA = timedelta(days=30)
    JWT_ACCESS_TOKEN_EXPIRES = timedelta(days=30)
    JWT_SECRET_KEY = os.environ.get('JWT_SECRET_KEY') or SECRET_KEY
    
    # ML Model paths
    YOLO_MODEL_PATH = os.environ.get('YOLO_MODEL_PATH') or os.path.join(os.path.dirname(os.path.abspath(__file__)), 'Yolov8m_Best.pt')
    CLASSIFICATION_MODEL_PATH = os.environ.get('CLASSIFICATION_MODEL_PATH') or os.path.join(os.path.dirname(os.path.abspath(__file__)), 'Classification_Model.pt')
    
    # Gemini AI
    GEMINI_API_KEY = os.environ.get('GEMINI_API_KEY') or 'your-gemini-api-key-here'
    
    # CORS
    CORS_ORIGINS = "*"  # Change this in production


class DevelopmentConfig(Config):
    """Development configuration."""
    DEBUG = True


class ProductionConfig(Config):
    """Production configuration."""
    DEBUG = False
    
    # Override with secure settings
    CORS_ORIGINS = ["http://localhost:3000", "https://yourdomain.com","http://localhost:8080"]


class TestingConfig(Config):
    """Testing configuration."""
    TESTING = True
    SQLALCHEMY_DATABASE_URI = 'sqlite:///:memory:'


config = {
    'development': DevelopmentConfig,
    'production': ProductionConfig,
    'testing': TestingConfig,
    'default': DevelopmentConfig
}
