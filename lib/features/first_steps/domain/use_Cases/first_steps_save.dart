import 'package:finan_master_app/features/first_steps/domain/entities/first_steps_entity.dart';
import 'package:finan_master_app/features/first_steps/domain/repositories/i_first_steps_repository.dart';
import 'package:finan_master_app/features/first_steps/domain/use_Cases/i_first_steps_save.dart';

class FirstStepsSave implements IFirstStepsSave {
  final IFirstStepsRepository _repository;

  FirstStepsSave({required IFirstStepsRepository repository}) : _repository = repository;

  @override
  Future<FirstStepsEntity> save(FirstStepsEntity entity) => _repository.save(entity);
}
