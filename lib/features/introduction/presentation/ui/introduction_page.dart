import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:finan_master_app/features/auth/presentation/ui/login_page.dart';
import 'package:finan_master_app/features/auth/presentation/ui/signup_page.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class IntroductionPage extends StatefulWidget {
  static const route = 'introduction';

  const IntroductionPage({super.key});

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> with ThemeContext {
  final CarouselSliderController carouselController = CarouselSliderController();
  int itemCarrouselCurrent = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Builder(builder: (_) {
                          final sizeOf = MediaQuery.sizeOf(context);
                          final double size = min((min(sizeOf.height, sizeOf.width) / 1.7), 370) + 220;

                          return CarouselSlider(
                            items: [
                              itemCarrousel(
                                imageAsset: 'assets/images/introduction_1.png',
                                title: strings.introduction1Title,
                                subtitle: strings.introduction1subtitle,
                              ),
                              itemCarrousel(
                                imageAsset: 'assets/images/introduction_2.png',
                                title: strings.introduction2Title,
                                subtitle: strings.introduction2subtitle,
                              ),
                              itemCarrousel(
                                imageAsset: 'assets/images/introduction_3.png',
                                title: strings.introduction3Title,
                                subtitle: strings.introduction3subtitle,
                              ),
                            ],
                            carouselController: carouselController,
                            options: CarouselOptions(
                              autoPlay: true,
                              height: size,
                              viewportFraction: 1,
                              onPageChanged: (index, _) => setState(() => itemCarrouselCurrent = index),
                            ),
                          );
                        }),
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 20,
                          children: [0, 1, 2].map((index) {
                            return GestureDetector(
                              onTap: () => carouselController.animateToPage(index),
                              child: Container(
                                width: itemCarrouselCurrent == index ? 12 : 6,
                                height: itemCarrouselCurrent == index ? 12 : 6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colorScheme.primary.withValues(alpha: itemCarrouselCurrent == index ? 1 : 0.4),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacing.y(2),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: FilledButton(
                  onPressed: signup,
                  child: Text(strings.signup),
                ),
              ),
              const Spacing.y(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: FilledButton.tonal(
                  onPressed: login,
                  child: Text(strings.login),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget itemCarrousel({required String imageAsset, required String title, required String subtitle}) {
    final sizeOf = MediaQuery.sizeOf(context);
    final double size = min((min(sizeOf.height, sizeOf.width) / 1.7), 370);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          imageAsset,
          height: size,
          width: size,
        ),
        const Spacing.y(4),
        Text(
          title,
          style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
        const Spacing.y(),
        Text(
          subtitle,
          style: textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void signup() => context.goNamed(SignupPage.route);

  void login() => context.goNamed(LoginPage.route);
}
