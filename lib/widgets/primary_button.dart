import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    const onPrimaryColor = Colors.white;

    final bool isDisabled = onPressed == null || isLoading;

    return GestureDetector(
      onTap: isDisabled ? null : onPressed,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: isDisabled
              ? primaryColor.withValues(alpha: 0.5)
              : primaryColor,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(onPrimaryColor),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      text,
                      style: const TextStyle(
                        color: onPrimaryColor,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    if (icon != null) ...[
                      const SizedBox(width: 12),
                      Icon(icon, color: onPrimaryColor, size: 20),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
