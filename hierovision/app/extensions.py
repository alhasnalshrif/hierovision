"""
Extensions module.
Each extension is initialized in the app factory located in app/__init__.py
"""
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
from flask_jwt_extended import JWTManager

# Create extensions objects
db = SQLAlchemy()
cors = CORS()
jwt = JWTManager()
