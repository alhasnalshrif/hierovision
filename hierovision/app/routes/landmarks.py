from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from app.models.landmark import Landmark, Bookmark, Review, Booking
from app.models.user import User
from app.extensions import db
import uuid
from datetime import datetime

landmarks_bp = Blueprint('landmarks', __name__)

@landmarks_bp.route('/landmarks', methods=['GET'])
def get_landmarks():
    """Get all landmarks with statistics"""
    try:
        landmarks = Landmark.query.all()
        return jsonify({
            'landmarks': [landmark.to_dict() for landmark in landmarks],
            'total': len(landmarks)
        }), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@landmarks_bp.route('/landmarks/<landmark_id>', methods=['GET'])
def get_landmark(landmark_id):
    """Get a specific landmark by ID"""
    try:
        landmark = Landmark.query.get_or_404(landmark_id)
        return jsonify({'landmark': landmark.to_dict()}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@landmarks_bp.route('/landmarks/<landmark_id>/reviews', methods=['GET'])
def get_landmark_reviews(landmark_id):
    """Get all reviews for a specific landmark"""
    try:
        landmark = Landmark.query.get_or_404(landmark_id)
        reviews = Review.query.filter_by(landmark_id=landmark_id).order_by(Review.created_at.desc()).all()
        
        return jsonify({
            'reviews': [review.to_dict() for review in reviews],
            'total': len(reviews)
        }), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@landmarks_bp.route('/landmarks/<landmark_id>/reviews', methods=['POST'])
@jwt_required()
def add_review(landmark_id):
    """Add a review for a landmark"""
    try:
        current_user_id = get_jwt_identity()
        data = request.get_json()
        
        # Validate input
        if not data or 'rating' not in data or 'comment' not in data:
            return jsonify({'error': 'Rating and comment are required'}), 400
        
        rating = data['rating']
        comment = data['comment'].strip()
        
        if not (1 <= rating <= 5):
            return jsonify({'error': 'Rating must be between 1 and 5'}), 400
        
        if not comment:
            return jsonify({'error': 'Comment cannot be empty'}), 400
        
        # Check if landmark exists
        landmark = Landmark.query.get_or_404(landmark_id)
        
        # Check if user already reviewed this landmark
        existing_review = Review.query.filter_by(
            user_id=current_user_id, 
            landmark_id=landmark_id
        ).first()
        
        if existing_review:
            return jsonify({'error': 'You have already reviewed this landmark'}), 400
        
        # Create new review
        review = Review(
            id=str(uuid.uuid4()),
            user_id=current_user_id,
            landmark_id=landmark_id,
            rating=rating,
            comment=comment
        )
        
        db.session.add(review)
        db.session.commit()
        
        return jsonify({'review': review.to_dict()}), 201
        
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@landmarks_bp.route('/reviews/<review_id>', methods=['PUT'])
@jwt_required()
def update_review(review_id):
    """Update a review"""
    try:
        current_user_id = get_jwt_identity()
        data = request.get_json()
        
        review = Review.query.get_or_404(review_id)
        
        # Check if user owns this review
        if review.user_id != current_user_id:
            return jsonify({'error': 'You can only update your own reviews'}), 403
        
        # Validate input
        if not data or 'rating' not in data or 'comment' not in data:
            return jsonify({'error': 'Rating and comment are required'}), 400
        
        rating = data['rating']
        comment = data['comment'].strip()
        
        if not (1 <= rating <= 5):
            return jsonify({'error': 'Rating must be between 1 and 5'}), 400
        
        if not comment:
            return jsonify({'error': 'Comment cannot be empty'}), 400
        
        # Update review
        review.rating = rating
        review.comment = comment
        review.updated_at = datetime.utcnow()
        
        db.session.commit()
        
        return jsonify({'review': review.to_dict()}), 200
        
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@landmarks_bp.route('/reviews/<review_id>', methods=['DELETE'])
@jwt_required()
def delete_review(review_id):
    """Delete a review"""
    try:
        current_user_id = get_jwt_identity()
        review = Review.query.get_or_404(review_id)
        
        # Check if user owns this review
        if review.user_id != current_user_id:
            return jsonify({'error': 'You can only delete your own reviews'}), 403
        
        db.session.delete(review)
        db.session.commit()
        
        return jsonify({'message': 'Review deleted successfully'}), 200
        
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@landmarks_bp.route('/bookmarks', methods=['GET'])
@jwt_required()
def get_bookmarks():
    """Get user's bookmarks"""
    try:
        current_user_id = get_jwt_identity()
        bookmarks = Bookmark.query.filter_by(user_id=current_user_id).all()
        
        return jsonify({
            'bookmarks': [bookmark.to_dict() for bookmark in bookmarks],
            'total': len(bookmarks)
        }), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@landmarks_bp.route('/bookmarks', methods=['POST'])
@jwt_required()
def add_bookmark():
    """Add a bookmark"""
    try:
        current_user_id = get_jwt_identity()
        data = request.get_json()
        
        if not data or 'landmark_id' not in data:
            return jsonify({'error': 'Landmark ID is required'}), 400
        
        landmark_id = data['landmark_id']
        
        # Check if landmark exists
        landmark = Landmark.query.get_or_404(landmark_id)
        
        # Check if bookmark already exists
        existing_bookmark = Bookmark.query.filter_by(
            user_id=current_user_id,
            landmark_id=landmark_id
        ).first()
        
        if existing_bookmark:
            return jsonify({'error': 'Landmark already bookmarked'}), 400
        
        # Create new bookmark
        bookmark = Bookmark(
            id=str(uuid.uuid4()),
            user_id=current_user_id,
            landmark_id=landmark_id
        )
        
        db.session.add(bookmark)
        db.session.commit()
        
        return jsonify({'bookmark': bookmark.to_dict()}), 201
        
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@landmarks_bp.route('/bookmarks/<landmark_id>', methods=['DELETE'])
@jwt_required()
def remove_bookmark(landmark_id):
    """Remove a bookmark"""
    try:
        current_user_id = get_jwt_identity()
        
        bookmark = Bookmark.query.filter_by(
            user_id=current_user_id,
            landmark_id=landmark_id
        ).first()
        
        if not bookmark:
            return jsonify({'error': 'Bookmark not found'}), 404
        
        db.session.delete(bookmark)
        db.session.commit()
        
        return jsonify({'message': 'Bookmark removed successfully'}), 200
        
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@landmarks_bp.route('/bookings', methods=['GET'])
@jwt_required()
def get_bookings():
    """Get user's bookings"""
    try:
        current_user_id = get_jwt_identity()
        bookings = Booking.query.filter_by(user_id=current_user_id).order_by(Booking.created_at.desc()).all()
        
        return jsonify({
            'bookings': [booking.to_dict() for booking in bookings],
            'total': len(bookings)
        }), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@landmarks_bp.route('/bookings', methods=['POST'])
@jwt_required()
def create_booking():
    """Create a new booking"""
    try:
        current_user_id = get_jwt_identity()
        data = request.get_json()
        
        # Validate required fields
        required_fields = ['landmark_id', 'date', 'visitors', 'tour_type', 'total_price', 'contact_name', 'contact_email']
        for field in required_fields:
            if not data or field not in data:
                return jsonify({'error': f'{field} is required'}), 400
        
        # Check if landmark exists
        landmark = Landmark.query.get_or_404(data['landmark_id'])
        
        # Parse date
        try:
            booking_date = datetime.fromisoformat(data['date'].replace('Z', '+00:00'))
        except:
            return jsonify({'error': 'Invalid date format'}), 400
        
        # Create new booking
        booking = Booking(
            id=str(uuid.uuid4()),
            user_id=current_user_id,
            landmark_id=data['landmark_id'],
            date=booking_date,
            visitors=int(data['visitors']),
            tour_type=data['tour_type'],
            total_price=float(data['total_price']),
            contact_name=data['contact_name'],
            contact_email=data['contact_email'],
            contact_phone=data.get('contact_phone', ''),
            status='pending'
        )
        
        db.session.add(booking)
        db.session.commit()
        
        return jsonify({'booking': booking.to_dict()}), 201
        
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@landmarks_bp.route('/bookings/<booking_id>', methods=['GET'])
@jwt_required()
def get_booking(booking_id):
    """Get a specific booking"""
    try:
        current_user_id = get_jwt_identity()
        booking = Booking.query.filter_by(id=booking_id, user_id=current_user_id).first_or_404()
        
        return jsonify({'booking': booking.to_dict()}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@landmarks_bp.route('/bookings/<booking_id>', methods=['PUT'])
@jwt_required()
def update_booking(booking_id):
    """Update booking status"""
    try:
        current_user_id = get_jwt_identity()
        booking = Booking.query.filter_by(id=booking_id, user_id=current_user_id).first_or_404()
        
        data = request.get_json()
        if not data:
            return jsonify({'error': 'No data provided'}), 400
        
        # Update status if provided
        if 'status' in data:
            booking.status = data['status']
        
        # Update other fields if needed
        if 'contact_phone' in data:
            booking.contact_phone = data['contact_phone']
        
        booking.updated_at = datetime.utcnow()
        db.session.commit()
        
        return jsonify({'booking': booking.to_dict()}), 200
        
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@landmarks_bp.route('/bookings/<booking_id>/payment', methods=['POST'])
@jwt_required()
def process_payment(booking_id):
    """Process payment for a booking"""
    try:
        current_user_id = get_jwt_identity()
        booking = Booking.query.filter_by(id=booking_id, user_id=current_user_id).first_or_404()
        
        data = request.get_json()
        if not data:
            return jsonify({'error': 'Payment data required'}), 400
        
        # Here you would integrate with a real payment processor
        # For now, we'll simulate payment processing
        
        payment_method = data.get('payment_method', 'credit_card')
        
        # Simulate payment processing (replace with real payment gateway)
        if payment_method in ['credit_card', 'paypal', 'apple_pay']:
            # Update booking status to confirmed
            booking.status = 'confirmed'
            booking.updated_at = datetime.utcnow()
            db.session.commit()
            
            return jsonify({
                'success': True,
                'message': 'Payment processed successfully',
                'booking': booking.to_dict(),
                'payment_method': payment_method
            }), 200
        else:
            return jsonify({'error': 'Invalid payment method'}), 400
        
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500
