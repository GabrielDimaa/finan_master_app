import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/domain/use_cases/i_account_find.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/enums/brand_card_enum.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_delete.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_save.dart';
import 'package:finan_master_app/features/credit_card/helpers/factories/credit_card_factory.dart';
import 'package:finan_master_app/shared/presentation/commands/command.dart';
import 'package:flutter/foundation.dart';

class CreditCardFormViewModel extends ChangeNotifier {
  final IAccountFind _accountFind;

  late final Command1<void, CreditCardEntity?> load;
  late final Command1<CreditCardEntity, CreditCardEntity> save;
  late final Command1<void, CreditCardEntity> delete;

  CreditCardFormViewModel({
    required IAccountFind accountFind,
    required ICreditCardSave creditCardSave,
    required ICreditCardDelete creditCardDelete,
  }) : _accountFind = accountFind {
    load = Command1(_load);
    save = Command1(creditCardSave.save);
    delete = Command1(creditCardDelete.delete);
  }

  bool get isLoading => load.running || save.running || delete.running;

  CreditCardEntity _creditCard = CreditCardFactory.newEntity();

  CreditCardEntity get creditCard => _creditCard;

  List<AccountEntity> _accounts = [];

  List<AccountEntity> get accounts => List.unmodifiable(_accounts);

  setAccounts(List<AccountEntity> value) => _accounts = value;

  Future<void> _load(CreditCardEntity? initialValue) async {
    if (initialValue != null) _creditCard = initialValue;

    _accounts = await _accountFind.findAll();
  }

  void setAccount(AccountEntity account) {
    _creditCard.idAccount = account.id;
    _creditCard.descriptionAccount = account.description;
    _creditCard.financialInstitutionAccount = account.financialInstitution;

    notifyListeners();
  }

  void setCardBrand(CardBrandEnum? cardBrand) async {
    _creditCard.brand = cardBrand;

    notifyListeners();
  }
}
