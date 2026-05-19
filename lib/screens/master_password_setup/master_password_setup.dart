import 'package:flutter/material.dart';
import 'package:yourpass/configs/app_text_styles.dart';
import 'package:yourpass/screens/unlock_vault/unlock_vault.dart';
import 'package:yourpass/services/vault/vault_service.dart';
import 'package:yourpass/utils/validation_utils.dart';
import 'package:yourpass/widgets/app_logo.dart';
import 'package:yourpass/widgets/primary_button.dart';
import 'package:yourpass/widgets/app_text_field.dart';

class MasterPasswordSetup extends StatefulWidget {
  const MasterPasswordSetup({super.key});

  @override
  State<MasterPasswordSetup> createState() => _MasterPasswordSetupState();
}

class _MasterPasswordSetupState extends State<MasterPasswordSetup> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _hintController = TextEditingController();
  final _vaultService = VaultService();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _hasAgreed = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _hintController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateVault() async {
    final theme = Theme.of(context);

    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    final hint = _hintController.text.trim();

    final error = ValidationUtils.validateMasterPassword(
      password: password,
      confirmPassword: confirmPassword,
    );

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error, style: const TextStyle(color: Colors.white)),
          backgroundColor: theme.colorScheme.primary,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _vaultService.createVault(
        password: password,
        hint: hint.isNotEmpty ? hint : null,
      );

      _passwordController.clear();
      _confirmPasswordController.clear();

      if (!mounted) return;

      Navigator.of(
        context,
      ).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const UnlockVault()),
        (_) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to create vault: $e',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: theme.colorScheme.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.maybePop(context),
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  visualDensity: VisualDensity.compact,
                ),
              ),
              const SizedBox(height: 20),
              const AppLogo(),
              const SizedBox(height: 48),
              Text(
                "Secure Your Vault",
                style: AppTextStyles.heading,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                "This password is the only way to unlock your data. Choose wisely.",
                style: AppTextStyles.body.copyWith(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              AppTextField(
                controller: _passwordController,
                label: "Master Password",
                hint: "Enter a strong password",
                isObscure: !_isPasswordVisible,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 20,
                    color: theme.colorScheme.primary.withValues(alpha: 0.7),
                  ),
                  onPressed: () =>
                      setState(() => _isPasswordVisible = !_isPasswordVisible),
                ),
              ),
              const SizedBox(height: 24),
              AppTextField(
                controller: _confirmPasswordController,
                label: "Confirm Password",
                hint: "Repeat your password",
                isObscure: !_isConfirmPasswordVisible,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isConfirmPasswordVisible
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 20,
                    color: theme.colorScheme.primary.withValues(alpha: 0.7),
                  ),
                  onPressed: () => setState(
                    () =>
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              AppTextField(
                controller: _hintController,
                label: "Password Hint (Optional)",
                hint: "Something to help you remember",
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () => setState(() => _hasAgreed = !_hasAgreed),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: _hasAgreed,
                        onChanged: (value) =>
                            setState(() => _hasAgreed = value ?? false),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        side: BorderSide(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "I understand that if I forget my master password, my vault cannot be recovered.",
                        style: TextStyle(
                          color: theme.textTheme.bodyMedium?.color?.withValues(
                            alpha: 0.7,
                          ),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              PrimaryButton(
                text: 'Create Vault',
                onPressed: _hasAgreed ? _handleCreateVault : null,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
