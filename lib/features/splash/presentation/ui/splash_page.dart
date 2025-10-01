import 'package:finan_master_app/di/dependency_injection.dart';
import 'package:finan_master_app/features/auth/presentation/ui/email_verification_page.dart';
import 'package:finan_master_app/features/auth/presentation/ui/login_page.dart';
import 'package:finan_master_app/features/first_steps/presentation/notifiers/first_steps_notifier.dart';
import 'package:finan_master_app/features/home/presentation/ui/home_page.dart';
import 'package:finan_master_app/features/introduction/presentation/ui/introduction_page.dart';
import 'package:finan_master_app/features/splash/presentation/view_models/splash_view_model.dart';
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
  final SplashViewModel viewModel = DI.get<SplashViewModel>();
  final FirstStepsNotifier firstStepsNotifier = DI.get<FirstStepsNotifier>();

  @override
  void initState() {
    super.initState();

    Future(() async {
      await Future.wait([
        viewModel.authFind.execute(),
        firstStepsNotifier.find(),
      ]);

      if (!mounted) return;
      if (viewModel.authFind.hasError) return;

      if (viewModel.authFind.result == null) {
        context.goNamed(IntroductionPage.route);
        return;
      }

      if (!viewModel.authFind.result!.emailVerified) {
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
            child: ListenableBuilder(
              listenable: viewModel.authFind,
              builder: (_, __) {
                if (viewModel.authFind.hasError) {
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 50),
                      const Spacing.y(2),
                      Text(viewModel.authFind.error.toString().replaceAll('Exception: ', '')),
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
