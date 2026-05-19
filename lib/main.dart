import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yourpass/configs/app_theme.dart';
import 'package:yourpass/screens/onboard/onboard.dart';
import 'package:yourpass/screens/unlock_vault/unlock_vault.dart';
import 'package:yourpass/services/storage/vault_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final bool hasVault = await VaultStorageService().exists();

  runApp(MainApp(hasVault: hasVault));
}

class MainApp extends StatelessWidget {
  final bool hasVault;

  const MainApp({super.key, required this.hasVault});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppThemeData.lightTheme,
      darkTheme: AppThemeData.darkTheme,
      themeMode: ThemeMode.system,
      home: hasVault ? const UnlockVault() : const Onboard(),
    );
  }
}
