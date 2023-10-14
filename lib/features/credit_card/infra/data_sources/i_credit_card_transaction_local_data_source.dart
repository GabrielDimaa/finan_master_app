import 'package:finan_master_app/features/credit_card/infra/models/credit_card_transaction_model.dart';
import 'package:finan_master_app/shared/infra/data_sources/i_local_data_source.dart';

abstract interface class ICreditCardTransactionLocalDataSource implements ILocalDataSource<CreditCardTransactionModel> {}
