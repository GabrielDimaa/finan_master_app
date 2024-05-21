import 'package:finan_master_app/features/auth/domain/entities/auth_entity.dart';
import 'package:finan_master_app/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:finan_master_app/features/auth/domain/use_cases/i_auth_find.dart';

class AuthFind implements IAuthFind {
  final IAuthRepository _repository;

  AuthFind({required IAuthRepository repository}) : _repository = repository;

  @override
  Future<AuthEntity?> find() => _repository.find();
}
