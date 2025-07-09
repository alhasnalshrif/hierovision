import os
import uuid
from werkzeug.utils import secure_filename
from flask import current_app


def allowed_file(filename):
    """Check if the uploaded file has an allowed extension."""
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in current_app.config['ALLOWED_EXTENSIONS']


def generate_unique_filename(original_filename, user_uid=None):
    """Generate a unique filename for uploaded files."""
    file_extension = original_filename.rsplit('.', 1)[1].lower()
    unique_id = str(uuid.uuid4())
    
    if user_uid:
        return f"{user_uid}_{unique_id}.{file_extension}"
    else:
        return f"{unique_id}.{file_extension}"


def save_uploaded_file(file, folder, user_uid=None):
    """
    Save an uploaded file to the specified folder.
    
    Args:
        file: The uploaded file object
        folder: The subfolder name (e.g., 'avatars', 'scans')
        user_uid: Optional user ID for filename generation
    
    Returns:
        tuple: (success: bool, filename: str, error_message: str)
    """
    if not file or file.filename == '':
        return False, None, 'No file selected'
    
    if not allowed_file(file.filename):
        return False, None, 'File type not allowed'
    
    try:
        # Generate unique filename
        filename = generate_unique_filename(file.filename, user_uid)
        
        # Create full file path
        upload_path = os.path.join(current_app.config['UPLOAD_FOLDER'], folder)
        os.makedirs(upload_path, exist_ok=True)
        
        filepath = os.path.join(upload_path, filename)
        
        # Save file
        file.save(filepath)
        
        # Return URL path
        url_path = f"/uploads/{folder}/{filename}"
        return True, url_path, None
        
    except Exception as e:
        return False, None, str(e)


def delete_file(file_url):
    """
    Delete a file from the filesystem using its URL.
    
    Args:
        file_url: The URL path of the file (e.g., '/uploads/avatars/filename.jpg')
    
    Returns:
        bool: True if deletion was successful, False otherwise
    """
    try:
        # Extract filename from URL
        if not file_url or not file_url.startswith('/uploads/'):
            return False
        
        # Remove '/uploads/' prefix and get the relative path
        relative_path = file_url[9:]  # Remove '/uploads/'
        filepath = os.path.join(current_app.config['UPLOAD_FOLDER'], relative_path)
        
        if os.path.exists(filepath):
            os.remove(filepath)
            return True
        
        return False
        
    except Exception as e:
        current_app.logger.warning(f"Failed to delete file {file_url}: {e}")
        return False


def get_file_size(file_url):
    """Get the size of a file in bytes."""
    try:
        if not file_url or not file_url.startswith('/uploads/'):
            return 0
        
        relative_path = file_url[9:]
        filepath = os.path.join(current_app.config['UPLOAD_FOLDER'], relative_path)
        
        if os.path.exists(filepath):
            return os.path.getsize(filepath)
        
        return 0
        
    except Exception:
        return 0
