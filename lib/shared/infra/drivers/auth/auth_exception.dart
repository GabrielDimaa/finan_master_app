import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';
import 'package:firebase_auth/firebase_auth.dart';

extension FirebaseAuthExceptionExtension on FirebaseAuthException {
  Exception getError() {
    switch (code.toLowerCase()) {
      case "auth/user-not-found":
      case "user-not-found":
        return Exception(R.strings.userNotFound);
      case "auth/wrong-password":
      case "wrong-password":
        return Exception(R.strings.incorrectPassword);
      case "auth/invalid-email":
      case "invalid-email":
        return Exception(R.strings.emailInvalid);
      case "auth/email-already-in-use":
      case "email-already-in-use":
        return Exception(R.strings.emailInUse);
      case "auth/account-exists-with-different-credential":
      case "account-exists-with-different-credential":
        return Exception(R.strings.userNotFound);
      case "auth/invalid-credential":
      case "invalid-credential":
        return Exception(R.strings.userNotFound);
      default:
        return Exception(message);
    }
  }
}
