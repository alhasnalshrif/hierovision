# Flask Backend API

This is the refactored Flask backend for the Flutter hieroglyph detection app, using SQLAlchemy ORM and a modular structure.

## Project Structure

```

backend/
├── app/
│   ├── __init__.py          # Flask app factory
│   ├── models/
│   │   └── __init__.py      # SQLAlchemy models (User, Scan, BlacklistedToken)
│   ├── routes/
│   │   ├── auth.py          # Authentication routes
│   │   ├── user.py          # User profile routes
│   │   ├── scan.py          # Scan management routes
│   │   └── prediction.py    # ML prediction routes
│   ├── services/
│   │   └── ml_service.py    # Machine learning service
│   └── utils/
│       ├── auth.py          # Authentication utilities
│       └── file_handler.py  # File handling utilities
├── uploads/                 # Upload directories
│   ├── avatars/            # User avatar images
│   └── scans/              # Scan images
├── config.py               # Configuration settings
├── run.py                  # Main entry point
├── requirements.txt        # Python dependencies
├── start_backend.bat       # Windows startup script
└── .env.example           # Environment variables example
```

## Setup Instructions

1. **Create a virtual environment:**

   ```bash
   python -m venv venv
   venv\Scripts\activate  # On Windows
   ```

2. **Install dependencies:**

   ```bash
   pip install -r requirements.txt
   ```

3. **Set up environment variables:**

   ```bash
   copy .env.example .env
   # Edit .env file with your configuration
   ```

4. **Place ML models:**
   - Copy `Yolov8m_Best.pt` to the backend directory
   - Copy `Classification_Model.pt` to the backend directory

5. **Start the server:**

   ```bash
   python run.py
   # OR
   start_backend.bat  # On Windows
   ```

The server will start on `http://localhost:5000` by default.

## API Endpoints

### Authentication

- `POST /auth/register` - User registration
- `POST /auth/login` - User login
- `POST /auth/logout` - User logout

### User Management

- `GET /user/profile` - Get user profile
- `PUT /user/profile` - Update user profile
- `PUT /user/avatar` - Update user avatar

### Scan Management

- `GET /scans` - Get user's scans
- `POST /scans` - Upload new scan
- `GET /scans/<scan_id>` - Get specific scan
- `DELETE /scans/<scan_id>` - Delete scan

### Prediction

- `POST /predict` - Predict hieroglyphs in uploaded image

### File Serving

- `GET /uploads/<filename>` - Serve uploaded files

## Features

- **JWT Authentication** - Secure token-based authentication
- **SQLAlchemy ORM** - Database operations with models
- **File Upload** - Avatar and scan image handling
- **ML Integration** - YOLO object detection + classification
- **CORS Support** - Cross-origin requests for Flutter app
- **Modular Structure** - Organized codebase with blueprints

## Database Models

- **User** - User accounts with profiles
- **Scan** - User's hieroglyph scans with metadata
- **BlacklistedToken** - JWT token blacklist for logout

## Configuration

Environment variables can be set in `.env` file:

- `FLASK_DEBUG` - Debug mode (True/False)
- `FLASK_HOST` - Host address (default: 0.0.0.0)
- `FLASK_PORT` - Port number (default: 5000)
- `SECRET_KEY` - JWT secret key
- `DATABASE_URL` - Database connection string
- `UPLOAD_FOLDER` - Upload directory path
