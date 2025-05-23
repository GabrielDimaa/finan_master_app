import 'package:collection/collection.dart';
import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/features/category/helpers/factories/category_factory.dart';
import 'package:finan_master_app/features/category/infra/data_sources/i_category_local_data_source.dart';
import 'package:finan_master_app/features/category/infra/models/category_model.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_transaction_entity.dart';
import 'package:finan_master_app/features/credit_card/helpers/factories/credit_card_transaction_factory.dart';
import 'package:finan_master_app/features/credit_card/infra/data_sources/i_credit_card_transaction_local_data_source.dart';
import 'package:finan_master_app/features/credit_card/infra/models/credit_card_transaction_model.dart';
import 'package:finan_master_app/features/reports/domain/entities/report_category_entity.dart';
import 'package:finan_master_app/features/reports/domain/repositories/i_report_categories_repository.dart';
import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/i_transaction_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/income_entity.dart';
import 'package:finan_master_app/features/transactions/helpers/factories/expense_factory.dart';
import 'package:finan_master_app/features/transactions/helpers/factories/income_factory.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/i_expense_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/i_income_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/models/expense_model.dart';
import 'package:finan_master_app/features/transactions/infra/models/income_model.dart';

class ReportCategoriesRepository implements IReportCategoriesRepository {
  final IExpenseLocalDataSource _expenseLocalDataSource;
  final IIncomeLocalDataSource _incomeLocalDataSource;
  final ICreditCardTransactionLocalDataSource _creditCardTransactionLocalDataSource;
  final ICategoryLocalDataSource _categoriesLocalDataSource;

  ReportCategoriesRepository({
    required IExpenseLocalDataSource expenseLocalDataSource,
    required IIncomeLocalDataSource incomeLocalDataSource,
    required ICreditCardTransactionLocalDataSource creditCardTransactionLocalDataSource,
    required ICategoryLocalDataSource categoriesLocalDataSource,
  })  : _expenseLocalDataSource = expenseLocalDataSource,
        _incomeLocalDataSource = incomeLocalDataSource,
        _creditCardTransactionLocalDataSource = creditCardTransactionLocalDataSource,
        _categoriesLocalDataSource = categoriesLocalDataSource;

  @override
  Future<List<ReportCategoryEntity>> findByPeriod({required DateTime? startDate, required DateTime? endDate, required CategoryTypeEnum type}) async {
    final List<String> where = [];
    final List<dynamic> whereArgs = [];

    if (startDate != null) {
      where.add('date >= ?');
      whereArgs.add(startDate.toIso8601String());
    }

    if (endDate != null) {
      where.add('date <= ?');
      whereArgs.add(endDate.toIso8601String());
    }

    final List<ITransactionEntity> transactions = [];

    if (type == CategoryTypeEnum.expense) {
      final List<ExpenseModel> expenses = await _expenseLocalDataSource.findAll(where: [...where, 'paid = ?', 'id_credit_card_transaction IS NULL'].join(' AND '), whereArgs: [...whereArgs, 1]);
      final List<CreditCardTransactionModel> creditCardTransactions = await _creditCardTransactionLocalDataSource.findByPeriod(startDate: startDate, endDate: endDate, onlyPaid: true, ignoreBillPayment: true);

      transactions.addAll([
        ...expenses.map((e) => ExpenseFactory.toEntity(e)),
        ...creditCardTransactions.map((e) => CreditCardTransactionFactory.toEntity(e)..amount = -e.amount.abs()),
      ]);

      transactions.sortBy((e) => e.date);
    } else {
      final List<IncomeModel> incomes = await _incomeLocalDataSource.findAll(where: [...where, 'received = ?'].join(' AND '), whereArgs: [...whereArgs, 1]);

      transactions.addAll(incomes.map((e) => IncomeFactory.toEntity(e)));
    }

    final List<CategoryModel> categories = await _categoriesLocalDataSource.findAll(
      where: 'id IN (${transactions.map((_) => '?').join(', ')})',
      whereArgs: transactions.map((e) => e is ExpenseEntity ? e.idCategory : (e is CreditCardTransactionEntity ? e.idCategory : (e as IncomeEntity).idCategory)).toList(),
      deleted: true,
    );

    final List<ReportCategoryEntity> result = [];

    final Map<String, List<ITransactionEntity>> group = groupBy(transactions, (e) => e is ExpenseEntity ? e.idCategory! : (e is CreditCardTransactionEntity ? e.idCategory! : (e as IncomeEntity).idCategory!));

    group.forEach((key, value) {
      result.add(ReportCategoryEntity(category: CategoryFactory.toEntity(categories.firstWhere((e) => e.id == key)), transactions: value));
    });

    return result.sortedBy((e) => e.category.description);
  }
}
