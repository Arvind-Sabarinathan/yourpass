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
}
