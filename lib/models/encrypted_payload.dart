class EncryptedPayload {
  final String ciphertext;
  final String nonce;
  final String mac;

  const EncryptedPayload({
    required this.ciphertext,
    required this.nonce,
    required this.mac,
  });

  Map<String, dynamic> toJson() => {
    'ciphertext': ciphertext,
    'nonce': nonce,
    'mac': mac,
  };

  factory EncryptedPayload.fromJson(Map<String, dynamic> json) =>
      EncryptedPayload(
        ciphertext: json['ciphertext'] as String,
        nonce: json['nonce'] as String,
        mac: json['mac'] as String,
      );
}
