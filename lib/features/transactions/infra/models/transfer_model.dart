import 'package:finan_master_app/features/transactions/infra/models/i_financial_operation_model.dart';
import 'package:finan_master_app/features/transactions/infra/models/transaction_model.dart';
import 'package:finan_master_app/shared/infra/models/model.dart';

class TransferModel extends Model implements IFinancialOperationModel {
  TransactionModel transactionFrom;
  TransactionModel transactionTo;

  TransferModel({
    required super.id,
    required super.createdAt,
    required super.deletedAt,
    required this.transactionFrom,
    required this.transactionTo,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      ...baseMap(),
      'id_transaction_from': transactionFrom.id,
      'id_transaction_to': transactionTo.id,
    };
  }

  @override
  TransferModel clone() {
    return TransferModel(
      id: id,
      createdAt: createdAt,
      deletedAt: deletedAt,
      transactionFrom: transactionFrom.clone(),
      transactionTo: transactionTo.clone(),
    );
  }
}
