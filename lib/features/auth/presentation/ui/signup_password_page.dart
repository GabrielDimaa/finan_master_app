import 'package:finan_master_app/features/auth/presentation/notifiers/signup_notifier.dart';
import 'package:finan_master_app/features/home/presentation/ui/home_page.dart';
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

  final SignupNotifier notifier;

  const SignupPasswordPage({super.key, required this.notifier});

  @override
  State<SignupPasswordPage> createState() => _SignupPasswordPageState();
}

class _SignupPasswordPageState extends State<SignupPasswordPage> with ThemeContext {
  SignupNotifier get notifier => widget.notifier;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  bool showPassword = false;
  bool showConfirmPassword = false;

  void setShowPassword() => setState(() => showPassword = !showPassword);

  void setShowConfirmPassword() => setState(() => showConfirmPassword = !showConfirmPassword);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: (_, state, __) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
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
                            suffixIcon: IconButton(
                              onPressed: setShowPassword,
                              icon: Visibility(
                                visible: !showPassword,
                                replacement: const Icon(Icons.visibility_outlined),
                                child: const Icon(Icons.visibility_off_outlined),
                              ),
                            ),
                          ),
                          enabled: !notifier.isLoading,
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.next,
                          obscureText: !showPassword,
                          validator: InputValidators([InputRequiredValidator(), InputPasswordValidator()]).validate,
                          onSaved: (String? value) => notifier.value.entity.auth.password = value?.trim() ?? '',
                        ),
                        const Spacing.y(2),
                        TextFormField(
                          decoration: InputDecoration(
                            label: Text(strings.confirmPassword),
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              onPressed: setShowConfirmPassword,
                              icon: Visibility(
                                visible: !showConfirmPassword,
                                replacement: const Icon(Icons.visibility_outlined),
                                child: const Icon(Icons.visibility_off_outlined),
                              ),
                            ),
                          ),
                          enabled: !notifier.isLoading,
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,
                          obscureText: !showConfirmPassword,
                          validator: InputValidators([InputRequiredValidator(), InputConfirmPasswordValidator(passwordController.text)]).validate,
                        ),
                        const Spacing.y(3),
                        FilledButton(
                          onPressed: signup,
                          child: notifier.isLoading ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: colorScheme.onPrimary)) : Text(strings.signup),
                        ),
                      ],
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

  Future<void> signup() async {
    try {
      if (formKey.currentState?.validate() ?? false) {
        formKey.currentState?.save();

        await notifier.signupWithEmailAndPassword();

        if (!mounted) return;
        context.goNamed(HomePage.route);
      } else {
        setState(() => autovalidateMode = AutovalidateMode.always);
      }
    } catch (e) {
      if (!mounted) return;
      await ErrorDialog.show(context, e.toString());
    }
  }
}
