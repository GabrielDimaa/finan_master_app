import 'package:collection/collection.dart';
import 'package:finan_master_app/features/category/infra/data_sources/category_local_data_source.dart';
import 'package:finan_master_app/features/category/infra/data_sources/i_category_local_data_source.dart';
import 'package:finan_master_app/features/category/infra/models/category_model.dart';
import 'package:finan_master_app/features/reports/infra/data_sources/i_report_categories_data_source.dart';
import 'package:finan_master_app/features/reports/infra/models/report_category_model.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/expense_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/i_expense_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/i_income_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/i_transaction_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/income_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/transaction_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/models/expense_model.dart';
import 'package:finan_master_app/features/transactions/infra/models/income_model.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/database_local_exception.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/database_operation.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local.dart';
import 'package:finan_master_app/shared/infra/data_sources/local_data_source.dart';
import 'package:finan_master_app/shared/infra/models/model.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';

class ReportCategoriesDataSource implements IReportCategoriesDataSource {
  late final IDatabaseLocal _databaseLocal;
  late final ITransactionLocalDataSource _transactionDataSource;
  late final IIncomeLocalDataSource _incomeDataSource;
  late final IExpenseLocalDataSource _expenseDataSource;
  late final ICategoryLocalDataSource _categoryDataSource;

  ReportCategoriesDataSource({required IDatabaseLocal databaseLocal}) {
    _databaseLocal = databaseLocal;
    _transactionDataSource = TransactionLocalDataSource(databaseLocal: databaseLocal);
    _incomeDataSource = IncomeLocalDataSource(databaseLocal: databaseLocal, transactionDataSource: _transactionDataSource);
    _expenseDataSource = ExpenseLocalDataSource(databaseLocal: databaseLocal, transactionDataSource: _transactionDataSource);
    _categoryDataSource = CategoryLocalDataSource(databaseLocal: databaseLocal);
  }

  @override
  Future<List<ReportCategoryModel>> findIncomesByPeriod(DateTime? startDate, DateTime? endDate) async {
    try {
      final List<String> where = ['${_transactionDataSource.tableName}.${Model.deletedAtColumnName} IS NULL'];
      final List<dynamic> whereArgs = [];

      if (startDate != null && endDate != null && startDate.isAfter(endDate)) throw Exception(R.strings.errorStartDateAfterEndDate);

      if (startDate != null) {
        where.add('${_transactionDataSource.tableName}.date >= ?');
        whereArgs.add(startDate.toIso8601String());
      }

      if (endDate != null) {
        where.add('${_transactionDataSource.tableName}.date <= ?');
        whereArgs.add(endDate.toIso8601String());
      }

      final String sql = '''
        SELECT
          -- Income
          ${_incomeDataSource.tableName}.id AS ${_incomeDataSource.tableName}_id,
          ${_incomeDataSource.tableName}.created_at AS ${_incomeDataSource.tableName}_created_at,
          ${_incomeDataSource.tableName}.deleted_at AS ${_incomeDataSource.tableName}_deleted_at,
          ${_incomeDataSource.tableName}.description AS ${_incomeDataSource.tableName}_description,
          ${_incomeDataSource.tableName}.id_category AS ${_incomeDataSource.tableName}_id_category,
          ${_incomeDataSource.tableName}.id_transaction AS ${_incomeDataSource.tableName}_id_transaction,
          ${_incomeDataSource.tableName}.observation AS ${_incomeDataSource.tableName}_observation,
        
          -- Transaction
          ${_transactionDataSource.tableName}.id AS ${_transactionDataSource.tableName}_id,
          ${_transactionDataSource.tableName}.created_at AS ${_transactionDataSource.tableName}_created_at,
          ${_transactionDataSource.tableName}.deleted_at AS ${_transactionDataSource.tableName}_deleted_at,
          ${_transactionDataSource.tableName}.amount AS ${_transactionDataSource.tableName}_amount,
          ${_transactionDataSource.tableName}.type AS ${_transactionDataSource.tableName}_type,
          ${_transactionDataSource.tableName}.date AS ${_transactionDataSource.tableName}_date,
          ${_transactionDataSource.tableName}.id_account AS ${_transactionDataSource.tableName}_id_account,
          
          -- Category
          ${_categoryDataSource.tableName}.id AS ${_categoryDataSource.tableName}_id,
          ${_categoryDataSource.tableName}.created_at AS ${_categoryDataSource.tableName}_created_at,
          ${_categoryDataSource.tableName}.deleted_at AS ${_categoryDataSource.tableName}_deleted_at,
          ${_categoryDataSource.tableName}.description AS ${_categoryDataSource.tableName}_description,
          ${_categoryDataSource.tableName}.type AS ${_categoryDataSource.tableName}_type,
          ${_categoryDataSource.tableName}.color AS ${_categoryDataSource.tableName}_color,
          ${_categoryDataSource.tableName}.icon AS ${_categoryDataSource.tableName}_icon
        FROM ${_transactionDataSource.tableName}
        INNER JOIN ${_incomeDataSource.tableName}
          ON ${_incomeDataSource.tableName}.id_transaction = ${_transactionDataSource.tableName}.id
        INNER JOIN ${_categoryDataSource.tableName}
          ON ${_categoryDataSource.tableName}.id = ${_incomeDataSource.tableName}.id_category
        ${where.isNotEmpty ? 'WHERE ${where.join(' AND ')}' : ''}
        ORDER BY ${_categoryDataSource.tableName}.description, ${_transactionDataSource.tableName}.date, ${_incomeDataSource.tableName}.description;
      ''';

      final List<Map<String, dynamic>> results = await _databaseLocal.raw(sql, DatabaseOperation.select, whereArgs);

      final List<ReportCategoryModel> list = [];

      for (final result in results) {
        final IncomeModel income = _incomeDataSource.fromMap(result, prefix: '${_incomeDataSource.tableName}_');

        final ReportCategoryModel? reportCategory = list.firstWhereOrNull((e) => e.category.id == income.idCategory);

        if (reportCategory != null) {
          reportCategory.transactions.add(income);
        } else {
          final CategoryModel category = _categoryDataSource.fromMap(result, prefix: '${_categoryDataSource.tableName}_');
          list.add(ReportCategoryModel(category: category, transactions: [income]));
        }
      }

      return list;
    } on DatabaseLocalException catch (e, stackTrace) {
      throw LocalDataSourceUtils.throwable(e, stackTrace);
    }
  }

