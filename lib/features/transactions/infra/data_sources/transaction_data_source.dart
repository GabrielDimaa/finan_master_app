import 'package:finan_master_app/features/account/domain/enums/financial_institution_enum.dart';
import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/features/category/infra/models/category_model.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/i_transaction_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/models/transaction_search_model.dart';
import 'package:finan_master_app/shared/infra/data_sources/constants/tables_names_constant.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/database_local_exception.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/database_operation.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local.dart';
import 'package:finan_master_app/shared/infra/data_sources/local_data_source.dart';
import 'package:finan_master_app/shared/infra/models/model.dart';

class TransactionLocalDataSource implements ITransactionLocalDataSource {
  final IDatabaseLocal databaseLocal;

  TransactionLocalDataSource({required this.databaseLocal});

  @override
  Future<List<TransactionSearchModel>> search({required String text, required int limit, required int offset}) async {
    try {
      const String sql = '''
        SELECT
          id_transaction,
          description_transaction,
          amount_transaction,
          date_transaction,
          paid_or_received_transaction,
      
          id_category,
          created_at_category,
          deleted_at_category,
          description_category,
          type_category,
          color_category,
          icon_category,
      
          id_account,
          description_account,
          financial_institution_account,
          
          id_credit_card,
          description_credit_card
        FROM (
          SELECT
            $expensesTableName.${Model.idColumnName} AS id_transaction,
            $expensesTableName.description AS description_transaction,
            $expensesTableName.amount AS amount_transaction,
            $expensesTableName.date AS date_transaction,
            $expensesTableName.paid AS paid_or_received_transaction,
    
            $categoriesTableName.${Model.idColumnName} AS id_category,
            $categoriesTableName.${Model.createdAtColumnName} AS created_at_category,
            $categoriesTableName.${Model.deletedAtColumnName} AS deleted_at_category,
            $categoriesTableName.description AS description_category,
            $categoriesTableName.type AS type_category,
            $categoriesTableName.color AS color_category,
            $categoriesTableName.icon AS icon_category,
    
            $accountsTableName.${Model.idColumnName} AS id_account,
            $accountsTableName.description AS description_account,
            $accountsTableName.financial_institution AS financial_institution_account,
            
            NULL AS id_credit_card,
            NULL AS description_credit_card
          FROM $expensesTableName
          INNER JOIN $accountsTableName ON $accountsTableName.${Model.idColumnName} = $expensesTableName.id_account
          INNER JOIN $categoriesTableName ON $categoriesTableName.${Model.idColumnName} = $expensesTableName.id_category
          WHERE
            LOWER($expensesTableName.description) LIKE LOWER(?) AND
            $expensesTableName.${Model.deletedAtColumnName} IS NULL
        
          UNION
        
          SELECT
            $incomesTableName.${Model.idColumnName} AS id_transaction,
            $incomesTableName.description AS description_transaction,
            $incomesTableName.amount AS amount_transaction,
            $incomesTableName.date AS date_transaction,
            $incomesTableName.received AS paid_or_received_transaction,
    
            $categoriesTableName.${Model.idColumnName} AS id_category,
            $categoriesTableName.${Model.createdAtColumnName} AS created_at_category,
            $categoriesTableName.${Model.deletedAtColumnName} AS deleted_at_category,
            $categoriesTableName.description AS description_category,
            $categoriesTableName.type AS type_category,
            $categoriesTableName.color AS color_category,
            $categoriesTableName.icon AS icon_category,
    
            $accountsTableName.${Model.idColumnName} AS id_account,
            $accountsTableName.description AS description_account,
            $accountsTableName.financial_institution AS financial_institution_account,
            
            NULL AS id_credit_card,
            NULL AS description_credit_card
          FROM $incomesTableName
          INNER JOIN $accountsTableName ON $accountsTableName.${Model.idColumnName} = $incomesTableName.id_account
          INNER JOIN $categoriesTableName ON $categoriesTableName.${Model.idColumnName} = $incomesTableName.id_category
          WHERE
            LOWER($incomesTableName.description) LIKE LOWER(?) AND
            $incomesTableName.${Model.deletedAtColumnName} IS NULL
        
          UNION
      
          SELECT
            $creditCardTransactionsTableName.${Model.idColumnName} AS id_transaction,
            $creditCardTransactionsTableName.description AS description_transaction,
            $creditCardTransactionsTableName.amount * (-1) AS amount_transaction,
            $creditCardTransactionsTableName.date AS date_transaction,
            NULL AS paid_or_received_transaction,
    
            $categoriesTableName.${Model.idColumnName} AS id_category,
            $categoriesTableName.${Model.createdAtColumnName} AS created_at_category,
            $categoriesTableName.${Model.deletedAtColumnName} AS deleted_at_category,
            $categoriesTableName.description AS description_category,
            $categoriesTableName.type AS type_category,
            $categoriesTableName.color AS color_category,
            $categoriesTableName.icon AS icon_category,
    
            $accountsTableName.${Model.idColumnName} AS id_account,
            $accountsTableName.description AS description_account,
            $accountsTableName.financial_institution AS financial_institution_account,
            
            $creditCardsTableName.${Model.idColumnName} AS id_credit_card,
            $creditCardsTableName.description AS description_credit_card
          FROM $creditCardTransactionsTableName
          INNER JOIN $categoriesTableName ON $categoriesTableName.${Model.idColumnName} = $creditCardTransactionsTableName.id_category
          INNER JOIN $creditCardsTableName ON $creditCardsTableName.${Model.idColumnName} = $creditCardTransactionsTableName.id_credit_card
          INNER JOIN $accountsTableName ON $accountsTableName.${Model.idColumnName} = $creditCardsTableName.id_account
          WHERE
            LOWER($creditCardTransactionsTableName.description) LIKE LOWER(?) AND
            $creditCardTransactionsTableName.${Model.deletedAtColumnName} IS NULL
        )
        ORDER BY
          date_transaction DESC,
          CASE
            WHEN LOWER(description_transaction) LIKE LOWER(?) THEN 1
            WHEN LOWER(description_transaction) LIKE LOWER(?) THEN 2
            ELSE 3
          END,
          description_transaction
        LIMIT ?
        OFFSET ?;
      ''';

      final List<Map<String, dynamic>> results = await databaseLocal.raw(sql, DatabaseOperation.select, ['%$text%', '%$text%', '%$text%', text, '$text%', limit, offset]);

      return results.map((e) {
        final isCreditCard = e['id_credit_card'] != null;
        final account = AccountTransactionSearchModel(
          id: e['id_account'],
          description: e['description_account'],
          financialInstitution: FinancialInstitutionEnum.getByValue(e['financial_institution_account'])!,
        );

        return TransactionSearchModel(
          id: e['id_transaction'],
          description: e['description_transaction'],
          amount: e['amount_transaction'],
          date: DateTime.tryParse(e['date_transaction'].toString())!.toLocal(),
          paidOrReceived: e['paid_or_received_transaction'] == 1,
          category: CategoryModel(
            id: e['id_category'],
            createdAt: DateTime.tryParse(e['created_at_category'].toString())!.toLocal(),
            deletedAt: DateTime.tryParse(e['deleted_at_category'].toString())?.toLocal(),
            description: e['description_category'],
            type: CategoryTypeEnum.getByValue(e['type_category'])!,
            color: e['color_category'],
            icon: e['icon_category'],
          ),
          account: isCreditCard ? null : account,
          creditCard: isCreditCard
              ? CreditCardTransactionSearchModel(
                  id: e['id_credit_card'],
                  description: e['description_credit_card'],
                  account: account,
                )
              : null,
        );
      }).toList();
    } on DatabaseLocalException catch (e, stackTrace) {
      throw LocalDataSourceUtils.throwable(e, stackTrace);
    }
  }
}
