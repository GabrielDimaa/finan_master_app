import 'package:finan_master_app/features/statement/domain/repositories/i_statement_repository.dart';
import 'package:finan_master_app/features/transactions/domain/entities/transfer_entity.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_transfer_repository.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_transfer_delete.dart';
import 'package:finan_master_app/shared/domain/repositories/i_local_db_transaction_repository.dart';

class TransferDelete implements ITransferDelete {
  final ITransferRepository _repository;
  final IStatementRepository _statementRepository;
  final ILocalDBTransactionRepository _localDBTransactionRepository;

  TransferDelete({
    required ITransferRepository repository,
    required IStatementRepository statementRepository,
    required ILocalDBTransactionRepository localDBTransactionRepository,
  })  : _repository = repository,
        _statementRepository = statementRepository,
        _localDBTransactionRepository = localDBTransactionRepository;

  @override
  Future<void> delete(TransferEntity entity) async {
    await _localDBTransactionRepository.openTransaction((txn) async {
      await Future.wait([
        _repository.delete(entity, txn: txn),
        _statementRepository.deleteByIdTransfer(entity.id, txn: txn),
      ]);
    });
  }
}
