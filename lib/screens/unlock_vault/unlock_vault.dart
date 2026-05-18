import 'package:flutter/material.dart';
import 'package:yourpass/configs/app_text_styles.dart';
import 'package:yourpass/screens/vault/vault.dart';
import 'package:yourpass/widgets/app_logo.dart';
import 'package:yourpass/widgets/primary_button.dart';
import 'package:yourpass/widgets/app_text_field.dart';

class UnlockVault extends StatefulWidget {
  const UnlockVault({super.key});

  @override
  State<UnlockVault> createState() => _UnlockState();
}

class _UnlockState extends State<UnlockVault> {
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AppLogo(),
                const SizedBox(height: 60),
                Text(
                  "Welcome Back",
                  style: AppTextStyles.heading,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  "Enter your master password to unlock your vault",
                  style: AppTextStyles.body.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withValues(
                      alpha: 0.6,
                    ),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                AppTextField(
                  controller: _passwordController,
                  label: "Master Password",
                  hint: "Enter your password",
                  isObscure: !_isPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                      color: theme.colorScheme.primary.withValues(alpha: 0.7),
                    ),
                    onPressed: () => setState(
                      () => _isPasswordVisible = !_isPasswordVisible,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  text: 'Unlock',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const Vault()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
