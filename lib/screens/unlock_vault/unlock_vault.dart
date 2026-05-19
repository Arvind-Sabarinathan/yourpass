import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:yourpass/configs/app_text_styles.dart';
import 'package:yourpass/screens/vault/vault.dart';
import 'package:yourpass/services/vault/vault_service.dart';
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
  final _vaultService = VaultService();

  final _hintController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadHint();
  }

  Future<void> _loadHint() async {
    final String? hint = await _vaultService.getHint();
    if (hint != null && mounted) {
      _hintController.text = hint;
      setState(() {});
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _hintController.dispose();
    super.dispose();
  }

  Future<void> _handleUnlock() async {
    final theme = Theme.of(context);
    final String password = _passwordController.text.trim();

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Please enter your master password',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: theme.colorScheme.primary,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _vaultService.unlockVault(password: password);

      _passwordController.clear();

      if (!mounted) return;

      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const Vault()));
    } on VaultException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: theme.colorScheme.error,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to unlock vault: $e',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: theme.colorScheme.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showHintDialog(BuildContext context) {
    final theme = Theme.of(context);

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Password hint',
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 200),
      transitionBuilder: (ctx, anim, secondaryAnim, child) => BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 1.5 * anim.value,
          sigmaY: 1.5 * anim.value,
        ),
        child: FadeTransition(opacity: anim, child: child),
      ),
      pageBuilder: (ctx, anim1, anim2) {
        final isDark = theme.brightness == Brightness.dark;

        return Dialog(
          backgroundColor: isDark ? theme.colorScheme.surface : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline_rounded,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Password Hint',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  _hintController.text,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: Text(
                      'Close',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
                if (_hintController.text.isNotEmpty)
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => _showHintDialog(context),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Show Password Hint',
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.7,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.info_outline_rounded,
                            size: 16,
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (_hintController.text.isNotEmpty) const SizedBox(height: 8),
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
                  onSubmitted: _isLoading ? null : (_) => _handleUnlock(),
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  text: 'Unlock',
                  onPressed: _isLoading ? null : _handleUnlock,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
