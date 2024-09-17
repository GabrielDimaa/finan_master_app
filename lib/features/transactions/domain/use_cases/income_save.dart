import 'package:finan_master_app/features/statement/domain/entities/statement_entity.dart';
import 'package:finan_master_app/features/statement/domain/repositories/i_statement_repository.dart';
import 'package:finan_master_app/features/statement/helpers/statement_factory.dart';
import 'package:finan_master_app/features/transactions/domain/entities/income_entity.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_income_repository.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_income_save.dart';
import 'package:finan_master_app/shared/domain/repositories/i_local_db_transaction_repository.dart';
import 'package:finan_master_app/shared/exceptions/exceptions.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';

class IncomeSave implements IIncomeSave {
  final IIncomeRepository _repository;
  final IStatementRepository _statementRepository;
  final ILocalDBTransactionRepository _localDBTransactionRepository;

  IncomeSave({
    required IIncomeRepository repository,
    required IStatementRepository statementRepository,
    required ILocalDBTransactionRepository localDBTransactionRepository,
  })  : _repository = repository,
        _statementRepository = statementRepository,
        _localDBTransactionRepository = localDBTransactionRepository;

  @override
  Future<IncomeEntity> save(IncomeEntity entity) async {
    if (entity.description.trim().isEmpty) throw ValidationException(R.strings.uninformedDescription);
    if (entity.amount <= 0) throw ValidationException(R.strings.greaterThanZero);
    if (entity.idCategory == null) throw ValidationException(R.strings.uninformedCategory);
    if (entity.idAccount == null) throw ValidationException(R.strings.uninformedAccount);

    StatementEntity statement = StatementFactory.fromIncome(entity);

    if (!entity.isNew) {
      final StatementEntity? result = await _statementRepository.findByIdIncome(entity.id);

      if (result != null) statement = result..updateFromIncome(entity);
    }

    return await _localDBTransactionRepository.openTransaction<IncomeEntity>((txn) async {
      late final IncomeEntity entitySaved;

      await Future.wait([
        _repository.save(entity, txn: txn).then((value) => entitySaved = value),
        _statementRepository.save(statement, txn: txn),
      ]);

      return entitySaved;
    });
  }
}
