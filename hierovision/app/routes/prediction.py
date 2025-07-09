from flask import Blueprint, request, jsonify
from app.services.ml_service import get_predictor
from app.utils.auth import optional_token
import logging

prediction_bp = Blueprint('prediction', __name__, url_prefix='/predict')
logger = logging.getLogger(__name__)


@prediction_bp.route('/predict', methods=['POST'])
@optional_token
def predict_hieroglyph(user):
    """Predict hieroglyph from uploaded image."""
    try:
        if 'file' not in request.files:
            return jsonify({
                'success': False,
                'error': 'No file provided'
            }), 400

        file = request.files['file']
        
        if file.filename == '':
            return jsonify({
                'success': False,
                'error': 'No file selected'
            }), 400

        # Get predictor instance
        predictor = get_predictor()
        
        # Make prediction
        result = predictor.predict(file)
        
        if result['success']:
            # Log prediction for analytics (if user is authenticated)
            if user:
                logger.info(f"Prediction made by user {user.email}: class {result['predicted_class_index']}")
            else:
                logger.info(f"Anonymous prediction: class {result['predicted_class_index']}")
            
            return jsonify({
                'success': True,
                'predicted_class_index': result['predicted_class_index'],
                'confidence_score': result['confidence_score'],
                'description': result['description']
            }), 200
        else:
            return jsonify({
                'success': False,
                'error': result['error']
            }), 500

    except Exception as e:
        logger.error(f"Prediction error: {e}")
        return jsonify({
            'success': False,
            'error': 'Prediction failed'
        }), 500


@prediction_bp.route('/top', methods=['POST'])
@optional_token
def predict_top_hieroglyphs(user):
    """Get top N predictions for uploaded image."""
    try:
        if 'file' not in request.files:
            return jsonify({
                'success': False,
                'error': 'No file provided'
            }), 400

        file = request.files['file']
        top_k = min(request.form.get('top_k', 5, type=int), 10)  # Max 10 predictions
        
        if file.filename == '':
            return jsonify({
                'success': False,
                'error': 'No file selected'
            }), 400

        # Get predictor instance
        predictor = get_predictor()
        
        # Make top predictions
        result = predictor.get_top_predictions(file, top_k=top_k)
        
        if result['success']:
            # Log prediction for analytics
            if user:
                logger.info(f"Top predictions made by user {user.email}: {len(result['predictions'])} results")
            else:
                logger.info(f"Anonymous top predictions: {len(result['predictions'])} results")
            
            return jsonify({
                'success': True,
                'predictions': result['predictions']
            }), 200
        else:
            return jsonify({
                'success': False,
                'error': result['error']
            }), 500

    except Exception as e:
        logger.error(f"Top predictions error: {e}")
        return jsonify({
            'success': False,
            'error': 'Prediction failed'
        }), 500


@prediction_bp.route('/info/<int:class_index>', methods=['GET'])
def get_hieroglyph_info(class_index):
    """Get information about a specific hieroglyph class."""
    try:
        predictor = get_predictor()
        
        if class_index in predictor.gardner_descriptions:
            description = predictor.gardner_descriptions[class_index]
            return jsonify({
                'success': True,
                'class_index': class_index,
                'description': description
            }), 200
        else:
            return jsonify({
                'success': False,
                'error': 'Hieroglyph class not found'
            }), 404

    except Exception as e:
        logger.error(f"Get hieroglyph info error: {e}")
        return jsonify({
            'success': False,
            'error': 'Failed to get hieroglyph information'
        }), 500


@prediction_bp.route('/classes', methods=['GET'])
def get_all_classes():
    """Get information about all hieroglyph classes."""
    try:
        predictor = get_predictor()
        
        # Get pagination parameters
        page = request.args.get('page', 1, type=int)
        per_page = min(request.args.get('per_page', 50, type=int), 100)
        
        # Calculate pagination
        total_classes = len(predictor.gardner_descriptions)
        start_idx = (page - 1) * per_page
        end_idx = start_idx + per_page
        
        # Get subset of classes
        all_classes = []
        for class_idx in sorted(predictor.gardner_descriptions.keys())[start_idx:end_idx]:
            description = predictor.gardner_descriptions[class_idx]
            all_classes.append({
                'class_index': class_idx,
                'code': description['code'],
                'description': description['description']
            })
        
        return jsonify({
            'success': True,
            'classes': all_classes,
            'pagination': {
                'page': page,
                'per_page': per_page,
                'total': total_classes,
                'pages': (total_classes + per_page - 1) // per_page,
                'has_next': end_idx < total_classes,
                'has_prev': page > 1
            }
        }), 200

    except Exception as e:
        logger.error(f"Get all classes error: {e}")
        return jsonify({
            'success': False,
            'error': 'Failed to get hieroglyph classes'
        }), 500


