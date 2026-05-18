import 'package:flutter/material.dart';
import 'package:yourpass/configs/app_text_styles.dart';
import 'package:yourpass/screens/onboard/sections/section_three.dart';
import 'package:yourpass/widgets/app_logo.dart';
import 'package:yourpass/widgets/primary_button.dart';

import 'package:yourpass/widgets/rule_item.dart';
import 'package:yourpass/widgets/page_indicator.dart';

class SectionTwo extends StatelessWidget {
  const SectionTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.maybePop(context),
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                  TextButton(
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
                ],
              ),
              const SizedBox(height: 20),
              const AppLogo(),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.visibility_off_outlined, size: 48),
                    const SizedBox(height: 32),
                    Text(
                      "No cloud. No tracking. No worries.",
                      style: AppTextStyles.heading,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Your data stays encrypted on your device. We have zero knowledge of what you store.",
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
                                "Zero-knowledge architecture. Only you hold the keys.",
                          ),
                          RuleItem(
                            text:
                                "Simple backup & export. Your data is always yours.",
                          ),
                          RuleItem(
                            text:
                                "Open and transparent. No hidden tracking or analytics.",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const PageIndicator(currentIndex: 1, totalCount: 3),
              const SizedBox(height: 32),
              PrimaryButton(
                text: 'Continue',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SectionThree(),
                    ),
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
