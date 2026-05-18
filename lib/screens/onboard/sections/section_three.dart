import 'package:flutter/material.dart';
import 'package:yourpass/configs/app_text_styles.dart';
import 'package:yourpass/screens/master_password_setup/master_password_setup.dart';
import 'package:yourpass/widgets/app_logo.dart';
import 'package:yourpass/widgets/primary_button.dart';
import 'package:yourpass/widgets/rule_item.dart';
import 'package:yourpass/widgets/page_indicator.dart';

class SectionThree extends StatelessWidget {
  const SectionThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
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
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  visualDensity: VisualDensity.compact,
                ),
              ),
              const SizedBox(height: 20),
              const AppLogo(),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.shield_outlined, size: 42),
                    const SizedBox(height: 24),
                    Text(
                      "Create Your Master Password",
                      style: AppTextStyles.heading,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Your master password protects everything stored in your vault. "
                      "Only you can access it — we never store or see your password.",
                      style: AppTextStyles.body.copyWith(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          RuleItem(
                            text:
                                "Use at least 12 characters for stronger protection.",
                          ),
                          RuleItem(
                            text:
                                "Choose a unique password using words, numbers, or symbols.",
                          ),
                          RuleItem(
                            text:
                                "Avoid names, birthdays, or easily guessable information.",
                          ),
                          RuleItem(
                            text:
                                "For your security, your master password cannot be recovered if forgotten.",
                            icon: Icons.warning_amber_rounded,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const PageIndicator(currentIndex: 2, totalCount: 3),
              const SizedBox(height: 32),
              PrimaryButton(
                text: 'Create Master Password',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MasterPasswordSetup(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
