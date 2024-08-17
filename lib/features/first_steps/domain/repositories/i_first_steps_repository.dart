import 'package:finan_master_app/features/first_steps/domain/entities/first_steps_entity.dart';

abstract interface class IFirstStepsRepository {
  Future<FirstStepsEntity?> find();

  Future<FirstStepsEntity> save(FirstStepsEntity entity);
}
