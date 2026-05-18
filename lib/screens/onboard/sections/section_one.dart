import 'package:flutter/material.dart';
import 'package:yourpass/configs/app_text_styles.dart';
import 'package:yourpass/screens/onboard/sections/section_two.dart';
import 'package:yourpass/screens/onboard/sections/section_three.dart';
import 'package:yourpass/widgets/app_logo.dart';
import 'package:yourpass/widgets/primary_button.dart';
import 'package:yourpass/widgets/rule_item.dart';
import 'package:yourpass/widgets/page_indicator.dart';

class SectionOne extends StatelessWidget {
  const SectionOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SectionThree(),
                      ),
                    );
                  },
                  child: Text(
                    "Skip",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const AppLogo(),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.lock_person_outlined, size: 48),
                    const SizedBox(height: 32),
                    Text(
                      "Passwords. Stored only with you.",
                      style: AppTextStyles.heading,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "A private vault that works fully offline, giving you complete control over your data.",
                      style: AppTextStyles.body.copyWith(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          RuleItem(
                            text:
                                "Everything is encrypted and stored only on your device.",
                          ),
                          RuleItem(
                            text:
                                "No internet required. Your vault works fully offline.",
                          ),
                          RuleItem(
                            text:
                                "Fast, secure, and always accessible when you need it.",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const PageIndicator(currentIndex: 0, totalCount: 3),
              const SizedBox(height: 32),
              PrimaryButton(
                text: 'Continue',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SectionTwo()),
                  );
                },
                icon: Icons.arrow_forward_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
