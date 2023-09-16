import 'package:finan_master_app/features/transactions/infra/models/transfer_model.dart';
import 'package:finan_master_app/shared/infra/data_sources/i_local_data_source.dart';

abstract interface class ITransferLocalDataSource implements ILocalDataSource<TransferModel> {
  Future<List<TransferModel>> findByPeriod(DateTime start, DateTime end);
}
