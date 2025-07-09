from flask import Flask, jsonify
from config import Config
from app.extensions import db, cors, jwt
import uuid

def seed_landmarks():
    """Seed initial landmark data"""
    from app.models.landmark import Landmark
    
    landmarks_data = [
        {
            'id': str(uuid.uuid4()),
            'name': 'Great Pyramid of Giza',
            'location': 'Giza',
            'type': 'pyramid',
            'description': 'The last remaining wonder of the ancient world, built for Pharaoh Khufu around 2580-2560 BCE.',
            'image': 'https://images.unsplash.com/photo-1482881497185-d4a9ddbe4151?auto=format&fit=crop&w=800&h=600',
            'hieroglyph_name': '𓉴 𓊪 𓇳',
            'price': 150.0,
            'tours': ['Standard Tour', 'VIP Experience', 'Sunrise Tour']
        },
        {
            'id': str(uuid.uuid4()),
            'name': 'Temple of Karnak',
            'location': 'Luxor',
            'type': 'temple',
            'description': 'A vast temple complex dedicated to Amun-Ra, constructed over 2000 years by successive pharaohs.',
            'image': 'https://images.unsplash.com/photo-1466442929976-97f336a657be?auto=format&fit=crop&w=800&h=600',
            'hieroglyph_name': '𓉟 𓊪 𓇳',
            'price': 120.0,
            'tours': ['Guided Tour', 'Audio Tour', 'Night Illumination']
        },
        {
            'id': str(uuid.uuid4()),
            'name': 'Valley of the Kings',
            'location': 'Luxor',
            'type': 'tomb',
            'description': 'Royal burial ground containing the tombs of pharaohs including Tutankhamun and Ramesses II.',
            'image': 'https://images.unsplash.com/photo-1426604966848-d7adac402bff?auto=format&fit=crop&w=800&h=600',
            'hieroglyph_name': '𓇳 𓊪 𓈖',
            'price': 180.0,
            'tours': ['Tomb Explorer', 'Archaeological Tour', 'Photography Tour']
        },
        {
            'id': str(uuid.uuid4()),
            'name': 'Abu Simbel',
            'location': 'Aswan',
            'type': 'temple',
            'description': 'Two massive rock temples carved out of a mountainside during the reign of Pharaoh Ramesses II.',
            'image': 'https://images.unsplash.com/photo-1543854680-584c840a9f30?auto=format&fit=crop&w=800&h=600',
            'hieroglyph_name': '𓎟 𓊪 𓊮',
            'price': 200.0,
            'tours': ['Sunrise Tour', 'Photography Tour', 'Sound & Light Show']
        },
        {
            'id': str(uuid.uuid4()),
            'name': 'Temple of Philae',
            'location': 'Aswan',
            'type': 'temple',
            'description': 'Beautiful temple complex dedicated to the goddess Isis, relocated to Agilkia Island.',
            'image': 'https://images.unsplash.com/photo-1574434230516-3e3c67b52ecf?auto=format&fit=crop&w=800&h=600',
            'hieroglyph_name': '𓊪 𓐍 𓍇',
            'price': 100.0,
            'tours': ['Boat Tour', 'Sound & Light Show', 'Photography Tour']
        }
    ]
    
    for landmark_data in landmarks_data:
        landmark = Landmark(**landmark_data)
        db.session.add(landmark)
    
    db.session.commit()
    print("Seeded landmark data successfully")

def create_app(config_class=Config):
    """Application factory pattern"""
    app = Flask(__name__)
    app.config.from_object(config_class)
    
    # Initialize extensions
    db.init_app(app)
    cors.init_app(app)
    jwt.init_app(app)
    
    # Register blueprints
    print("Importing blueprints...")
    from app.routes.auth import auth_bp
    from app.routes.user import user_bp
    from app.routes.scan import scan_bp
    from app.routes.prediction import prediction_bp
    from app.routes.landmarks import landmarks_bp
    
    print("Registering blueprints...")
    app.register_blueprint(auth_bp, url_prefix='/api/auth')
    app.register_blueprint(user_bp, url_prefix='/api/user')
    app.register_blueprint(scan_bp, url_prefix='/api/scans')
    app.register_blueprint(prediction_bp, url_prefix='/api')
    app.register_blueprint(landmarks_bp, url_prefix='/api')
    print("Blueprints registered successfully!")
    
    # Debug: Print all registered routes
    print("Registered routes:")
    for rule in app.url_map.iter_rules():
        print(f"  {rule.rule} -> {rule.endpoint}")
    print("---")
    
    # Health check endpoint
    @app.route('/health')
    def health_check():
        return jsonify({'status': 'healthy', 'service': 'hieroglyph-backend'}), 200
    
    # Static file serving
    from flask import send_from_directory
    import os
    
    @app.route('/uploads/<path:filename>')
    def uploaded_file(filename):
        return send_from_directory(app.config['UPLOAD_FOLDER'], filename)
    
    # Create database tables
    with app.app_context():
        # Import models after db is initialized with app
        from app.models.user import User
        from app.models.scan import Scan
        from app.models.token import BlacklistedToken
        from app.models.landmark import Landmark, Bookmark, Review, Booking
        db.create_all()
        
        # Seed initial landmark data if not exists
        if Landmark.query.count() == 0:
            seed_landmarks()
        
        # Create upload directories
        os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)
        os.makedirs(os.path.join(app.config['UPLOAD_FOLDER'], 'avatars'), exist_ok=True)
        os.makedirs(os.path.join(app.config['UPLOAD_FOLDER'], 'scans'), exist_ok=True)
    
    return app
