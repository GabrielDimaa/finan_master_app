import 'package:collection/collection.dart';
import 'package:finan_master_app/features/account/infra/data_sources/i_account_local_data_source.dart';
import 'package:finan_master_app/features/account/infra/models/account_simple.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_repository.dart';
import 'package:finan_master_app/features/credit_card/helpers/factories/credit_card_factory.dart';
import 'package:finan_master_app/features/credit_card/infra/data_sources/i_credit_card_local_data_source.dart';
import 'package:finan_master_app/features/credit_card/infra/models/credit_card_model.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';

class CreditCardRepository implements ICreditCardRepository {
  final ICreditCardLocalDataSource _creditCardDataSource;
  final IAccountLocalDataSource _accountDataSource;

  CreditCardRepository({required ICreditCardLocalDataSource creditCardDataSource, required IAccountLocalDataSource accountDataSource})
      : _creditCardDataSource = creditCardDataSource,
        _accountDataSource = accountDataSource;

  @override
  Future<CreditCardEntity> save(CreditCardEntity entity, {ITransactionExecutor? txn}) async {
    final CreditCardModel creditCard = await _creditCardDataSource.upsert(CreditCardFactory.fromEntity(entity), txn: txn);

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
  Future<void> delete(CreditCardEntity entity) => _creditCardDataSource.delete(CreditCardFactory.fromEntity(entity));

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

    return model != null ? CreditCardFactory.toEntity(
      model: model,
      accountModel: await _accountDataSource.getSimpleById(model.idAccount, txn: txn) ?? (throw Exception(R.strings.accountNotFound)),
    ) : null;
  }
}
