import 'package:cryptography/cryptography.dart';

class KeyDerivationService {
  final Argon2id _argon2id = Argon2id(
    iterations: 3,
    memory: 65536,
    parallelism: 4,
    hashLength: 32,
  );

  Future<SecretKey> deriveKey({
    required String password,
    required List<int> salt,
  }) async {
    return _argon2id.deriveKey(
      secretKey: SecretKey(password.codeUnits),
      nonce: salt,
    );
  }
}
