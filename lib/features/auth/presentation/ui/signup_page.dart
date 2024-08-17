import 'package:finan_master_app/di/dependency_injection.dart';
import 'package:finan_master_app/features/auth/presentation/notifiers/signup_notifier.dart';
import 'package:finan_master_app/features/auth/presentation/states/signup_state.dart';
import 'package:finan_master_app/features/auth/presentation/ui/login_page.dart';
import 'package:finan_master_app/features/auth/presentation/ui/signup_password_page.dart';
import 'package:finan_master_app/features/first_steps/presentation/ui/first_steps_page.dart';
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

class SignupPage extends StatefulWidget {
  static const route = 'signup';

  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> with ThemeContext {
  final SignupNotifier notifier = DI.get<SignupNotifier>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
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
                child: Text(strings.signup, style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w500)),
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
                        label: Text(strings.fullName),
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.sentences,
                      validator: InputRequiredValidator().validate,
                      onSaved: (String? value) => notifier.value.entity.userAccount.name = value?.trim() ?? '',
                    ),
                    const Spacing.y(2),
                    TextFormField(
                        decoration: InputDecoration(
                          label: Text(strings.email),
                          prefixIcon: const Icon(Icons.alternate_email_outlined),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        validator: InputValidators([InputRequiredValidator(), InputEmailValidator()]).validate,
                        onSaved: (String? value) {
                          notifier.value.entity.userAccount.email = value?.trim() ?? '';
                          notifier.value.entity.auth.email = value?.trim() ?? '';
                        }),
                    const Spacing.y(3),
                    FilledButton(
                      onPressed: toPassword,
                      child: Text(strings.continueButton),
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
                    ValueListenableBuilder(
                      valueListenable: notifier,
                      builder: (_, state, __) {
                        return FilledButton.icon(
                          style: FilledButton.styleFrom(backgroundColor: colorScheme.onInverseSurface, foregroundColor: colorScheme.inverseSurface),
                          onPressed: createAccountWithGoogle,
                          icon: state is SigningUpWithGoogleState ? const SizedBox.shrink() : SvgPicture.asset('assets/icons/google.svg', width: 22, height: 22),
                          label: state is SigningUpWithGoogleState ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2.5)) : Text(strings.createAccountWithGoogle),
                        );
                      }
                    ),
                    const Spacing.y(4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(strings.alreadyHaveAccount),
                        TextButton(
                          onPressed: toLogin,
                          child: Text(strings.login),
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
  }

  Future<void> toPassword() async {
    try {
      if (formKey.currentState?.validate() == true) {
        formKey.currentState!.save();

        context.pushNamed(SignupPasswordPage.route, extra: notifier);
      } else {
        setState(() => autovalidateMode = AutovalidateMode.always);
      }
    } catch (e) {
      await ErrorDialog.show(context, e.toString());
    }
  }

  Future<void> createAccountWithGoogle() async {
    try {
      if (notifier.isLoading) return;

      await notifier.signupWithGoogle();
      if (notifier.value is ErrorSignupState) throw Exception((notifier.value as ErrorSignupState).message);

      if (!mounted) return;
      context.goNamed(FirstStepsPage.route, extra: true);
    } catch (e) {
      if (!mounted) return;
      await ErrorDialog.show(context, e.toString());
    }
  }

  void toLogin() => context.goNamed(LoginPage.route);
}
