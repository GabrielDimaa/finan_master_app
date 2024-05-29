import 'package:finan_master_app/di/dependency_injection.dart';
import 'package:finan_master_app/features/auth/presentation/notifiers/reset_password_notifier.dart';
import 'package:finan_master_app/features/auth/presentation/states/reset_password_state.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/dialog/error_dialog.dart';
import 'package:finan_master_app/shared/presentation/ui/components/form/validators/input_email_validator.dart';
import 'package:finan_master_app/shared/presentation/ui/components/form/validators/input_required_validator.dart';
import 'package:finan_master_app/shared/presentation/ui/components/form/validators/input_validators.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';

class ResetPasswordPage extends StatefulWidget {
  static const route = 'reset-password';

  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> with ThemeContext {
  final ResetPasswordNotifier notifier = DI.get<ResetPasswordNotifier>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: (_, state, __) {
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Spacing.y(4),
                      Align(
                        alignment: Alignment.center,
                        child: Text(strings.resetPassword, style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w500)),
                      ),
                      const Spacing.y(2),
                      Align(
                        alignment: Alignment.center,
                        child: Text(strings.resetPasswordExplication, style: textTheme.bodyMedium, textAlign: TextAlign.center),
                      ),
                      const Spacing.y(4),
                      Form(
                        key: formKey,
                        autovalidateMode: autovalidateMode,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                label: Text(strings.email),
                                prefixIcon: const Icon(Icons.alternate_email_outlined),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              enabled: !notifier.isLoading && !notifier.isSentResetPassword,
                              controller: emailController,
                              validator: InputValidators([InputRequiredValidator(), InputEmailValidator()]).validate,
                            ),
                            const Spacing.y(3),
                            switch (state) {
                              SendingResetPasswordState _ => FilledButton(onPressed: resetPassword, child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: colorScheme.onPrimary))),
                              SentResetPasswordState _ => FilledButton.icon(onPressed: null, icon: const Icon(Icons.check), label: Text(strings.sent)),
                              _ => FilledButton(onPressed: resetPassword, child: Text(strings.resetPassword)),
                            },
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 4, top: 4),
                  child: BackButton(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> resetPassword() async {
    try {
      if (notifier.isLoading || notifier.isSentResetPassword) return;

      if (formKey.currentState?.validate() ?? false) {
        formKey.currentState?.save();

        await notifier.send(emailController.text);
        if (notifier.value is ErrorResetPasswordState) throw Exception((notifier.value as ErrorResetPasswordState).message);

        showSnackBar();
      } else {
        setState(() => autovalidateMode = AutovalidateMode.always);
      }
    } catch (e) {
      if (!mounted) return;
      await ErrorDialog.show(context, e.toString());
    }
  }

  void showSnackBar() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(strings.resetPasswordNotification)),
    );
  }
}
