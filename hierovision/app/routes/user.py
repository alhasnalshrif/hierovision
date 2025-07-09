from flask import Blueprint, request, jsonify
from app.extensions import db
from app.models.user import User
from app.utils.auth import token_required
from app.utils.file_handler import save_uploaded_file, delete_file
import logging

user_bp = Blueprint('user', __name__, url_prefix='/user')
logger = logging.getLogger(__name__)


@user_bp.route('/profile', methods=['GET'])
@token_required
def get_user_profile(user):
    """Get user profile information."""
    try:
        return jsonify({
            'success': True,
            'user': user.to_dict()
        }), 200
        
    except Exception as e:
        logger.error(f"Get profile error: {e}")
        return jsonify({
            'success': False, 
            'message': 'Failed to get profile'
        }), 500


@user_bp.route('/profile', methods=['PUT'])
@token_required
def update_user_profile(user):
    """Update user profile information."""
    try:
        data = request.get_json()
        
        # List of allowed fields to update
        allowed_fields = ['fullName', 'selectedCountry']
        updated = False
        
        for field in allowed_fields:
            if field in data and data[field] is not None:
                # Map camelCase to snake_case for database fields
                db_field = field
                if field == 'fullName':
                    db_field = 'full_name'
                elif field == 'selectedCountry':
                    db_field = 'selected_country'
                
                setattr(user, db_field, data[field].strip())
                updated = True
        
        if not updated:
            return jsonify({
                'success': False, 
                'message': 'No valid fields to update'
            }), 400
        
        db.session.commit()
        
        logger.info(f"Profile updated for user: {user.email}")
        
        return jsonify({
            'success': True, 
            'message': 'Profile updated successfully',
            'user': user.to_dict()
        }), 200
        
    except Exception as e:
        db.session.rollback()
        logger.error(f"Update profile error: {e}")
        return jsonify({
            'success': False, 
            'message': 'Failed to update profile'
        }), 500


@user_bp.route('/country', methods=['PUT'])
@token_required
def update_user_country(user):
    """Update user's selected country."""
    try:
        data = request.get_json()
        selected_country = data.get('selectedCountry', '').strip()
        
        if not selected_country:
            return jsonify({
                'success': False, 
                'message': 'Selected country is required'
            }), 400
        
        user.selected_country = selected_country
        db.session.commit()
        
        logger.info(f"Country updated for user {user.email}: {selected_country}")
        
        return jsonify({
            'success': True, 
            'message': 'Country updated successfully'
        }), 200
        
    except Exception as e:
        db.session.rollback()
        logger.error(f"Update country error: {e}")
        return jsonify({
            'success': False, 
            'message': 'Failed to update country'
        }), 500


@user_bp.route('/avatar', methods=['POST'])
@token_required
def update_user_avatar(user):
    """Upload and update user avatar."""
    try:
        if 'file' not in request.files:
            return jsonify({
                'success': False, 
                'message': 'No file provided'
            }), 400
        
        file = request.files['file']
        
        # Save the uploaded file
        success, file_url, error_message = save_uploaded_file(
            file, 'avatars', user.uid
        )
        
        if not success:
            return jsonify({
                'success': False, 
                'message': error_message
            }), 400
        
        # Delete old avatar if it exists
        if user.avatar_url:
            delete_file(user.avatar_url)
        
        # Update user avatar URL
        user.avatar_url = file_url
        db.session.commit()
        
        logger.info(f"Avatar updated for user: {user.email}")
        
        return jsonify({
            'success': True,
            'message': 'Avatar updated successfully',
            'avatarURL': file_url
        }), 200
        
    except Exception as e:
        db.session.rollback()
        logger.error(f"Update avatar error: {e}")
        return jsonify({
            'success': False, 
            'message': 'Failed to update avatar'
        }), 500


@user_bp.route('/avatar', methods=['DELETE'])
@token_required
def delete_user_avatar(user):
    """Delete user avatar."""
    try:
        if not user.avatar_url:
            return jsonify({
                'success': False, 
                'message': 'No avatar to delete'
            }), 400
        
        # Delete the file
        delete_file(user.avatar_url)
        
        # Update user record
        user.avatar_url = None
        db.session.commit()
        
        logger.info(f"Avatar deleted for user: {user.email}")
        
        return jsonify({
            'success': True, 
            'message': 'Avatar deleted successfully'
        }), 200
        
    except Exception as e:
        db.session.rollback()
        logger.error(f"Delete avatar error: {e}")
        return jsonify({
            'success': False, 
            'message': 'Failed to delete avatar'
        }), 500


@user_bp.route('/stats', methods=['GET'])
@token_required
def get_user_stats(user):
    """Get user statistics."""
    try:
        from app.models.scan import Scan
        
        # Count user's scans
        total_scans = Scan.query.filter_by(user_uid=user.uid).count()
        
        # Get recent scans count (last 30 days)
        from datetime import datetime, timedelta
        thirty_days_ago = datetime.utcnow() - timedelta(days=30)
        recent_scans = Scan.query.filter(
            Scan.user_uid == user.uid,
            Scan.timestamp >= thirty_days_ago
        ).count()
        
        stats = {
            'total_scans': total_scans,
            'recent_scans': recent_scans,
            'member_since': user.created_at.isoformat() if user.created_at else None,
            'selected_country': user.selected_country
        }
        
        return jsonify({
            'success': True,
            'stats': stats
        }), 200
        
    except Exception as e:
        logger.error(f"Get stats error: {e}")
        return jsonify({
            'success': False, 
            'message': 'Failed to get user statistics'
        }), 500
