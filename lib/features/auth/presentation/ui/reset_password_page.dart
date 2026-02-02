import 'package:finan_master_app/di/dependency_injection.dart';
import 'package:finan_master_app/features/auth/presentation/view_models/reset_password_view_model.dart';
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
  final ResetPasswordViewModel viewModel = DI.get<ResetPasswordViewModel>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel.send,
      builder: (_, __) {
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
                              enabled: !viewModel.send.running && !viewModel.send.completed,
                              controller: emailController,
                              validator: InputValidators([InputRequiredValidator(), InputEmailValidator()]).validate,
                            ),
                            const Spacing.y(3),
                            Builder(
                              builder: (_) {
                                if (viewModel.send.running) {
                                  return FilledButton(
                                    onPressed: resetPassword,
                                    child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(color: colorScheme.onPrimary, strokeWidth: 2.5),
                                    ),
                                  );
                                }

                                if (viewModel.send.completed) {
                                  return FilledButton.icon(
                                    onPressed: null,
                                    icon: const Icon(Icons.check),
                                    label: Text(strings.sent),
                                  );
                                }

                                return FilledButton(
                                  onPressed: resetPassword,
                                  child: Text(strings.resetPassword),
                                );
                              },
                            ),
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
      if (viewModel.send.running || viewModel.send.completed) return;

      if (formKey.currentState?.validate() ?? false) {
        formKey.currentState?.save();

        await viewModel.send.execute(emailController.text);
        viewModel.send.throwIfError();

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
