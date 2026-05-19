import 'dart:convert';
import 'package:cryptography/cryptography.dart';
import 'package:yourpass/models/vault_metadata.dart';
import 'package:yourpass/models/encrypted_payload.dart';
import 'package:yourpass/services/crypto/random_service.dart';
import 'package:yourpass/services/crypto/key_derivation_service.dart';
import 'package:yourpass/services/crypto/crypto_service.dart';
import 'package:yourpass/services/storage/vault_storage_service.dart';
import 'package:yourpass/services/vault/vault_session_service.dart';

class VaultException implements Exception {
  final String message;
  const VaultException(this.message);

  @override
  String toString() => message;
}

class VaultService {
  final RandomService _randomService;
  final KeyDerivationService _keyDerivationService;
  final CryptoService _cryptoService;
  final VaultStorageService _vaultStorageService;
  final VaultSessionService _vaultSessionService;

  VaultService({
    RandomService? randomService,
    KeyDerivationService? keyDerivationService,
    CryptoService? cryptoService,
    VaultStorageService? vaultStorageService,
    VaultSessionService? vaultSessionService,
  }) : _randomService = randomService ?? RandomService(),
       _keyDerivationService = keyDerivationService ?? KeyDerivationService(),
       _cryptoService = cryptoService ?? CryptoService(),
       _vaultStorageService = vaultStorageService ?? VaultStorageService(),
       _vaultSessionService = vaultSessionService ?? VaultSessionService();

  Future<void> createVault({
    required String password,
    required String? hint,
  }) async {
    final List<int> salt = _randomService.generateBytes(16);

    final SecretKey derivedKey = await _keyDerivationService.deriveKey(
      password: password,
      salt: salt,
    );

    final SecretBox verificationBox = await _cryptoService.encrypt(
      cleartext: utf8.encode('YOURPASS_V1'),
      secretKey: derivedKey,
    );

    final VaultMetadata metadata = VaultMetadata(
      salt: base64Encode(salt),
      verification: EncryptedPayload(
        ciphertext: base64Encode(verificationBox.cipherText),
        nonce: base64Encode(verificationBox.nonce),
        mac: base64Encode(verificationBox.mac.bytes),
      ),
      hint: hint?.isNotEmpty == true ? hint : null,
      version: 1,
      createdAt: DateTime.now(),
    );

    await _vaultStorageService.save(metadata);
  }

  Future<void> unlockVault({required String password}) async {
    final VaultMetadata? metadata = await _vaultStorageService.load();

    if (metadata == null) {
      throw const VaultException('No vault found. Create one first.');
    }

    final List<int> salt = base64Decode(metadata.salt);

    final SecretKey derivedKey = await _keyDerivationService.deriveKey(
      password: password,
      salt: salt,
    );

    final SecretBox secretBox = SecretBox(
      base64Decode(metadata.verification.ciphertext),
      nonce: base64Decode(metadata.verification.nonce),
      mac: Mac(base64Decode(metadata.verification.mac)),
    );

    try {
      await _cryptoService.decrypt(secretBox: secretBox, secretKey: derivedKey);
    } on SecretBoxAuthenticationError {
      throw const VaultException('Invalid master password');
    }

    final List<int> keyBytes = await derivedKey.extractBytes();
    _vaultSessionService.createSession(vaultKey: keyBytes);
  }

  Future<String?> getHint() async {
    final VaultMetadata? metadata = await _vaultStorageService.load();
    return metadata?.hint;
  }

  bool get isVaultUnlocked => _vaultSessionService.isUnlocked;
}
