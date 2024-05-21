import 'package:finan_master_app/di/dependency_injection.dart';
import 'package:finan_master_app/features/auth/presentation/ui/email_verification_page.dart';
import 'package:finan_master_app/features/auth/presentation/ui/login_page.dart';
import 'package:finan_master_app/features/home/presentation/ui/home_page.dart';
import 'package:finan_master_app/features/introduction/presentation/ui/introduction_page.dart';
import 'package:finan_master_app/features/splash/presentation/notifiers/splash_notifier.dart';
import 'package:finan_master_app/features/splash/presentation/states/splash_state.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/app.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  static const route = 'splash';

  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with ThemeContext {
  final SplashNotifier notifier = DI.get<SplashNotifier>();

  @override
  void initState() {
    super.initState();

    Future(() async {
      await notifier.init();

      if (!mounted) return;
      if (notifier.value is ErrorSplashState) return;

      if (notifier.auth == null) {
        context.goNamed(IntroductionPage.route);
        return;
      }

      if (!notifier.auth!.emailVerified) {
        context.goNamed(EmailVerificationPage.route);
        return;
      }

      context.goNamed(HomePage.route);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ValueListenableBuilder(
              valueListenable: notifier,
              builder: (_, state, __) {
                if (state is ErrorSplashState) {
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 50),
                      const Spacing.y(2),
                      Text(state.message.replaceAll('Exception: ', '')),
                      const Spacing.y(4),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: toLogin,
                          child: Text(strings.login),
                        ),
                      ),
                    ],
                  );
                }

                return Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/images/logo.svg', width: 80),
                    const Spacing.y(4),
                    Text(appName, style: textTheme.headlineLarge),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void toLogin() => context.goNamed(LoginPage.route);
}
