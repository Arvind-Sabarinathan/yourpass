import 'package:flutter/material.dart';
import 'package:yourpass/services/storage/secure_storage_service.dart';

class ThemeService {
  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;
  ThemeService._internal();

  final _secureStorage = SecureStorageService();
  static const _key = 'theme_mode';

  final ValueNotifier<ThemeMode> mode = ValueNotifier(ThemeMode.system);

  Future<void> init() async {
    final stored = await _secureStorage.read(key: _key);
    if (stored != null) {
      mode.value = ThemeMode.values.firstWhere(
        (e) => e.name == stored,
        orElse: () => ThemeMode.system,
      );
    }
  }

  Future<void> setTheme(ThemeMode themeMode) async {
    mode.value = themeMode;
    await _secureStorage.write(key: _key, value: themeMode.name);
  }
}
