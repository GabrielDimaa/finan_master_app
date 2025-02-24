import 'package:collection/collection.dart';
import 'package:finan_master_app/features/account/infra/data_sources/i_account_local_data_source.dart';
import 'package:finan_master_app/features/account/infra/models/account_simple.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_with_bill_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_repository.dart';
import 'package:finan_master_app/features/credit_card/helpers/factories/credit_card_bill_factory.dart';
import 'package:finan_master_app/features/credit_card/helpers/factories/credit_card_factory.dart';
import 'package:finan_master_app/features/credit_card/infra/data_sources/i_credit_card_bill_local_data_source.dart';
import 'package:finan_master_app/features/credit_card/infra/data_sources/i_credit_card_local_data_source.dart';
import 'package:finan_master_app/features/credit_card/infra/models/credit_card_bill_model.dart';
import 'package:finan_master_app/features/credit_card/infra/models/credit_card_model.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';
import 'package:finan_master_app/shared/presentation/notifiers/event_notifier.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';

class CreditCardRepository implements ICreditCardRepository {
  final ICreditCardLocalDataSource _creditCardDataSource;
  final IAccountLocalDataSource _accountDataSource;
  final ICreditCardBillLocalDataSource _billDataSource;
  final EventNotifier _eventNotifier;

  CreditCardRepository({
    required ICreditCardLocalDataSource creditCardDataSource,
    required IAccountLocalDataSource accountDataSource,
    required ICreditCardBillLocalDataSource billDataSource,
    required EventNotifier eventNotifier,
  })  : _creditCardDataSource = creditCardDataSource,
        _accountDataSource = accountDataSource,
        _billDataSource = billDataSource,
        _eventNotifier = eventNotifier;

  @override
  Future<CreditCardEntity> save(CreditCardEntity entity, {ITransactionExecutor? txn}) async {
    final CreditCardModel creditCard = await _creditCardDataSource.upsert(CreditCardFactory.fromEntity(entity), txn: txn);

    _eventNotifier.notify(EventType.creditCard);

    return CreditCardFactory.toEntity(
      model: creditCard,
      accountModel: AccountSimpleModel(
        id: entity.idAccount!,
        description: entity.descriptionAccount,
        financialInstitution: entity.financialInstitutionAccount!,
      ),
    );
  }

  @override
  Future<void> delete(CreditCardEntity entity) async {
    await _creditCardDataSource.delete(CreditCardFactory.fromEntity(entity));
    _eventNotifier.notify(EventType.creditCard);
  }

  @override
  Future<List<CreditCardEntity>> findAll() async {
    final List<CreditCardModel> creditCards = await _creditCardDataSource.findAll();

    final Map<String, List<CreditCardModel>> group = groupBy(creditCards, (creditCard) => creditCard.idAccount);

    final List<AccountSimpleModel> accounts = await _accountDataSource.getAllSimplesByIds(group.keys.toList());

    return creditCards.map((e) => CreditCardFactory.toEntity(model: e, accountModel: accounts.firstWhere((a) => a.id == e.idAccount))).toList();
  }

  @override
  Future<CreditCardEntity?> findById(String id, {ITransactionExecutor? txn}) async {
    final CreditCardModel? model = await _creditCardDataSource.findById(id, txn: txn);

    return model != null
        ? CreditCardFactory.toEntity(
            model: model,
            accountModel: await _accountDataSource.getSimpleById(model.idAccount, txn: txn) ?? (throw Exception(R.strings.accountNotFound)),
          )
        : null;
  }

  @override
  Future<List<CreditCardWithBillEntity>> findCreditCardsWithBill() async {
    final List<CreditCardEntity> creditCards = await findAll();

    final List<CreditCardWithBillEntity> creditCardsWithBill = [];

    for (final creditCard in creditCards) {
      final CreditCardBillModel? bill = await _billDataSource.findOne(
        where: '${_billDataSource.tableName}.total_amount > ? AND ${_billDataSource.tableName}.id_credit_card = ?',
        whereArgs: [0, creditCard.id],
      );

      creditCardsWithBill.add(
        CreditCardWithBillEntity(
          creditCard: creditCard,
          bill: bill == null ? null : CreditCardBillFactory.toEntity(bill),
        ),
      );
    }

    return creditCardsWithBill;
  }
}
