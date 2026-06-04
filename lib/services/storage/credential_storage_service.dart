import 'dart:convert';
import 'package:cryptography/cryptography.dart';
import 'package:yourpass/models/credential.dart';
import 'package:yourpass/models/encrypted_payload.dart';
import 'package:yourpass/services/crypto/crypto_service.dart';
import 'package:yourpass/services/storage/secure_storage_service.dart';
import 'package:yourpass/services/vault/vault_session_service.dart';

class CredentialStorageService {
  final CryptoService _cryptoService;
  final VaultSessionService _vaultSessionService;
  final SecureStorageService _secureStorage;
  static const String _storageKey = 'yourpass_vault_credentials';

  CredentialStorageService({
    CryptoService? cryptoService,
    VaultSessionService? vaultSessionService,
    SecureStorageService? secureStorage,
  }) : _cryptoService = cryptoService ?? CryptoService(),
       _vaultSessionService = vaultSessionService ?? VaultSessionService(),
       _secureStorage = secureStorage ?? SecureStorageService();

  Future<List<Credential>> loadCredentials() async {
    final String? json = await _secureStorage.read(key: _storageKey);
    if (json == null) return [];

    final payload = EncryptedPayload.fromJson(
      jsonDecode(json) as Map<String, dynamic>,
    );

    final SecretBox secretBox = SecretBox(
      base64Decode(payload.ciphertext),
      nonce: base64Decode(payload.nonce),
      mac: Mac(base64Decode(payload.mac)),
    );

    final List<int> cleartext = await _cryptoService.decrypt(
      secretBox: secretBox,
      secretKey: SecretKey(_vaultSessionService.vaultKey),
    );

    final List<dynamic> items =
        jsonDecode(utf8.decode(cleartext)) as List<dynamic>;
    return items
        .map((e) => Credential.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveCredentials(List<Credential> credentials) async {
    final String json = jsonEncode(credentials.map((e) => e.toJson()).toList());
    final List<int> cleartext = utf8.encode(json);

    final SecretBox secretBox = await _cryptoService.encrypt(
      cleartext: cleartext,
      secretKey: SecretKey(_vaultSessionService.vaultKey),
    );

    final EncryptedPayload payload = EncryptedPayload(
      ciphertext: base64Encode(secretBox.cipherText),
      nonce: base64Encode(secretBox.nonce),
      mac: base64Encode(secretBox.mac.bytes),
    );

    await _secureStorage.write(
      key: _storageKey,
      value: jsonEncode(payload.toJson()),
    );
  }

  Future<void> addCredential(Credential credential) async {
    final creds = await loadCredentials();
    creds.add(credential);
    await saveCredentials(creds);
  }

  Future<void> updateCredential(Credential updated) async {
    final creds = await loadCredentials();
    final index = creds.indexWhere((c) => c.id == updated.id);
    if (index != -1) {
      creds[index] = updated;
      await saveCredentials(creds);
    }
  }

  Future<void> deleteCredential(String id) async {
    final creds = await loadCredentials();
    creds.removeWhere((c) => c.id == id);
    await saveCredentials(creds);
  }

  Future<void> deleteAll() async {
    await _secureStorage.delete(key: _storageKey);
  }
}
