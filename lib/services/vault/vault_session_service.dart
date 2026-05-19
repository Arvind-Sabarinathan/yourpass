import 'package:yourpass/models/vault_session.dart';

class VaultSessionService {
  static final VaultSessionService _instance = VaultSessionService._internal();
  factory VaultSessionService() => _instance;
  VaultSessionService._internal();

  VaultSession? _session;

  bool get isUnlocked => _session != null;

  void createSession({required List<int> vaultKey}) {
    _session = VaultSession(vaultKey: vaultKey, unlockedAt: DateTime.now());
  }

  List<int> get vaultKey {
    if (_session == null) throw StateError('Vault is not unlocked');
    return _session!.vaultKey;
  }

  void lock() {
    if (_session != null) {
      for (int i = 0; i < _session!.vaultKey.length; i++) {
        _session!.vaultKey[i] = 0;
      }
    }
    _session = null;
  }
}
