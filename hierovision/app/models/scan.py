from datetime import datetime
import uuid
from app.extensions import db


class Scan(db.Model):
    """Scan model for storing user's hieroglyph scans."""
    
    __tablename__ = 'scans'
    
    id = db.Column(db.String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    user_uid = db.Column(db.String(36), db.ForeignKey('users.uid'), nullable=False)
    image_url = db.Column(db.String(255), nullable=False)
    description = db.Column(db.Text, nullable=False)
    predicted_class = db.Column(db.Integer)
    confidence_score = db.Column(db.Float)
    timestamp = db.Column(db.DateTime, default=datetime.utcnow, index=True)
    
    def __repr__(self):
        return f'<Scan {self.id}>'
    
    def to_dict(self):
        """Convert scan object to dictionary."""
        return {
            'id': self.id,
            'user_uid': self.user_uid,
            'image_url': self.image_url,
            'description': self.description,
            'predicted_class': self.predicted_class,
            'confidence_score': self.confidence_score,
            'timestamp': self.timestamp.isoformat() if self.timestamp else None
        }
