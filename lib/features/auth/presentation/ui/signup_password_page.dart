import 'package:finan_master_app/features/auth/presentation/ui/email_verification_page.dart';
import 'package:finan_master_app/features/auth/presentation/view_models/signup_view_model.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/dialog/error_dialog.dart';
import 'package:finan_master_app/shared/presentation/ui/components/form/validators/input_confirm_password_validator.dart';
import 'package:finan_master_app/shared/presentation/ui/components/form/validators/input_password_validator.dart';
import 'package:finan_master_app/shared/presentation/ui/components/form/validators/input_required_validator.dart';
import 'package:finan_master_app/shared/presentation/ui/components/form/validators/input_validators.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignupPasswordPage extends StatefulWidget {
  static const route = 'signup_password';

  final SignupViewModel viewModel;

  const SignupPasswordPage({super.key, required this.viewModel});

  @override
  State<SignupPasswordPage> createState() => _SignupPasswordPageState();
}

class _SignupPasswordPageState extends State<SignupPasswordPage> with ThemeContext {
  SignupViewModel get viewModel => widget.viewModel;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  bool showPassword = false;
  bool showConfirmPassword = false;

  void setShowPassword() => setState(() => showPassword = !showPassword);

  void setShowConfirmPassword() => setState(() => showConfirmPassword = !showConfirmPassword);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
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
                        child: Text(strings.password, style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w500)),
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
                                label: Text(strings.password),
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: ExcludeFocus(
                                  child: IconButton(
                                    onPressed: setShowPassword,
                                    icon: Visibility(
                                      visible: !showPassword,
                                      replacement: const Icon(Icons.visibility_outlined),
                                      child: const Icon(Icons.visibility_off_outlined),
                                    ),
                                  ),
                                ),
                              ),
                              enabled: !viewModel.isLoading,
                              controller: passwordController,
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.next,
                              obscureText: !showPassword,
                              validator: InputValidators([InputRequiredValidator(), InputPasswordValidator()]).validate,
                              onSaved: (String? value) => viewModel.signup.auth.password = value?.trim() ?? '',
                            ),
                            const Spacing.y(2),
                            TextFormField(
                              decoration: InputDecoration(
                                label: Text(strings.confirmPassword),
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: ExcludeFocus(
                                  child: IconButton(
                                    onPressed: setShowConfirmPassword,
                                    icon: Visibility(
                                      visible: !showConfirmPassword,
                                      replacement: const Icon(Icons.visibility_outlined),
                                      child: const Icon(Icons.visibility_off_outlined),
                                    ),
                                  ),
                                ),
                              ),
                              enabled: !viewModel.isLoading,
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.done,
                              obscureText: !showConfirmPassword,
                              validator: (String? value) => InputValidators([InputRequiredValidator(), InputConfirmPasswordValidator(passwordController.text)]).validate(value),
                            ),
                            const Spacing.y(3),
                            FilledButton(
                              onPressed: signup,
                              child: viewModel.isLoading ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: colorScheme.onPrimary, strokeWidth: 2.5)) : Text(strings.signup),
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
      }
    );
  }

  Future<void> signup() async {
    try {
      if (viewModel.isLoading) return;

      if (formKey.currentState?.validate() ?? false) {
        formKey.currentState?.save();

        await viewModel.signupWithEmailAndPassword.execute();
        viewModel.signupWithEmailAndPassword.throwIfError();

        if (!mounted) return;
        context.goNamed(EmailVerificationPage.route);
      } else {
        setState(() => autovalidateMode = AutovalidateMode.always);
      }
    } catch (e) {
      if (!mounted) return;
      await ErrorDialog.show(context, e.toString());
    }
  }
}
