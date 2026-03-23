import 'package:collection/collection.dart';
import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/domain/repositories/i_account_repository.dart';
import 'package:finan_master_app/features/account/helpers/account_factory.dart';
import 'package:finan_master_app/features/account/infra/data_sources/i_account_local_data_source.dart';
import 'package:finan_master_app/features/account/infra/models/account_model.dart';
import 'package:finan_master_app/features/credit_card/infra/data_sources/i_credit_card_local_data_source.dart';
import 'package:finan_master_app/shared/extensions/double_extension.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';
import 'package:finan_master_app/shared/presentation/notifiers/event_notifier.dart';

class AccountRepository implements IAccountRepository {
  final IAccountLocalDataSource _dataSource;
  final EventNotifier _eventNotifier;

  AccountRepository({
    required IAccountLocalDataSource dataSource,
    required ICreditCardLocalDataSource creditCardLocalDataSource,
    required EventNotifier eventNotifier,
  })  : _dataSource = dataSource,
        _eventNotifier = eventNotifier;

  @override
  Future<List<AccountEntity>> findAll({bool deleted = false}) async {
    final List<AccountModel> accounts = await _dataSource.findAll(deleted: deleted);
    return accounts.map((account) => AccountFactory.toEntity(account)).toList();
  }

  @override
  Future<AccountEntity?> findById(String id, {bool deleted = false}) async {
    final AccountModel? account = await _dataSource.findById(id, deleted: deleted);
    return account != null ? AccountFactory.toEntity(account) : null;
  }

  @override
  Future<AccountEntity> save(AccountEntity entity, {ITransactionExecutor? txn}) async {
    await _dataSource.upsert(AccountFactory.fromEntity(entity), txn: txn);

    _eventNotifier.notify(EventType.account);

    //Busca novamente para trazer os dados do saldo da conta atualizados.
    final AccountModel model = (await _dataSource.findById(entity.id, txn: txn))!;

    return AccountFactory.toEntity(model);
  }

  @override
  Future<void> delete(AccountEntity entity) async {
    await _dataSource.delete(AccountFactory.fromEntity(entity));

    _eventNotifier.notify(EventType.account);
  }

  @override
  Future<double> findBalanceUntilDate(DateTime date) => _dataSource.findBalanceUntilDate(date);

  @override
  Future<double> findAccountsBalance() async {
    final List<AccountModel> models = await _dataSource.findAll(where: 'include_total_balance = ?', whereArgs: [1]);

    final List<AccountEntity> entities = models.map((account) => AccountFactory.toEntity(account)).toList();

    return entities.map((account) => account.includeTotalBalance ? account.transactionsAmount : 0).sum.toDouble().toRound(2);
  }
}
