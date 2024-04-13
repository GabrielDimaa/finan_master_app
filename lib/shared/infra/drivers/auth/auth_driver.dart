import 'package:finan_master_app/features/user_account/infra/models/user_account_model.dart';
import 'package:finan_master_app/shared/classes/connectivity_network.dart';
import 'package:finan_master_app/shared/infra/drivers/auth/auth_exception.dart';
import 'package:finan_master_app/shared/infra/drivers/auth/i_auth_driver.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uuid/uuid.dart';

class AuthDriver implements IAuthDriver {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthDriver({required FirebaseAuth firebaseAuth, required GoogleSignIn googleSignIn})
      : _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn;

  @override
  Future<void> createUserWithEmailAndPassword() async {
    try {
      await ConnectivityNetwork.hasInternet();

      final UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: '', password: '');

      User? user = _firebaseAuth.currentUser;
      if (user == null) throw Exception();

      await sendVerificationEmail(user.uid);
    } on FirebaseAuthException catch (e) {
      throw e.getError();
    }
  }

  @override
  Future<void> loginWithEmailAndPassword({required String email, required String password}) async {
    try {
      await ConnectivityNetwork.hasInternet();

      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

      if (_firebaseAuth.currentUser == null) throw Exception(R.strings.userNotFound);
    } on FirebaseAuthException catch (e) {
      throw e.getError();
    }
  }

  @override
  Future<void> loginWithGoogle() async {
    try {
      await ConnectivityNetwork.hasInternet();

      if (await _googleSignIn.isSignedIn()) await _googleSignIn.signOut();
      final GoogleSignInAccount? account = await _googleSignIn.signIn();

      if (account != null) {
        final GoogleSignInAuthentication authentication = await account.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(accessToken: authentication.accessToken, idToken: authentication.idToken);
        final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      }
    } on FirebaseAuthException catch (e) {
      throw e.getError();
    }
  }

  @override
  Future<void> sendVerificationEmail(String userId) async {
    try {
      await ConnectivityNetwork.hasInternet();

      if (_firebaseAuth.currentUser == null) throw Exception();
      await _firebaseAuth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw e.getError();
    }
  }

  @override
  Future<bool> checkEmailVerified(String userId) async {
    try {
      await ConnectivityNetwork.hasInternet();

      if (_firebaseAuth.currentUser == null) throw Exception();
      await _firebaseAuth.currentUser!.reload();

      return _firebaseAuth.currentUser!.emailVerified;
    } on FirebaseAuthException catch (e) {
      throw e.getError();
    }
  }
}
