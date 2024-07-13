import 'dart:async';
import 'dart:math';

import 'package:finan_master_app/di/dependency_injection.dart';
import 'package:finan_master_app/features/auth/presentation/notifiers/email_verification_notifier.dart';
import 'package:finan_master_app/features/auth/presentation/states/email_verification_state.dart';
import 'package:finan_master_app/features/home/presentation/ui/home_page.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/dialog/error_dialog.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmailVerificationPage extends StatefulWidget {
  static const String route = 'email_verification';

  const EmailVerificationPage({super.key});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> with ThemeContext {
  final EmailVerificationNotifier notifier = DI.get<EmailVerificationNotifier>();

  static const int maxSeconds = 60;

  Timer? timerResendEmail;
  int? timerResendEmailTick;

  @override
  void initState() {
    super.initState();
    startTimerResendEmail();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: (_, state, __) {
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
                            Builder(
                              builder: (_) {
                                final sizeOf = MediaQuery.sizeOf(context);
                                final double size = min((min(sizeOf.height, sizeOf.width) / 1.7), 370);
                                return Image.asset('assets/images/email_verification.png', width: size, height: size);
                              },
                            ),
                            const Spacing.y(4),
                            Text(
                              strings.confirmEmail,
                              style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            ),
                            const Spacing.y(),
                            Text(
                              strings.confirmEmailExplication,
                              style: textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                            const Spacing.y(),
                            ConstrainedBox(
                              constraints: const BoxConstraints(minWidth: 180),
                              child: Builder(
                                builder: (_) {
                                  if (state is ResendingEmailVerificationState) {
                                    return FilledButton.tonal(
                                      onPressed: null,
                                      child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: colorScheme.onSecondaryContainer, strokeWidth: 2.5)),
                                    );
                                  }

                                  return FilledButton.tonalIcon(
                                    onPressed: (timerResendEmailTick ?? 0) <= 0 ? resendEmail : null,
                                    icon: Icon((timerResendEmailTick ?? 0) <= 0 ? Icons.forward_to_inbox : Icons.hourglass_top_outlined),
                                    label: Text((timerResendEmailTick ?? 0) <= 0 ? strings.resendEmail : strings.seconds(timerResendEmailTick ?? 0)),
                                  );
                                },
                              ),
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
                      onPressed: completeRegistration,
                      child: notifier.value is CompletingRegistrationState ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: colorScheme.onPrimary, strokeWidth: 2.5)) : Text(strings.completeRegistration),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  Future<void> resendEmail() async {
    try {
      if (notifier.isLoading) return;

      await notifier.resendEmail();
      if (notifier.value is ErrorEmailVerificationState) throw Exception((notifier.value as ErrorEmailVerificationState).message);

      startTimerResendEmail();
    } catch (e) {
      if (!mounted) return;
      await ErrorDialog.show(context, e.toString());
    }
  }

  Future<void> completeRegistration() async {
    try {
      if (notifier.isLoading) return;

      await notifier.completeRegistration();
      if (notifier.value is ErrorEmailVerificationState) throw Exception((notifier.value as ErrorEmailVerificationState).message);

      if (!mounted) return;
      context.goNamed(HomePage.route);
    } catch (e) {
      if (!mounted) return;
      await ErrorDialog.show(context, e.toString());
    }
  }

  void startTimerResendEmail() {
    if (timerResendEmail?.isActive != true) {
      setState(() => timerResendEmailTick = maxSeconds);

      timerResendEmail = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          timerResendEmailTick = maxSeconds - timer.tick;

          if (timer.tick >= maxSeconds) {
            timerResendEmailTick = null;
            timerResendEmail?.cancel();
          }
        });
      });
    }
  }

  @override
  void dispose() {
    timerResendEmail?.cancel();
    super.dispose();
  }
}
