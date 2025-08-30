import 'package:finan_master_app/features/auth/domain/entities/auth_entity.dart';
import 'package:finan_master_app/features/auth/domain/entities/signup_entity.dart';
import 'package:finan_master_app/features/auth/domain/enums/auth_type.dart';
import 'package:finan_master_app/features/auth/helpers/factories/auth_factory.dart';
import 'package:finan_master_app/features/auth/infra/models/auth_model.dart';
import 'package:finan_master_app/features/user_account/domain/entities/user_account_entity.dart';

abstract class SignupFactory {
  static SignupEntity newEntity() {
    return SignupEntity(
      auth: AuthFactory.withEmail(email: '', password: ''),
      userAccount: UserAccountEntity(
        id: null,
        createdAt: null,
        deletedAt: null,
        name: '',
        email: '',
      ),
    );
  }
}
