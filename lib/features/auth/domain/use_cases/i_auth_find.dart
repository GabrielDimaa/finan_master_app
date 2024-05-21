import 'package:finan_master_app/features/auth/domain/entities/auth_entity.dart';

abstract interface class IAuthFind {
  Future<AuthEntity?> find();
}
