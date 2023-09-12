import 'package:finan_master_app/features/transactions/domain/entities/transfer_entity.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_transfer_repository.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_transfer_save.dart';
import 'package:finan_master_app/shared/exceptions/exceptions.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';

class TransferSave implements ITransferSave {
  final ITransferRepository _repository;

  TransferSave({required ITransferRepository repository}) : _repository = repository;

  @override
  Future<TransferEntity> save(TransferEntity entity) async {
    if (entity.transactionFrom.idAccount == null) throw ValidationException(R.strings.uninformedAccount);
    if (entity.transactionTo.idAccount == null) throw ValidationException(R.strings.uninformedAccount);
    if (entity.transactionFrom.amount >= 0) throw ValidationException(R.strings.lessThanZero);
    if (entity.transactionTo.amount <= 0) throw ValidationException(R.strings.greaterThanZero);
    if (entity.transactionTo.amount.abs() != entity.transactionFrom.amount.abs()) throw ValidationException(R.strings.transferAmountDivergent);
    if (entity.transactionFrom.idAccount == entity.transactionTo.idAccount) throw ValidationException(R.strings.sourceAccountAndDestinationEquals);

    return await _repository.save(entity);
  }
}
