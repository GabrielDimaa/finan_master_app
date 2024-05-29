import 'package:finan_master_app/features/auth/domain/use_cases/i_reset_password.dart';
import 'package:finan_master_app/features/auth/presentation/states/reset_password_state.dart';
import 'package:flutter/cupertino.dart';

class ResetPasswordNotifier extends ValueNotifier<ResetPasswordState> {
  final IResetPassword _resetPassword;

  ResetPasswordNotifier(IResetPassword resetPassword)
      : _resetPassword = resetPassword,
        super(ResetPasswordState.start());

  bool get isLoading => value is SendingResetPasswordState;

  bool get isSentResetPassword => value is SentResetPasswordState;

  Future<void> send(String email) async {
    try {
      value = value.setSendingResetPasswordState();

      await _resetPassword.send(email);

      value = value.setSentResetPasswordState();
    } catch (e) {
      value = value.setError(e);
    }
  }
}
