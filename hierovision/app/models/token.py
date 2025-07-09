from datetime import datetime
from app.extensions import db


class BlacklistedToken(db.Model):
    """Model for storing blacklisted JWT tokens."""
    
    __tablename__ = 'blacklisted_tokens'
    
    id = db.Column(db.Integer, primary_key=True)
    jti = db.Column(db.String(36), nullable=False, unique=True)  # JWT ID
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    
    def __repr__(self):
        return f'<BlacklistedToken {self.jti}>'
    
    @staticmethod
    def is_jti_blacklisted(jti):
        """Check if a JWT ID is blacklisted."""
        return BlacklistedToken.query.filter_by(jti=jti).first() is not None
