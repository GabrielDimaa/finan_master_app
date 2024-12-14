import 'package:finan_master_app/features/transactions/infra/models/income_model.dart';
import 'package:finan_master_app/features/transactions/infra/models/transaction_by_text_model.dart';
import 'package:finan_master_app/shared/infra/data_sources/i_local_data_source.dart';

abstract interface class IIncomeLocalDataSource implements ILocalDataSource<IncomeModel> {
  Future<List<TransactionByTextModel>> findByText(String text);
}