@prediction_bp.route('/search', methods=['GET'])
def search_hieroglyphs():
    """Search hieroglyphs by code or description."""
    try:
        query = request.args.get('q', '').strip().lower()
        
        if not query:
            return jsonify({
                'success': False,
                'error': 'Search query is required'
            }), 400
        
        predictor = get_predictor()
        
        # Search through descriptions
        matching_classes = []
        for class_idx, description in predictor.gardner_descriptions.items():
            code = description['code'].lower()
            desc_text = description['description'].lower()
            
            if query in code or query in desc_text:
                matching_classes.append({
                    'class_index': class_idx,
                    'code': description['code'],
                    'description': description['description']
                })
        
        # Limit results
        max_results = min(request.args.get('limit', 20, type=int), 100)
        matching_classes = matching_classes[:max_results]
        
        return jsonify({
            'success': True,
            'query': query,
            'results': matching_classes,
            'total_found': len(matching_classes)
        }), 200

    except Exception as e:
        logger.error(f"Search hieroglyphs error: {e}")
        return jsonify({
            'success': False,
            'error': 'Search failed'
        }), 500


@prediction_bp.route('/translate', methods=['POST'])
@optional_token
def translate_hieroglyph(user):
    """Translate hieroglyph from uploaded image to English."""
    try:
        if 'file' not in request.files:
            return jsonify({
                'success': False,
                'error': 'No file provided'
            }), 400

        file = request.files['file']
        
        if file.filename == '':
            return jsonify({
                'success': False,
                'error': 'No file selected'
            }), 400

        # Get predictor instance
        predictor = get_predictor()
        
        # Make prediction
        result = predictor.predict(file)
        
        if result['success']:
            # Format response for translation
            translation_text = result['description']['description'] if result['description'] else 'Unknown hieroglyph'
            hieroglyph_code = result['description']['code'] if result['description'] else 'Unknown'
            
            # Log translation for analytics
            if user:
                logger.info(f"Translation made by user {user.email}: {hieroglyph_code} -> {translation_text}")
            else:
                logger.info(f"Anonymous translation: {hieroglyph_code} -> {translation_text}")
            
            return jsonify({
                'success': True,
                'predicted_class_index': result['predicted_class_index'],
                'confidence_score': result['confidence_score'],
                'hieroglyph_code': hieroglyph_code,
                'translation': translation_text,
                'description': result['description']
            }), 200
        else:
            return jsonify({
                'success': False,
                'error': result['error']
            }), 500

    except Exception as e:
        logger.error(f"Translation error: {e}")
        return jsonify({
            'success': False,
            'error': 'Translation failed'
        }), 500


@prediction_bp.route('/translate/english-to-hieroglyphs', methods=['POST'])
@optional_token
def translate_english_to_hieroglyphs(user):
    """Translate English text to hieroglyphs."""
    try:
        data = request.get_json()
        
        if not data or 'text' not in data:
            return jsonify({
                'success': False,
                'error': 'No text provided'
            }), 400

        english_text = data['text'].strip()
        
        if not english_text:
            return jsonify({
                'success': False,
                'error': 'Empty text provided'
            }), 400

        # Mock translation based on common words
        # In a real implementation, this would call an AI service or translation API
        word_translations = {
            "pharaoh": "𓂋𓄿𓇯",
            "king": "𓂋𓄿𓇯",
            "sun": "𓇳",
            "god": "𓊹",
            "life": "𓋹",
            "water": "𓈖",
            "bird": "𓅿",
            "house": "𓉐",
            "man": "𓊃",
            "woman": "𓊪",
            "eye": "𓁹",
            "hand": "𓂝",
            "mouth": "𓂋",
            "bread": "𓏏",
            "gold": "𓈓",
            "love": "𓂋𓄿𓇯𓋴",
            "peace": "𓐍𓏤",
            "wisdom": "𓄿𓇯𓂋",
            "river": "𓈗",
            "temple": "𓉟",
            "cat": "𓅓",
            "dog": "𓃛",
            "fire": "𓊖",
            "earth": "𓇾",
            "sky": "𓊪𓏏",
            "star": "𓇽",
            "moon": "𓇹",
            "mountain": "𓈋",
            "tree": "𓈎",
            "flower": "𓆸"
        }

        words = english_text.lower().split()
        hieroglyphs = []
        transliteration = []
        
        for word in words:
            if word in word_translations:
                hieroglyphs.append(word_translations[word])
                transliteration.append(word)
            else:
                # Default hieroglyphs for unknown words
                hieroglyphs.append("𓊪𓏏𓇯")
                transliteration.append(word)

        result = {
            'success': True,
            'original_text': english_text,
            'hieroglyphs': ' '.join(hieroglyphs) if hieroglyphs else "𓂋𓄿𓇯𓋴 𓊪𓏏𓇯",
            'confidence_score': 0.85,
            'transliteration': ' '.join(transliteration)
        }

        # Log translation for analytics (if user is authenticated)
        if user:
            logger.info(f"English to hieroglyphs translation by user {user.email}: '{english_text}'")
        else:
            logger.info(f"Anonymous English to hieroglyphs translation: '{english_text}'")

        return jsonify(result), 200

    except Exception as e:
        logger.error(f"English to hieroglyphs translation error: {e}")
        return jsonify({
            'success': False,
            'error': 'Translation failed'
        }), 500
