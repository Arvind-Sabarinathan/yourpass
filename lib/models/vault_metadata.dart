import 'package:yourpass/models/encrypted_payload.dart';

class VaultMetadata {
  final String salt;
  final EncryptedPayload verification;
  final String? hint;
  final int version;
  final DateTime createdAt;

  const VaultMetadata({
    required this.salt,
    required this.verification,
    this.hint,
    required this.version,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'salt': salt,
    'verification': verification.toJson(),
    'hint': hint,
    'version': version,
    'createdAt': createdAt.toIso8601String(),
  };

  factory VaultMetadata.fromJson(Map<String, dynamic> json) => VaultMetadata(
    salt: json['salt'] as String,
    verification: EncryptedPayload.fromJson(
      json['verification'] as Map<String, dynamic>,
    ),
    hint: json['hint'] as String?,
    version: json['version'] as int,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );
}
