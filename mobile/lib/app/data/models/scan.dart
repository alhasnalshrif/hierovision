class Scan {
  final int? id;
  final String? imageUrl;
  final String? resultText;
  final String? description;
  final String? location;
  final String? type;
  final List<String>? detectedObjects;
  final double? confidence;
  final double? confidenceScore;
  final DateTime? createdAt;
  final DateTime? timestamp;
  final int? userId;

  Scan({
    this.id,
    this.imageUrl,
    this.resultText,
    this.description,
    this.location,
    this.type,
    this.detectedObjects,
    this.confidence,
    this.confidenceScore,
    this.createdAt,
    this.timestamp,
    this.userId,
  });

  factory Scan.fromJson(Map<String, dynamic> json) {
    return Scan(
      id: json['id'] is String ? int.tryParse(json['id']) : json['id'],
      imageUrl: json['image_url'] ?? json['image'],
      resultText: json['result_text'] ?? json['translation'],
      description: json['description'],
      location: json['location'],
      type: json['type'],
      detectedObjects: json['detected_objects'] != null
          ? List<String>.from(json['detected_objects'])
          : null,
      confidence: json['confidence']?.toDouble(),
      confidenceScore: json['confidence_score']?.toDouble(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : null,
      userId: json['user_id'] is String
          ? int.tryParse(json['user_id'])
          : json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_url': imageUrl,
      'result_text': resultText,
      'description': description,
      'location': location,
      'type': type,
      'detected_objects': detectedObjects,
      'confidence': confidence,
      'confidence_score': confidenceScore,
      'created_at': createdAt?.toIso8601String(),
      'timestamp': timestamp?.toIso8601String(),
      'user_id': userId,
    };
  }

  // Getter for the actual confidence value (prefer confidenceScore over confidence)
  double? get actualConfidence => confidenceScore ?? confidence;

  // Getter for the actual timestamp (prefer timestamp over createdAt)
  DateTime? get actualTimestamp => timestamp ?? createdAt;

  // Getter for properly formatted image URL
  String? get properImageUrl {
    if (imageUrl == null || imageUrl!.isEmpty) return null;

    // If it's already a full URL, return as is
    if (imageUrl!.startsWith('http://') || imageUrl!.startsWith('https://')) {
      return imageUrl;
    }

    // If it's a file:// URI or local path, construct a proper URL
    const String baseUrl = 'http://10.0.2.2:5000';

    // Remove file:// prefix if present (handle both file:// and file:///)
    String cleanPath = imageUrl!;
    if (cleanPath.startsWith('file:///')) {
      cleanPath = cleanPath.substring(8);
    } else if (cleanPath.startsWith('file://')) {
      cleanPath = cleanPath.substring(7);
    }

    // Remove leading slash if present since we'll add it
    if (cleanPath.startsWith('/')) {
      cleanPath = cleanPath.substring(1);
    }

    // If the path doesn't start with 'uploads' or 'static', add it
    if (!cleanPath.startsWith('uploads/') && !cleanPath.startsWith('static/')) {
      cleanPath = 'uploads/scans/$cleanPath';
    }

    final finalUrl = '$baseUrl/$cleanPath';
    return finalUrl;
  }
}
