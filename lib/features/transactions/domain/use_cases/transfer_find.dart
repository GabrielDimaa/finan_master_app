import 'package:finan_master_app/features/transactions/domain/entities/transfer_entity.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_transfer_repository.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_transfer_find.dart';

class TransferFind implements ITransferFind {
  final ITransferRepository _repository;

  TransferFind({required ITransferRepository repository}) : _repository = repository;

  @override
  Future<List<TransferEntity>> findByPeriod(DateTime start, DateTime end) => _repository.findByPeriod(start, end);
}
