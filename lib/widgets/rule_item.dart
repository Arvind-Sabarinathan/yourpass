import 'package:flutter/material.dart';
import 'package:yourpass/configs/app_text_styles.dart';

class RuleItem extends StatelessWidget {
  final String text;
  final IconData icon;

  const RuleItem({
    super.key,
    required this.text,
    this.icon = Icons.check_circle_outline_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: theme.colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.body.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
