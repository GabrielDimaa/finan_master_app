import 'package:finan_master_app/features/account/domain/use_cases/i_account_find.dart';
import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';
import 'package:finan_master_app/features/category/domain/use_cases/i_category_find.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_transaction_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_find.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_transaction_delete.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_transaction_find.dart';
import 'package:finan_master_app/shared/presentation/commands/command.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';
import 'package:flutter/foundation.dart';

class CreditCardExpenseDetailsViewModel extends ChangeNotifier {
  final ICreditCardTransactionFind _creditCardExpenseFind;
  final ICategoryFind _categoryFind;
  final ICreditCardFind _creditCardFind;

  late final Command1<void, String> load;
  late final Command1<void, bool> savePaid;
  late final Command1<void, CreditCardTransactionEntity> delete;

  CreditCardExpenseDetailsViewModel({
    required ICreditCardTransactionFind creditCardExpenseFind,
    required ICreditCardTransactionDelete creditCardExpenseDelete,
    required ICategoryFind categoryFind,
    required ICreditCardFind creditCardFind,
    required IAccountFind accountFind,
  })  : _creditCardExpenseFind = creditCardExpenseFind,
        _categoryFind = categoryFind,
        _creditCardFind = creditCardFind {
    load = Command1(_load);
    delete = Command1(creditCardExpenseDelete.delete);
  }

  late CreditCardTransactionEntity _creditCardExpense;

  CreditCardTransactionEntity get creditCardExpense => _creditCardExpense;

  late CategoryEntity _category;

  CategoryEntity get category => _category;

  late CreditCardEntity _creditCardCard;

  CreditCardEntity get creditCardCard => _creditCardCard;

  Future<void> _load(String idCreditCardExpense) async {
    _creditCardExpense = await _creditCardExpenseFind.findById(idCreditCardExpense) ?? (throw Exception(R.strings.transactionNotFound));

    await Future.wait([
      _categoryFind.findById(_creditCardExpense.idCategory!, deleted: true).then((value) => _category = value ?? (throw Exception(R.strings.categoryNotFound))),
      _creditCardFind.findById(_creditCardExpense.idCreditCard!, deleted: true).then((value) => _creditCardCard = value ?? (throw Exception(R.strings.creditCardNotFound))),
    ]);
  }
}
