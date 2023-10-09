import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_repository.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_save.dart';
import 'package:finan_master_app/shared/exceptions/exceptions.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';

class CreditCardSave implements ICreditCardSave {
  final ICreditCardRepository _repository;

  CreditCardSave({required ICreditCardRepository repository}) : _repository = repository;

  @override
  Future<CreditCardEntity> save(CreditCardEntity entity) async {
    if (entity.description.trim().isEmpty) throw ValidationException(R.strings.uninformedDescription);
    if (entity.amountLimit <= 0) throw ValidationException(R.strings.greaterThanZero);
    if (entity.invoiceClosingDay <= 0) throw ValidationException(R.strings.greaterThanZero);
    if (entity.invoiceDueDay <= 0) throw ValidationException(R.strings.greaterThanZero);
    if (entity.invoiceClosingDay > 31 || entity.invoiceDueDay > 31) throw ValidationException('${R.strings.lessThan} 31');
    if (entity.brand == null) return throw ValidationException(R.strings.uninformedCardBrand);
    if (entity.idAccount == null) return throw ValidationException(R.strings.uninformedAccount);

    return await _repository.save(entity);
  }
}
