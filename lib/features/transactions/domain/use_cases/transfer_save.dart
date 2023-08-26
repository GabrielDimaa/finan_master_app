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
    if (entity.value <= 0) throw ValidationException(R.strings.greaterThanZero);
    if (entity.accountFrom == null) throw ValidationException(R.strings.uninformedAccount);
    if (entity.accountTo == null) throw ValidationException(R.strings.uninformedAccount);

    // TODO: implement save
    throw UnimplementedError();
  }
}
