import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/domain/repositories/i_account_repository.dart';
import 'package:finan_master_app/features/account/domain/use_cases/i_account_delete.dart';
import 'package:finan_master_app/features/ad/domain/use_cases/i_ad_access.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_find.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';

class AccountDelete implements IAccountDelete {
  final IAccountRepository _repository;
  final ICreditCardFind _creditCardFind;
  final IAdAccess _adAccess;

  AccountDelete({
    required IAccountRepository repository,
    required ICreditCardFind creditCardFind,
    required IAdAccess adAccess,
  })  : _repository = repository,
        _creditCardFind = creditCardFind,
        _adAccess = adAccess;

  @override
  Future<void> delete(AccountEntity entity) async {
    final CreditCardEntity? creditCard = await _creditCardFind.findByIdAccount(entity.id);

    if (creditCard != null) throw Exception(R.strings.accountUsedCreditCard);
    if (entity.transactionsAmount != 0) throw Exception(R.strings.accountDeletionBlockedByBalance);

    await _repository.delete(entity).then((_) => _adAccess.consumeUse());
  }
}
