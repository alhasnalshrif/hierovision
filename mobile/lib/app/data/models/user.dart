class User {
  final int? id;
  final String fullName;
  final String email;
  final String? avatarUrl;
  final String? selectedCountry;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    this.id,
    required this.fullName,
    required this.email,
    this.avatarUrl,
    this.selectedCountry,
    this.createdAt,
    this.updatedAt,
  });

  // For backward compatibility
  String get username => fullName;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['full_name'] ?? json['fullName'] ?? json['username'] ?? '',
      email: json['email'],
      avatarUrl: json['avatar_url'] ?? json['avatarUrl'] ?? json['avatar'],
      selectedCountry: json['selected_country'] ?? json['selectedCountry'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'fullName': fullName,
      'email': email,
      'avatar_url': avatarUrl,
      'avatarUrl': avatarUrl,
      'selected_country': selectedCountry,
      'selectedCountry': selectedCountry,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
