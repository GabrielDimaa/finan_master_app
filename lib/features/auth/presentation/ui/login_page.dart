import 'package:finan_master_app/di/dependency_injection.dart';
import 'package:finan_master_app/features/auth/presentation/notifiers/login_notifier.dart';
import 'package:finan_master_app/features/auth/presentation/states/login_state.dart';
import 'package:finan_master_app/features/auth/presentation/ui/reset_password_page.dart';
import 'package:finan_master_app/features/auth/presentation/ui/signup_page.dart';
import 'package:finan_master_app/features/home/presentation/ui/home_page.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/dialog/error_dialog.dart';
import 'package:finan_master_app/shared/presentation/ui/components/form/validators/input_email_validator.dart';
import 'package:finan_master_app/shared/presentation/ui/components/form/validators/input_required_validator.dart';
import 'package:finan_master_app/shared/presentation/ui/components/form/validators/input_validators.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  static const route = 'login';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with ThemeContext {
  final LoginNotifier notifier = DI.get<LoginNotifier>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  bool showPassword = false;

  void setShowPassword() => setState(() => showPassword = !showPassword);

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
                    child: Text(strings.login, style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w500)),
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
                          enabled: !notifier.isLoading,
                          validator: InputValidators([InputRequiredValidator(), InputEmailValidator()]).validate,
                          onSaved: (String? value) => state.entity.email = value?.trim() ?? '',
                        ),
                        const Spacing.y(2),
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
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,
                          enabled: !notifier.isLoading,
                          obscureText: !showPassword,
                          validator: InputRequiredValidator().validate,
                          onSaved: (String? value) => state.entity.password = value?.trim(),
                        ),
                        const Spacing.y(),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: forgotPassword,
                            child: Text(strings.forgotPassword),
                          ),
                        ),
                        const Spacing.y(),
                        FilledButton(
                          onPressed: login,
                          child: notifier.value is LoggingWithEmailAndPasswordState ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: colorScheme.onPrimary, strokeWidth: 2.5)) : Text(strings.loginButtonName),
                        ),
                        const Spacing.y(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Expanded(child: Divider()),
                            const Spacing.x(),
                            Text(strings.or),
                            const Spacing.x(),
                            const Expanded(child: Divider()),
                          ],
                        ),
                        const Spacing.y(),
                        FilledButton.icon(
                          style: FilledButton.styleFrom(backgroundColor: colorScheme.onInverseSurface, foregroundColor: colorScheme.inverseSurface),
                          onPressed: loginWithGoogle,
                          icon: notifier.value is LoggingWithGoogleState ? const SizedBox.shrink() : SvgPicture.asset('assets/icons/google.svg', width: 22, height: 22),
                          label: notifier.value is LoggingWithGoogleState ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2.5)) : Text(strings.loginWithGoogle),
                        ),
                        const Spacing.y(4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(strings.doNotHaveAccount),
                            TextButton(
                              onPressed: toSignup,
                              child: Text(strings.signup),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> login() async {
    try {
      if (notifier.isLoading) return;

      if (formKey.currentState?.validate() == true) {
        formKey.currentState!.save();

        await notifier.loginWithEmailAndPassword();
        if (notifier.value is ErrorLoginState) throw Exception((notifier.value as ErrorLoginState).message);

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

  Future<void> loginWithGoogle() async {
    try {
      if (notifier.isLoading) return;

      await notifier.loginWithGoogle();
      if (notifier.value is ErrorLoginState) throw Exception((notifier.value as ErrorLoginState).message);

      if (!mounted) return;
      context.goNamed(HomePage.route);
    } catch (e) {
      if (!mounted) return;
      await ErrorDialog.show(context, e.toString());
    }
  }

  Future<void> forgotPassword() async {
    try {
      if (notifier.isLoading) return;

      if (!mounted) return;
      context.pushNamed(ResetPasswordPage.route);
    } catch (e) {
      await ErrorDialog.show(context, e.toString());
    }
  }

  void toSignup() {
    if (notifier.isLoading) return;
    context.goNamed(SignupPage.route);
  }
}
