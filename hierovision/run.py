#!/usr/bin/env python3
"""
Main entry point for the Flask backend application.
Run this file to start the server.
"""

from app import create_app
import os

app = create_app()

if __name__ == '__main__':
    # Get configuration from environment variables
    debug = os.environ.get('FLASK_DEBUG', 'True').lower() == 'true'
    host = os.environ.get('FLASK_HOST', '0.0.0.0')
    port = int(os.environ.get('FLASK_PORT', 5000))
    
    print(f"Starting Flask backend on {host}:{port}")
    print(f"Debug mode: {debug}")
    
    app.run(host=host, port=port, debug=debug)
