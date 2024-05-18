import 'package:finan_master_app/features/auth/domain/entities/auth_entity.dart';
import 'package:finan_master_app/features/user_account/domain/entities/user_account_entity.dart';

class SignupEntity {
  AuthEntity auth;
  UserAccountEntity userAccount;

  SignupEntity({required this.auth, required this.userAccount});
}
