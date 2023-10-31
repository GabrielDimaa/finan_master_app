import 'package:finan_master_app/features/transactions/domain/entities/i_transaction_entity.dart';

abstract interface class ITransactionDelete {
  Future<void> deleteTransactions(List<ITransactionEntity> transactions);
}
