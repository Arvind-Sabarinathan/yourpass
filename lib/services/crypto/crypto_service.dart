import 'package:cryptography/cryptography.dart';

class CryptoService {
  final AesGcm _aesGcm = AesGcm.with256bits();

  Future<SecretBox> encrypt({
    required List<int> cleartext,
    required SecretKey secretKey,
  }) async {
    return _aesGcm.encrypt(cleartext, secretKey: secretKey);
  }

  Future<List<int>> decrypt({
    required SecretBox secretBox,
    required SecretKey secretKey,
  }) async {
    return _aesGcm.decrypt(secretBox, secretKey: secretKey);
  }
}
