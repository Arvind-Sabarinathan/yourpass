class VaultSession {
  final List<int> vaultKey;
  final DateTime unlockedAt;

  const VaultSession({required this.vaultKey, required this.unlockedAt});
}
