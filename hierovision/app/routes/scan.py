from flask import Blueprint, request, jsonify
from app.extensions import db
from app.models.scan import Scan
from app.utils.auth import token_required, optional_token
from app.utils.file_handler import save_uploaded_file, delete_file
from app.services.ml_service import get_predictor
import logging

scan_bp = Blueprint('scan', __name__, url_prefix='/scans')
logger = logging.getLogger(__name__)


@scan_bp.route('/save', methods=['POST'])
@token_required
def save_scan(user):
    """Save a new scan with image and description (handles both file upload and JSON data)."""
    try:
        # Check if it's a file upload or JSON data
        if request.content_type and 'application/json' in request.content_type:
            # Handle JSON data (from translation results)
            data = request.get_json()
            
            if not data:
                return jsonify({
                    'success': False, 
                    'message': 'No data provided'
                }), 400
            
            # Extract data from request
            image_path = data.get('image_path', '')
            description = data.get('description', '').strip()
            confidence = data.get('confidence', 0)
            translation = data.get('translation', '')
            
            # Use translation as description if no description provided
            if not description and translation:
                if isinstance(translation, dict):
                    description = translation.get('description') or translation.get('text') or str(translation)
                else:
                    description = str(translation)
            
            if not description:
                return jsonify({
                    'success': False, 
                    'message': 'Description or translation is required'
                }), 400
            
            # Create new scan record from JSON data
            new_scan = Scan(
                user_uid=user.uid,
                image_url=image_path or 'translation_result.jpg',
                description=description,
                predicted_class=None,
                confidence_score=confidence / 100.0 if confidence > 1 else confidence
            )
            
        else:
            # Handle file upload
            if 'file' not in request.files:
                return jsonify({
                    'success': False, 
                    'message': 'No file provided'
                }), 400
            
            file = request.files['file']
            description = request.form.get('description', '').strip()
            
            # Save the uploaded file
            success, file_url, error_message = save_uploaded_file(
                file, 'scans', user.uid
            )
            
            if not success:
                return jsonify({
                    'success': False, 
                    'message': error_message
                }), 400
            
            # Optional: Run prediction on the uploaded image
            predicted_class = None
            confidence_score = None
            
            try:
                predictor = get_predictor()
                file.seek(0)  # Reset file pointer
                prediction_result = predictor.predict(file)
                
                if prediction_result['success']:
                    predicted_class = prediction_result['predicted_class_index']
                    confidence_score = prediction_result['confidence_score']
                    
                    # If no description provided, use prediction description
                    if not description and prediction_result['description']:
                        description = f"{prediction_result['description']['code']}: {prediction_result['description']['description']}"
                        
            except Exception as pred_error:
                logger.warning(f"Prediction failed for scan: {pred_error}")
                # Continue saving without prediction
            
            # Create new scan record from file upload
            new_scan = Scan(
                user_uid=user.uid,
                image_url=file_url,
                description=description or 'Hieroglyph scan',
                predicted_class=predicted_class,
                confidence_score=confidence_score
            )
        
        db.session.add(new_scan)
        db.session.commit()
        
        logger.info(f"Scan saved for user {user.email}: {new_scan.id}")
        
        return jsonify({
            'success': True,
            'message': 'Scan saved successfully',
            'scan': new_scan.to_dict()
        }), 201
        
    except Exception as e:
        db.session.rollback()
        logger.error(f"Save scan error: {e}")
        return jsonify({
            'success': False, 
            'message': 'Failed to save scan'
        }), 500


@scan_bp.route('/user', methods=['GET'])
@token_required
def get_user_scans(user):
    """Get all scans for the authenticated user."""
    try:
        # Get pagination parameters
        page = request.args.get('page', 1, type=int)
        per_page = min(request.args.get('per_page', 20, type=int), 100)  # Max 100 per page
        
        # Query user's scans with pagination
        scans_query = Scan.query.filter_by(user_uid=user.uid).order_by(Scan.timestamp.desc())
        paginated_scans = scans_query.paginate(
            page=page, per_page=per_page, error_out=False
        )
        
        scans_list = [scan.to_dict() for scan in paginated_scans.items]
        
        return jsonify({
            'success': True,
            'scans': scans_list,
            'pagination': {
                'page': page,
                'per_page': per_page,
                'total': paginated_scans.total,
                'pages': paginated_scans.pages,
                'has_next': paginated_scans.has_next,
                'has_prev': paginated_scans.has_prev
            }
        }), 200
        
    except Exception as e:
        logger.error(f"Get scans error: {e}")
        return jsonify({
            'success': False, 
            'message': 'Failed to get scans'
        }), 500


