import 'dart:convert';
import 'package:yourpass/models/vault_metadata.dart';
import 'package:yourpass/services/storage/secure_storage_service.dart';

class VaultStorageService {
  final SecureStorageService _secureStorage;
  static const String _vaultKey = 'yourpass_vault';

  VaultStorageService({SecureStorageService? secureStorage})
    : _secureStorage = secureStorage ?? SecureStorageService();

  Future<void> save(VaultMetadata metadata) async {
    final String json = jsonEncode(metadata.toJson());
    await _secureStorage.write(key: _vaultKey, value: json);
  }

  Future<VaultMetadata?> load() async {
    final String? json = await _secureStorage.read(key: _vaultKey);
    if (json == null) return null;
    return VaultMetadata.fromJson(jsonDecode(json));
  }

  Future<bool> exists() async {
    final String? json = await _secureStorage.read(key: _vaultKey);
    return json != null;
  }

  Future<void> delete() async {
    await _secureStorage.delete(key: _vaultKey);
  }
}
