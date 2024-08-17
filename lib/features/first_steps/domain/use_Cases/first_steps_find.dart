import 'package:finan_master_app/features/first_steps/domain/entities/first_steps_entity.dart';
import 'package:finan_master_app/features/first_steps/domain/repositories/i_first_steps_repository.dart';
import 'package:finan_master_app/features/first_steps/domain/use_Cases/i_first_steps_find.dart';

class FirstStepsFind implements IFirstStepsFind {
  final IFirstStepsRepository _repository;

  FirstStepsFind({required IFirstStepsRepository repository}) : _repository = repository;

  @override
  Future<FirstStepsEntity?> find() => _repository.find();
}
