import 'package:finan_master_app/features/auth/domain/enums/auth_type.dart';
import 'package:finan_master_app/features/auth/infra/models/auth_model.dart';
import 'package:finan_master_app/features/auth/infra/models/signup_model.dart';
import 'package:finan_master_app/features/user_account/infra/models/user_account_model.dart';
import 'package:finan_master_app/shared/classes/connectivity_network.dart';
import 'package:finan_master_app/shared/infra/drivers/auth/i_auth_driver.dart';
import 'package:finan_master_app/shared/infra/drivers/crypt/i_crypt_aes.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uuid/uuid.dart';

class AuthDriver implements IAuthDriver {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final ICryptAES _cryptAES;

  AuthDriver({required FirebaseAuth firebaseAuth, required GoogleSignIn googleSignIn, required ICryptAES cryptAES})
      : _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn,
        _cryptAES = cryptAES;

  @override
  Future<void> signupWithEmailAndPassword({required String email, required String password}) async {
    try {
      await ConnectivityNetwork.hasInternet();

      final String passwordDecrypted = _cryptAES.decrypt(password);

      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: passwordDecrypted);

      _firebaseAuth.currentUser ?? (throw Exception(R.strings.failedToAuthenticate));

      await sendVerificationEmail();
    } on FirebaseAuthException catch (e) {
      throw e.getError();
    }
  }

  @override
  Future<SignupModel?> signupWithGoogle() async {
    try {
      final ({GoogleSignInAccount account, UserCredential userCredential})? result = await _signInWithGoogle();

      if (result == null) return null;

      final AuthModel authModel = AuthModel(
        id: result.userCredential.user?.uid ?? (throw Exception(R.strings.failedToAuthenticate)),
        createdAt: null,
        deletedAt: null,
        email: result.account.email,
        emailVerified: true,
        password: null,
        type: AuthType.google,
      );

      final UserAccountModel userAccount = UserAccountModel(
        id: const Uuid().v1(),
        createdAt: DateTime.now(),
        deletedAt: null,
        name: result.account.displayName ?? result.account.email,
        email: result.account.email,
      );

      return SignupModel(auth: authModel, userAccount: userAccount);
    } on FirebaseAuthException catch (e) {
      throw e.getError();
    }
  }

  @override
  Future<void> loginWithEmailAndPassword({required String email, required String password}) async {
    try {
      await ConnectivityNetwork.hasInternet();

      final String passwordDecrypted = _cryptAES.decrypt(password);

      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: passwordDecrypted);

      if (_firebaseAuth.currentUser == null) throw Exception(R.strings.userNotFound);
    } on FirebaseAuthException catch (e) {
      throw e.getError();
    }
  }

  @override
  Future<AuthModel?> loginWithGoogle() async {
    try {
      final ({GoogleSignInAccount account, UserCredential userCredential})? result = await _signInWithGoogle();

      if (result == null) return null;

      return AuthModel(
        id: result.userCredential.user?.uid ?? (throw Exception(R.strings.failedToAuthenticate)),
        createdAt: DateTime.now(),
        deletedAt: null,
        email: result.account.email,
        emailVerified: true,
        password: null,
        type: AuthType.google,
      );
    } on FirebaseAuthException catch (e) {
      throw e.getError();
    }
  }

  @override
  Future<void> sendVerificationEmail() async {
    try {
      await ConnectivityNetwork.hasInternet();

      if (_firebaseAuth.currentUser == null) throw Exception(R.strings.failedToAuthenticate);
      await _firebaseAuth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw e.getError();
    }
  }

  @override
  Future<void> sendEmailResetPassword(String email) async {
    try {
      await ConnectivityNetwork.hasInternet();

      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw e.getError();
    }
  }

  @override
  Future<bool> checkEmailVerified() async {
    try {
      await ConnectivityNetwork.hasInternet();

      if (_firebaseAuth.currentUser == null) throw Exception(R.strings.failedToAuthenticate);

      await _firebaseAuth.currentUser!.reload();
      return _firebaseAuth.currentUser!.emailVerified;
    } on FirebaseAuthException catch (e) {
      throw e.getError();
    }
  }

  @override
  Future<bool> checkIsLogged() => Future.value(_firebaseAuth.currentUser != null);

  Future<({GoogleSignInAccount account, UserCredential userCredential})?> _signInWithGoogle() async {
    await ConnectivityNetwork.hasInternet();

    if (await _googleSignIn.isSignedIn()) await _googleSignIn.signOut();
    final GoogleSignInAccount? account = await _googleSignIn.signIn();

    if (account == null) return null;

    final GoogleSignInAuthentication authentication = await account.authentication;

    final UserCredential userCredential = await _firebaseAuth.signInWithCredential(GoogleAuthProvider.credential(accessToken: authentication.accessToken, idToken: authentication.idToken));

    return (account: account, userCredential: userCredential);
  }
}

extension _FirebaseAuthExceptionExtension on FirebaseAuthException {
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
