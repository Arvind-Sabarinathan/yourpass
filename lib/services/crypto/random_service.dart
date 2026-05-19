import 'dart:math';

class RandomService {
  final Random _random = Random.secure();

  List<int> generateBytes(int length) {
    return List<int>.generate(length, (_) => _random.nextInt(256));
  }
}
