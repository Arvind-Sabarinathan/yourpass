import 'dart:convert';
import 'package:cryptography/cryptography.dart';
import 'package:yourpass/models/credential.dart';
import 'package:yourpass/models/encrypted_payload.dart';
import 'package:yourpass/services/crypto/crypto_service.dart';
import 'package:yourpass/services/storage/database_service.dart';
import 'package:yourpass/services/vault/vault_session_service.dart';

class CredentialDao {
  final DatabaseService _databaseService;
  final CryptoService _cryptoService;
  final VaultSessionService _vaultSessionService;

  CredentialDao({
    DatabaseService? databaseService,
    CryptoService? cryptoService,
    VaultSessionService? vaultSessionService,
  }) : _databaseService = databaseService ?? DatabaseService(),
       _cryptoService = cryptoService ?? CryptoService(),
       _vaultSessionService = vaultSessionService ?? VaultSessionService();

  SecretKey get _key => SecretKey(_vaultSessionService.vaultKey);

  Future<String> _encryptField(String plaintext) async {
    final secretBox = await _cryptoService.encrypt(
      cleartext: utf8.encode(plaintext),
      secretKey: _key,
    );
    return jsonEncode(
      EncryptedPayload(
        ciphertext: base64Encode(secretBox.cipherText),
        nonce: base64Encode(secretBox.nonce),
        mac: base64Encode(secretBox.mac.bytes),
      ).toJson(),
    );
  }

  Future<String> _decryptField(String encrypted) async {
    final payload = EncryptedPayload.fromJson(
      jsonDecode(encrypted) as Map<String, dynamic>,
    );
    final secretBox = SecretBox(
      base64Decode(payload.ciphertext),
      nonce: base64Decode(payload.nonce),
      mac: Mac(base64Decode(payload.mac)),
    );
    final cleartext = await _cryptoService.decrypt(
      secretBox: secretBox,
      secretKey: _key,
    );
    return utf8.decode(cleartext);
  }

  Future<void> insert(Credential credential) async {
    final db = await _databaseService.database;
    await db.insert('credentials', {
      'id': credential.id,
      'title': credential.title,
      'category': credential.category.name,
      'username_encrypted': await _encryptField(credential.username),
      'password_encrypted': await _encryptField(credential.password),
      'notes_encrypted': credential.notes != null
          ? await _encryptField(credential.notes!)
          : null,
      'created_at': credential.createdAt.toIso8601String(),
      'updated_at': credential.updatedAt.toIso8601String(),
    });
  }

  Future<void> update(Credential credential) async {
    final db = await _databaseService.database;
    await db.update(
      'credentials',
      {
        'title': credential.title,
        'category': credential.category.name,
        'username_encrypted': await _encryptField(credential.username),
        'password_encrypted': await _encryptField(credential.password),
        'notes_encrypted': credential.notes != null
            ? await _encryptField(credential.notes!)
            : null,
        'updated_at': credential.updatedAt.toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [credential.id],
    );
  }

  Future<void> delete(String id) async {
    final db = await _databaseService.database;
    await db.delete('credentials', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAll() async {
    await _databaseService.clearCredentials();
  }

  Future<Credential?> getById(String id) async {
    final db = await _databaseService.database;
    final rows = await db.query(
      'credentials',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (rows.isEmpty) return null;
    return _rowToCredential(rows.first);
  }

  Future<List<Credential>> getAll({
    String? searchQuery,
    CredentialCategory? category,
  }) async {
    final db = await _databaseService.database;

    final where = <String>[];
    final whereArgs = <dynamic>[];

    if (searchQuery != null && searchQuery.isNotEmpty) {
      where.add('title LIKE ?');
      whereArgs.add('%$searchQuery%');
    }

    if (category != null) {
      where.add('category = ?');
      whereArgs.add(category.name);
    }

    final rows = await db.query(
      'credentials',
      where: where.isEmpty ? null : where.join(' AND '),
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
      orderBy: 'title ASC',
    );

    final results = <Credential>[];
    for (final row in rows) {
      results.add(await _rowToCredential(row));
    }
    return results;
  }

  Future<Credential> _rowToCredential(Map<String, dynamic> row) async {
    return Credential(
      id: row['id'] as String,
      title: row['title'] as String,
      username: await _decryptField(row['username_encrypted'] as String),
      password: await _decryptField(row['password_encrypted'] as String),
      category: CredentialCategory.values.firstWhere(
        (e) => e.name == row['category'],
      ),
      notes: row['notes_encrypted'] != null
          ? await _decryptField(row['notes_encrypted'] as String)
          : null,
      createdAt: DateTime.parse(row['created_at'] as String),
      updatedAt: DateTime.parse(row['updated_at'] as String),
    );
  }
}
