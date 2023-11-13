import 'package:finan_master_app/shared/domain/domain/i_delete_app_data.dart';
import 'package:finan_master_app/shared/domain/repositories/i_delete_app_data_repository.dart';

class DeleteAppData implements IDeleteAppData {
  final IDeleteAppDataRepository _repository;

  DeleteAppData({required IDeleteAppDataRepository repository}) : _repository = repository;

  @override
  Future<void> delete() => _repository.delete();
}
