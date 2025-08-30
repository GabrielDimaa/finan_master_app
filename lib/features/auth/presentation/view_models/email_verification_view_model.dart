import 'package:finan_master_app/features/auth/domain/use_cases/i_signup_auth.dart';
import 'package:finan_master_app/shared/presentation/commands/command.dart';
import 'package:flutter/foundation.dart';

class EmailVerificationViewModel extends ChangeNotifier {
  late final Command0 resendEmail;
  late final Command0 completeRegistration;

  EmailVerificationViewModel({required ISignupAuth signupAuth}) {
    resendEmail = Command0(signupAuth.sendEmailVerification);
    completeRegistration = Command0(signupAuth.completeRegistration);
  }

  bool get isLoading => resendEmail.running || completeRegistration.running;
}
