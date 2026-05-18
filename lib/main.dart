import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yourpass/configs/app_theme.dart';
import 'package:yourpass/screens/onboard/onboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppThemeData.lightTheme,
      darkTheme: AppThemeData.darkTheme,
      themeMode: ThemeMode.system,
      home: Onboard(),
    );
  }
}
