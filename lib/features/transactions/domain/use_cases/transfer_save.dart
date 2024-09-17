import 'package:finan_master_app/features/statement/domain/entities/statement_entity.dart';
import 'package:finan_master_app/features/statement/domain/repositories/i_statement_repository.dart';
import 'package:finan_master_app/features/transactions/domain/entities/transfer_entity.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_transfer_repository.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_transfer_save.dart';
import 'package:finan_master_app/shared/domain/repositories/i_local_db_transaction_repository.dart';
import 'package:finan_master_app/shared/exceptions/exceptions.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';

class TransferSave implements ITransferSave {
  final ITransferRepository _repository;
  final IStatementRepository _statementRepository;
  final ILocalDBTransactionRepository _localDBTransactionRepository;

  TransferSave({
    required ITransferRepository repository,
    required IStatementRepository statementRepository,
    required ILocalDBTransactionRepository localDBTransactionRepository,
  })  : _repository = repository,
        _statementRepository = statementRepository,
        _localDBTransactionRepository = localDBTransactionRepository;

  @override
  Future<TransferEntity> save(TransferEntity entity) async {
    if (entity.idAccountFrom == null) throw ValidationException(R.strings.uninformedAccount);
    if (entity.idAccountTo == null) throw ValidationException(R.strings.uninformedAccount);
    if (entity.amount <= 0) throw ValidationException(R.strings.greaterThanZero);
    if (entity.idAccountFrom == entity.idAccountTo) throw ValidationException(R.strings.sourceAccountAndDestinationEquals);

    final List<StatementEntity> statements = [];

    if (entity.isNew) {
      statements.addAll([
        StatementEntity(
          id: null,
          createdAt: null,
          deletedAt: null,
          amount: -entity.amount.abs(),
          date: DateTime.now(),
          idAccount: entity.idAccountFrom!,
          idExpense: null,
          idIncome: null,
          idTransfer: entity.id,
        ),
        StatementEntity(
          id: null,
          createdAt: null,
          deletedAt: null,
          amount: entity.amount,
          date: DateTime.now(),
          idAccount: entity.idAccountTo!,
          idExpense: null,
          idIncome: null,
          idTransfer: entity.id,
        ),
      ]);
    } else {
      final List<StatementEntity> result = await _statementRepository.findByIdTransfer(entity.id);

      statements.addAll(result.map((e) => e..updateFromTransfer(entity)));
    }

    return await _localDBTransactionRepository.openTransaction<TransferEntity>((txn) async {
      late final TransferEntity entitySaved;

      await Future.wait([
        _repository.save(entity, txn: txn).then((value) => entitySaved = value),
        Future(() async {
          for (var statement in statements) {
            await _statementRepository.save(statement, txn: txn);
          }
        }),
      ]);

      return entitySaved;
    });
  }
}
