import 'package:finan_master_app/features/category/helpers/factories/category_factory.dart';
import 'package:finan_master_app/features/transactions/domain/entities/transaction_search_entity.dart';
import 'package:finan_master_app/features/transactions/infra/models/transaction_search_model.dart';

abstract class TransactionSearchFactory {
  static TransactionSearchEntity toEntity(TransactionSearchModel model) {
    return TransactionSearchEntity(
      id: model.id,
      description: model.description,
      amount: model.amount,
      date: model.date,
      paidOrReceived: model.paidOrReceived,
      category: CategoryFactory.toEntity(model.category),
      account: model.account != null
          ? AccountTransactionSearchEntity(
              id: model.account!.id,
              description: model.account!.description,
              financialInstitution: model.account!.financialInstitution,
            )
          : null,
      creditCard: model.creditCard != null
          ? CreditCardTransactionSearchEntity(
              id: model.creditCard!.id,
              description: model.creditCard!.description,
              account: AccountTransactionSearchEntity(
                id: model.creditCard!.account.id,
                description: model.creditCard!.account.description,
                financialInstitution: model.creditCard!.account.financialInstitution,
              ),
            )
          : null,
    );
  }
}
