from flask import Blueprint, request, jsonify
from app.extensions import db
from app.models.user import User
from app.utils.auth import hash_password, check_password, generate_token, blacklist_token, token_required
import logging

auth_bp = Blueprint('auth', __name__, url_prefix='/auth')
logger = logging.getLogger(__name__)


@auth_bp.route('/register', methods=['POST'])
def register():
    """Register a new user."""
    try:
        data = request.get_json()
        
        # Validate input
        full_name = data.get('fullName', '').strip()
        email = data.get('email', '').strip().lower()
        password = data.get('password', '')
        
        if not all([full_name, email, password]):
            return jsonify({
                'success': False, 
                'message': 'All fields are required'
            }), 400
        
        # Validate email format
        if '@' not in email or '.' not in email:
            return jsonify({
                'success': False, 
                'message': 'Invalid email format'
            }), 400
        
        # Validate password length
        if len(password) < 6:
            return jsonify({
                'success': False, 
                'message': 'Password must be at least 6 characters long'
            }), 400
        
        # Check if user already exists
        existing_user = User.query.filter_by(email=email).first()
        if existing_user:
            return jsonify({
                'success': False, 
                'message': 'Email already in use'
            }), 409
        
        # Create new user
        password_hash = hash_password(password)
        
        new_user = User(
            full_name=full_name,
            email=email,
            password_hash=password_hash
        )
        
        db.session.add(new_user)
        db.session.commit()
        
        logger.info(f"New user registered: {email}")
        
        return jsonify({
            'success': True, 
            'message': 'Registration successful'
        }), 201
        
    except Exception as e:
        db.session.rollback()
        logger.error(f"Registration error: {e}")
        return jsonify({
            'success': False, 
            'message': 'Registration failed'
        }), 500


@auth_bp.route('/login', methods=['POST'])
def login():
    """Authenticate user and return JWT token."""
    try:
        data = request.get_json()
        
        # Validate input
        email = data.get('email', '').strip().lower()
        password = data.get('password', '')
        
        if not all([email, password]):
            return jsonify({
                'success': False, 
                'message': 'Email and password are required'
            }), 400
        
        # Find user
        user = User.query.filter_by(email=email).first()
        
        if not user or not check_password(password, user.password_hash):
            return jsonify({
                'success': False, 
                'message': 'Invalid email or password'
            }), 401
        
        # Generate token
        token = generate_token(user.uid)
        
        logger.info(f"User logged in: {email}")
        
        return jsonify({
            'success': True,
            'token': token,
            'user': user.to_dict()
        }), 200
        
    except Exception as e:
        logger.error(f"Login error: {e}")
        return jsonify({
            'success': False, 
            'message': 'Login failed'
        }), 500


@auth_bp.route('/logout', methods=['POST'])
@token_required
def logout(user):
    """Logout user by blacklisting their token."""
    try:
        # Get token from request header
        token = request.headers.get('Authorization').split(' ')[1]
        
        # Decode token to get JTI
        import jwt
        from flask import current_app
        payload = jwt.decode(token, current_app.config['SECRET_KEY'], algorithms=['HS256'])
        
        # Blacklist the token
        blacklist_token(payload['jti'])
        
        logger.info(f"User logged out: {user.email}")
        
        return jsonify({
            'success': True, 
            'message': 'Logged out successfully'
        }), 200
        
    except Exception as e:
        logger.error(f"Logout error: {e}")
        return jsonify({
            'success': False, 
            'message': 'Logout failed'
        }), 500


@auth_bp.route('/verify', methods=['GET'])
@token_required
def verify_auth(user):
    """Verify token and return user info."""
    return jsonify({
        'success': True, 
        'user': user.to_dict()
    }), 200


@auth_bp.route('/reset-password', methods=['POST'])
def reset_password():
    """Initiate password reset process."""
    try:
        data = request.get_json()
        email = data.get('email', '').strip().lower()
        
        if not email:
            return jsonify({
                'success': False, 
                'message': 'Email is required'
            }), 400
        
        # Check if user exists
        user = User.query.filter_by(email=email).first()
        
        # For security, always return success even if user doesn't exist
        # In a real implementation, you would send an email here
        logger.info(f"Password reset requested for: {email}")
        
        return jsonify({
            'success': True,
            'message': 'If the email exists, a reset link has been sent'
        }), 200
        
    except Exception as e:
        logger.error(f"Password reset error: {e}")
        return jsonify({
            'success': False, 
            'message': 'Password reset failed'
        }), 500


@auth_bp.route('/change-password', methods=['PUT'])
@token_required
def change_password(user):
    """Change user password."""
    try:
        data = request.get_json()
        current_password = data.get('currentPassword', '')
        new_password = data.get('newPassword', '')
        
        if not all([current_password, new_password]):
            return jsonify({
                'success': False, 
                'message': 'Current and new passwords are required'
            }), 400
        
        # Verify current password
        if not check_password(current_password, user.password_hash):
            return jsonify({
                'success': False, 
                'message': 'Current password is incorrect'
            }), 401
        
        # Validate new password
        if len(new_password) < 6:
            return jsonify({
                'success': False, 
                'message': 'New password must be at least 6 characters long'
            }), 400
        
        # Update password
        user.password_hash = hash_password(new_password)
        db.session.commit()
        
        logger.info(f"Password changed for user: {user.email}")
        
        return jsonify({
            'success': True, 
            'message': 'Password changed successfully'
        }), 200
        
    except Exception as e:
        db.session.rollback()
        logger.error(f"Change password error: {e}")
        return jsonify({
            'success': False, 
            'message': 'Failed to change password'
        }), 500
