import 'package:finan_master_app/features/transactions/domain/entities/transfer_entity.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_transfer_repository.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_transfer_delete.dart';

class TransferDelete implements ITransferDelete {
  final ITransferRepository _repository;

  TransferDelete({required ITransferRepository repository}) : _repository = repository;

  @override
  Future<void> delete(TransferEntity entity) => _repository.delete(entity);
}
