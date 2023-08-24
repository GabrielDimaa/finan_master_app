import 'package:finan_master_app/features/transactions/domain/entities/transfer_entity.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_transfer_repository.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_transfer_save.dart';
import 'package:finan_master_app/shared/classes/result.dart';
import 'package:finan_master_app/shared/exceptions/exceptions.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';

class TransferSave implements ITransferSave {
  final ITransferRepository _repository;

  TransferSave({required ITransferRepository repository}) : _repository = repository;

  @override
  Future<Result<TransferEntity, BaseException>> save(TransferEntity entity) async {
    if (entity.value <= 0) return Result.failure(ValidationException(R.strings.greaterThanZero, null));
    if (entity.accountFrom == null) return Result.failure(ValidationException(R.strings.uninformedAccount, null));
    if (entity.accountTo == null) return Result.failure(ValidationException(R.strings.uninformedAccount, null));

    // TODO: implement save
    throw UnimplementedError();
  }
}
