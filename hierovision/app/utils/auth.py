import bcrypt
import jwt
import uuid
from datetime import datetime, timedelta
from functools import wraps
from flask import request, jsonify, current_app
from app.extensions import db
from app.models.user import User
from app.models.token import BlacklistedToken


def hash_password(password):
    """Hash a password using bcrypt."""
    return bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt())


def check_password(password, hashed):
    """Verify a password against its hash."""
    return bcrypt.checkpw(password.encode('utf-8'), hashed)


def generate_token(user_uid):
    """Generate a JWT token for a user."""
    payload = {
        'sub': user_uid,  # Use 'sub' claim for Flask-JWT-Extended compatibility
        'user_uid': user_uid,  # Keep this for backward compatibility if needed
        'iat': datetime.utcnow(),
        'exp': datetime.utcnow() + current_app.config['JWT_EXPIRATION_DELTA'],
        'jti': str(uuid.uuid4())  # JWT ID for blacklisting
    }
    return jwt.encode(payload, current_app.config['SECRET_KEY'], algorithm='HS256')


def verify_token(token):
    """Verify and decode a JWT token."""
    try:
        payload = jwt.decode(token, current_app.config['SECRET_KEY'], algorithms=['HS256'])
        
        # Check if token is blacklisted
        if BlacklistedToken.is_jti_blacklisted(payload['jti']):
            return None
            
        return payload
    except jwt.ExpiredSignatureError:
        return None
    except jwt.InvalidTokenError:
        return None


def blacklist_token(jti):
    """Blacklist a token by its JWT ID."""
    blacklisted_token = BlacklistedToken(jti=jti)
    db.session.add(blacklisted_token)
    db.session.commit()


def token_required(f):
    """Decorator to require valid JWT token for route access."""
    @wraps(f)
    def decorated(*args, **kwargs):
        token = request.headers.get('Authorization')
        
        if not token:
            return jsonify({'success': False, 'message': 'Token is missing'}), 401
        
        try:
            # Remove 'Bearer ' prefix
            token = token.split(' ')[1]
        except IndexError:
            return jsonify({'success': False, 'message': 'Invalid token format'}), 401
        
        payload = verify_token(token)
        if not payload:
            return jsonify({'success': False, 'message': 'Token is invalid or expired'}), 401
        
        # Get user from database
        user = User.query.get(payload['user_uid'])
        if not user:
            return jsonify({'success': False, 'message': 'User not found'}), 401
        
        return f(user, *args, **kwargs)
    return decorated


def optional_token(f):
    """Decorator for routes where token is optional."""
    @wraps(f)
    def decorated(*args, **kwargs):
        user = None
        token = request.headers.get('Authorization')
        
        if token:
            try:
                token = token.split(' ')[1]
                payload = verify_token(token)
                if payload:
                    user = User.query.get(payload['user_uid'])
            except:
                pass  # Continue without authentication
        
        return f(user, *args, **kwargs)
    return decorated
