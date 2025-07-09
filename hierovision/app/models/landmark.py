from app.extensions import db
from datetime import datetime

class Landmark(db.Model):
    __tablename__ = 'landmarks'
    
    id = db.Column(db.String(36), primary_key=True)
    name = db.Column(db.String(200), nullable=False)
    location = db.Column(db.String(100), nullable=False)
    type = db.Column(db.String(50), nullable=False)
    description = db.Column(db.Text, nullable=False)
    image = db.Column(db.String(500), nullable=False)
    hieroglyph_name = db.Column(db.String(100), nullable=False)
    price = db.Column(db.Float, nullable=False, default=0.0)
    tours = db.Column(db.JSON, nullable=True)  # Store as JSON array
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # Relationships
    bookmarks = db.relationship('Bookmark', backref='landmark', lazy=True, cascade='all, delete-orphan')
    reviews = db.relationship('Review', backref='landmark', lazy=True, cascade='all, delete-orphan')
    bookings = db.relationship('Booking', backref='landmark', lazy=True)
    
    def to_dict(self, include_stats=True):
        data = {
            'id': self.id,
            'name': self.name,
            'location': self.location,
            'type': self.type,
            'description': self.description,
            'image': self.image,
            'hieroglyphName': self.hieroglyph_name,
            'price': self.price,
            'tours': self.tours or [],
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None
        }
        
        if include_stats:
            # Calculate average rating and review count
            if self.reviews:
                ratings = [review.rating for review in self.reviews]
                data['averageRating'] = sum(ratings) / len(ratings)
                data['reviewCount'] = len(ratings)
            else:
                data['averageRating'] = 0
                data['reviewCount'] = 0
                
        return data

class Bookmark(db.Model):
    __tablename__ = 'bookmarks'
    
    id = db.Column(db.String(36), primary_key=True)
    user_id = db.Column(db.String(36), db.ForeignKey('users.uid'), nullable=False)
    landmark_id = db.Column(db.String(36), db.ForeignKey('landmarks.id'), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    
    # Unique constraint to prevent duplicate bookmarks
    __table_args__ = (db.UniqueConstraint('user_id', 'landmark_id', name='unique_user_landmark_bookmark'),)
    
    def to_dict(self):
        return {
            'id': self.id,
            'user_id': self.user_id,
            'landmark_id': self.landmark_id,
            'created_at': self.created_at.isoformat() if self.created_at else None
        }

class Review(db.Model):
    __tablename__ = 'reviews'
    
    id = db.Column(db.String(36), primary_key=True)
    user_id = db.Column(db.String(36), db.ForeignKey('users.uid'), nullable=False)
    landmark_id = db.Column(db.String(36), db.ForeignKey('landmarks.id'), nullable=False)
    rating = db.Column(db.Integer, nullable=False)  # 1-5 stars
    comment = db.Column(db.Text, nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # Unique constraint to allow only one review per user per landmark
    __table_args__ = (db.UniqueConstraint('user_id', 'landmark_id', name='unique_user_landmark_review'),)
    
    def to_dict(self):
        return {
            'id': self.id,
            'user_id': self.user_id,
            'landmark_id': self.landmark_id,
            'user_name': self.user.full_name if self.user else 'Anonymous',
            'rating': self.rating,
            'comment': self.comment,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None
        }

class Booking(db.Model):
    __tablename__ = 'bookings'
    
    id = db.Column(db.String(36), primary_key=True)
    user_id = db.Column(db.String(36), db.ForeignKey('users.uid'), nullable=False)
    landmark_id = db.Column(db.String(36), db.ForeignKey('landmarks.id'), nullable=False)
    date = db.Column(db.DateTime, nullable=False)
    visitors = db.Column(db.Integer, nullable=False, default=1)
    tour_type = db.Column(db.String(100), nullable=False)
    total_price = db.Column(db.Float, nullable=False)
    contact_name = db.Column(db.String(100), nullable=False)
    contact_email = db.Column(db.String(100), nullable=False)
    contact_phone = db.Column(db.String(20), nullable=True)
    status = db.Column(db.String(20), nullable=False, default='pending')  # pending, confirmed, cancelled
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    def to_dict(self):
        return {
            'id': self.id,
            'user_id': self.user_id,
            'landmark_id': self.landmark_id,
            'landmark_name': self.landmark.name if self.landmark else None,
            'date': self.date.isoformat() if self.date else None,
            'visitors': self.visitors,
            'tour_type': self.tour_type,
            'total_price': self.total_price,
            'contact_name': self.contact_name,
            'contact_email': self.contact_email,
            'contact_phone': self.contact_phone,
            'status': self.status,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None
        }
