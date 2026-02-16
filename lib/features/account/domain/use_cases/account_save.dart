import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/domain/repositories/i_account_repository.dart';
import 'package:finan_master_app/features/account/domain/use_cases/i_account_save.dart';
import 'package:finan_master_app/features/ad/domain/use_cases/i_ad_access.dart';
import 'package:finan_master_app/features/statement/domain/entities/statement_entity.dart';
import 'package:finan_master_app/features/statement/domain/repositories/i_statement_repository.dart';
import 'package:finan_master_app/shared/domain/repositories/i_local_db_transaction_repository.dart';
import 'package:finan_master_app/shared/exceptions/exceptions.dart';
import 'package:finan_master_app/shared/extensions/double_extension.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';
import 'package:uuid/uuid.dart';

class AccountSave implements IAccountSave {
  final IAccountRepository _repository;
  final IStatementRepository _statementRepository;
  final ILocalDBTransactionRepository _localDBTransactionRepository;
  final IAdAccess _adAccess;

  AccountSave({
    required IAccountRepository repository,
    required IStatementRepository statementRepository,
    required ILocalDBTransactionRepository localDBTransactionRepository,
    required IAdAccess adAccess,
  })  : _repository = repository,
        _statementRepository = statementRepository,
        _localDBTransactionRepository = localDBTransactionRepository,
        _adAccess = adAccess;

  @override
  Future<AccountEntity> save(AccountEntity entity) async {
    if (entity.description.trim().isEmpty) throw ValidationException(R.strings.uninformedDescription);
    if (entity.isNew && entity.initialAmount < 0) throw ValidationException(R.strings.greaterThanZero);
    if (entity.financialInstitution == null) return throw ValidationException(R.strings.uninformedFinancialInstitution);

    StatementEntity? statement;

    if (entity.idStatementInitialAmount != null) {
      statement = await _statementRepository.findById(entity.idStatementInitialAmount!);

      statement?.amount = entity.initialAmount;
    }

    if (entity.initialAmount > 0) {
      statement ??= StatementEntity(
        id: const Uuid().v1(),
        createdAt: null,
        deletedAt: null,
        amount: entity.initialAmount,
        date: DateTime.now(),
        idAccount: entity.id,
        idExpense: null,
        idIncome: null,
        idTransfer: null,
      );

      entity.idStatementInitialAmount = statement.id;
    }

    final result = await _localDBTransactionRepository.openTransaction<AccountEntity>((txn) async {
      late final AccountEntity entitySaved;

      await Future.wait([
        _repository.save(entity, txn: txn).then((value) => entitySaved = value),
        if (statement != null && entity.initialAmount > 0) _statementRepository.save(statement, txn: txn),
        if (statement != null && entity.initialAmount <= 0) _statementRepository.delete(statement, txn: txn),
      ]);

      return entitySaved;
    });

    _adAccess.consumeUse();

    return result;
  }

  @override
  Future<AccountEntity> changeInitialAmount({required AccountEntity entity, required double readjustmentValue}) async {
    if (readjustmentValue == 0) throw ValidationException(R.strings.greaterThanZero);

    entity.initialAmount = (entity.initialAmount + readjustmentValue).toRound(2);

    return await save(entity);
  }
}
