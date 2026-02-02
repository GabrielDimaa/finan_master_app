import 'package:finan_master_app/features/auth/domain/use_cases/i_reset_password.dart';
import 'package:finan_master_app/shared/presentation/commands/command.dart';
import 'package:flutter/cupertino.dart';

class ResetPasswordViewModel extends ChangeNotifier {
  late final Command1<void, String> send;

  ResetPasswordViewModel({required IResetPassword resetPassword}) {
    send = Command1<void, String>(resetPassword.send);
  }
}
