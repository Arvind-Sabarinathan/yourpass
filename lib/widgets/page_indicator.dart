import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  final int currentIndex;
  final int totalCount;

  const PageIndicator({
    super.key,
    required this.currentIndex,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalCount, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 32 : 12,
          height: 8,
          decoration: BoxDecoration(
            color: isActive
                ? primaryColor
                : primaryColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(50),
          ),
        );
      }),
    );
  }
}
