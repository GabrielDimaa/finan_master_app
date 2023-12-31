import 'package:finan_master_app/features/transactions/domain/entities/i_transaction_entity.dart';
import 'package:finan_master_app/features/transactions/helpers/factories/expense_factory.dart';
import 'package:finan_master_app/features/transactions/helpers/factories/income_factory.dart';
import 'package:finan_master_app/features/transactions/helpers/factories/transfer_factory.dart';
import 'package:finan_master_app/features/transactions/infra/models/expense_model.dart';
import 'package:finan_master_app/features/transactions/infra/models/i_transaction_model.dart';
import 'package:finan_master_app/features/transactions/infra/models/income_model.dart';
import 'package:finan_master_app/features/transactions/infra/models/transfer_model.dart';

abstract class FinancialOperationFactory {
  static ITransactionEntity toEntity(ITransactionModel model) {
    return switch (model) {
      ExpenseModel _ => ExpenseFactory.toEntity(model),
      IncomeModel _ => IncomeFactory.toEntity(model),
      TransferModel _ => TransferFactory.toEntity(model),
      _ => throw Exception('Invalid model type'),
    } as ITransactionEntity;
  }
}
