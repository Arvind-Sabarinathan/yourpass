import 'dart:math';

enum CredentialCategory { web, app, other }

class Credential {
  final String id;
  final String title;
  final String username;
  final String password;
  final CredentialCategory category;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  Credential({
    required this.id,
    required this.title,
    required this.username,
    required this.password,
    required this.category,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  static String generateId() =>
      '${DateTime.now().microsecondsSinceEpoch}_${Random.secure().nextInt(9999)}';

  Credential copyWith({
    String? id,
    String? title,
    String? username,
    String? password,
    CredentialCategory? category,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Credential(
    id: id ?? this.id,
    title: title ?? this.title,
    username: username ?? this.username,
    password: password ?? this.password,
    category: category ?? this.category,
    notes: notes ?? this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'username': username,
    'password': password,
    'category': category.name,
    'notes': notes,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory Credential.fromJson(Map<String, dynamic> json) => Credential(
    id: json['id'] as String,
    title: json['title'] as String,
    username: json['username'] as String,
    password: json['password'] as String,
    category: CredentialCategory.values.firstWhere(
      (e) => e.name == json['category'],
    ),
    notes: json['notes'] as String?,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );
}