  @override
  Future<List<ReportCategoryModel>> findExpensesByPeriod(DateTime? startDate, DateTime? endDate) async {
    try {
      final List<String> where = ['${_transactionDataSource.tableName}.${Model.deletedAtColumnName} IS NULL'];
      final List<dynamic> whereArgs = [];

      if (startDate != null && endDate != null && startDate.isAfter(endDate)) throw Exception(R.strings.errorStartDateAfterEndDate);

      if (startDate != null) {
        where.add('${_transactionDataSource.tableName}.date >= ?');
        whereArgs.add(startDate.toIso8601String());
      }

      if (endDate != null) {
        where.add('${_transactionDataSource.tableName}.date <= ?');
        whereArgs.add(endDate.toIso8601String());
      }

      final String sql = '''
        SELECT
          -- Expense
          ${_expenseDataSource.tableName}.id AS ${_expenseDataSource.tableName}_id,
          ${_expenseDataSource.tableName}.created_at AS ${_expenseDataSource.tableName}_created_at,
          ${_expenseDataSource.tableName}.deleted_at AS ${_expenseDataSource.tableName}_deleted_at,
          ${_expenseDataSource.tableName}.description AS ${_expenseDataSource.tableName}_description,
          ${_expenseDataSource.tableName}.id_category AS ${_expenseDataSource.tableName}_id_category,
          ${_expenseDataSource.tableName}.id_credit_card_transaction AS ${_expenseDataSource.tableName}_id_credit_card_transaction,
          ${_expenseDataSource.tableName}.id_transaction AS ${_expenseDataSource.tableName}_id_transaction,
          ${_expenseDataSource.tableName}.observation AS ${_expenseDataSource.tableName}_observation,
        
          -- Transaction
          ${_transactionDataSource.tableName}.id AS ${_transactionDataSource.tableName}_id,
          ${_transactionDataSource.tableName}.created_at AS ${_transactionDataSource.tableName}_created_at,
          ${_transactionDataSource.tableName}.deleted_at AS ${_transactionDataSource.tableName}_deleted_at,
          ${_transactionDataSource.tableName}.amount AS ${_transactionDataSource.tableName}_amount,
          ${_transactionDataSource.tableName}.type AS ${_transactionDataSource.tableName}_type,
          ${_transactionDataSource.tableName}.date AS ${_transactionDataSource.tableName}_date,
          ${_transactionDataSource.tableName}.id_account AS ${_transactionDataSource.tableName}_id_account,
          
          -- Category
          ${_categoryDataSource.tableName}.id AS ${_categoryDataSource.tableName}_id,
          ${_categoryDataSource.tableName}.created_at AS ${_categoryDataSource.tableName}_created_at,
          ${_categoryDataSource.tableName}.deleted_at AS ${_categoryDataSource.tableName}_deleted_at,
          ${_categoryDataSource.tableName}.description AS ${_categoryDataSource.tableName}_description,
          ${_categoryDataSource.tableName}.type AS ${_categoryDataSource.tableName}_type,
          ${_categoryDataSource.tableName}.color AS ${_categoryDataSource.tableName}_color,
          ${_categoryDataSource.tableName}.icon AS ${_categoryDataSource.tableName}_icon
        FROM ${_transactionDataSource.tableName}
        INNER JOIN ${_expenseDataSource.tableName}
          ON ${_expenseDataSource.tableName}.id_transaction = ${_transactionDataSource.tableName}.id
        INNER JOIN ${_categoryDataSource.tableName}
          ON ${_categoryDataSource.tableName}.id = ${_expenseDataSource.tableName}.id_category
        ${where.isNotEmpty ? 'WHERE ${where.join(' AND ')}' : ''}
        ORDER BY ${_categoryDataSource.tableName}.description, ${_transactionDataSource.tableName}.date, ${_expenseDataSource.tableName}.description;
      ''';

      final List<Map<String, dynamic>> results = await _databaseLocal.raw(sql, DatabaseOperation.select, whereArgs);

      final List<ReportCategoryModel> list = [];

      for (final result in results) {
        final ExpenseModel expense = _expenseDataSource.fromMap(result, prefix: '${_expenseDataSource.tableName}_');

        final ReportCategoryModel? reportCategory = list.firstWhereOrNull((e) => e.category.id == expense.idCategory);

        if (reportCategory != null) {
          reportCategory.transactions.add(expense);
        } else {
          final CategoryModel category = _categoryDataSource.fromMap(result, prefix: '${_categoryDataSource.tableName}_');
          list.add(ReportCategoryModel(category: category, transactions: [expense]));
        }
      }

      return list;
    } on DatabaseLocalException catch (e, stackTrace) {
      throw LocalDataSourceUtils.throwable(e, stackTrace);
    }
  }
}
