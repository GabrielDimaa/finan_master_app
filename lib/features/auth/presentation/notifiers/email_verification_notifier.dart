import 'dart:async';

import 'package:finan_master_app/features/auth/domain/use_cases/i_signup_auth.dart';
import 'package:finan_master_app/features/auth/presentation/states/email_verification_state.dart';
import 'package:flutter/cupertino.dart';

class EmailVerificationNotifier extends ValueNotifier<EmailVerificationState> {
  final ISignupAuth _signupAuth;

  EmailVerificationNotifier({required ISignupAuth signupAuth})
      : _signupAuth = signupAuth,
        super(EmailVerificationState.start());

  bool get isLoading => value is CompletingRegistrationState || value is ResendingEmailVerificationState;

  Future<void> resendEmail() async {
    try {
      value = value.setResendingEmailState();

      await _signupAuth.sendEmailVerification();

      value = value.setResendEmailState();
    } catch (e) {
      value = value.setError(e);
    }
  }

  Future<void> completeRegistration() async {
    try {
      value = value.setCompletingRegistrationState();

      await _signupAuth.completeRegistration();
    } catch (e) {
      value = value.setError(e);
    }
  }
}