@scan_bp.route('/<scan_id>', methods=['GET'])
@token_required
def get_scan_by_id(user, scan_id):
    """Get a specific scan by ID."""
    try:
        scan = Scan.query.filter_by(id=scan_id, user_uid=user.uid).first()
        
        if not scan:
            return jsonify({
                'success': False, 
                'message': 'Scan not found'
            }), 404
        
        return jsonify({
            'success': True,
            'scan': scan.to_dict()
        }), 200
        
    except Exception as e:
        logger.error(f"Get scan by ID error: {e}")
        return jsonify({
            'success': False, 
            'message': 'Failed to get scan'
        }), 500


@scan_bp.route('/<scan_id>', methods=['PUT'])
@token_required
def update_scan(user, scan_id):
    """Update a scan's description."""
    try:
        scan = Scan.query.filter_by(id=scan_id, user_uid=user.uid).first()
        
        if not scan:
            return jsonify({
                'success': False, 
                'message': 'Scan not found'
            }), 404
        
        data = request.get_json()
        new_description = data.get('description', '').strip()
        
        if not new_description:
            return jsonify({
                'success': False, 
                'message': 'Description is required'
            }), 400
        
        scan.description = new_description
        db.session.commit()
        
        logger.info(f"Scan updated by user {user.email}: {scan_id}")
        
        return jsonify({
            'success': True,
            'message': 'Scan updated successfully',
            'scan': scan.to_dict()
        }), 200
        
    except Exception as e:
        db.session.rollback()
        logger.error(f"Update scan error: {e}")
        return jsonify({
            'success': False, 
            'message': 'Failed to update scan'
        }), 500


@scan_bp.route('/<scan_id>', methods=['DELETE'])
@token_required
def delete_scan(user, scan_id):
    """Delete a scan."""
    try:
        scan = Scan.query.filter_by(id=scan_id, user_uid=user.uid).first()
        
        if not scan:
            return jsonify({
                'success': False, 
                'message': 'Scan not found'
            }), 404
        
        # Delete the image file
        if scan.image_url:
            delete_file(scan.image_url)
        
        # Delete from database
        db.session.delete(scan)
        db.session.commit()
        
        logger.info(f"Scan deleted by user {user.email}: {scan_id}")
        
        return jsonify({
            'success': True, 
            'message': 'Scan deleted successfully'
        }), 200
        
    except Exception as e:
        db.session.rollback()
        logger.error(f"Delete scan error: {e}")
        return jsonify({
            'success': False, 
            'message': 'Failed to delete scan'
        }), 500


@scan_bp.route('/search', methods=['GET'])
@token_required
def search_scans(user):
    """Search user's scans by description."""
    try:
        query = request.args.get('q', '').strip()
        page = request.args.get('page', 1, type=int)
        per_page = min(request.args.get('per_page', 20, type=int), 100)
        
        if not query:
            return jsonify({
                'success': False, 
                'message': 'Search query is required'
            }), 400
        
        # Search in descriptions
        scans_query = Scan.query.filter(
            Scan.user_uid == user.uid,
            Scan.description.contains(query)
        ).order_by(Scan.timestamp.desc())
        
        paginated_scans = scans_query.paginate(
            page=page, per_page=per_page, error_out=False
        )
        
        scans_list = [scan.to_dict() for scan in paginated_scans.items]
        
        return jsonify({
            'success': True,
            'scans': scans_list,
            'query': query,
            'pagination': {
                'page': page,
                'per_page': per_page,
                'total': paginated_scans.total,
                'pages': paginated_scans.pages,
                'has_next': paginated_scans.has_next,
                'has_prev': paginated_scans.has_prev
            }
        }), 200
        
    except Exception as e:
        logger.error(f"Search scans error: {e}")
        return jsonify({
            'success': False, 
            'message': 'Failed to search scans'
        }), 500


@scan_bp.route('/recent', methods=['GET'])
@optional_token
def get_recent_scans(user):
    """Get recent scans (public endpoint with optional authentication)."""
    try:
        limit = min(request.args.get('limit', 10, type=int), 50)  # Max 50
        
        if user:
            # If authenticated, get user's recent scans
            scans = Scan.query.filter_by(user_uid=user.uid)\
                             .order_by(Scan.timestamp.desc())\
                             .limit(limit).all()
        else:
            # If not authenticated, could return public scans or empty list
            # For now, return empty list for unauthenticated users
            scans = []
        
        scans_list = [scan.to_dict() for scan in scans]
        
        return jsonify({
            'success': True,
            'scans': scans_list
        }), 200
        
    except Exception as e:
        logger.error(f"Get recent scans error: {e}")
        return jsonify({
            'success': False, 
            'message': 'Failed to get recent scans'
        }), 500
