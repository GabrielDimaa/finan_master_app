import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';
import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/features/category/domain/use_cases/i_category_find.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_transaction_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_find.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_transaction_delete.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_transaction_save.dart';
import 'package:finan_master_app/features/credit_card/helpers/factories/credit_card_transaction_factory.dart';
import 'package:finan_master_app/features/transactions/domain/entities/transaction_by_text_entity.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_expense_find.dart';
import 'package:finan_master_app/shared/presentation/commands/command.dart';
import 'package:flutter/foundation.dart';

class CreditCardExpenseFormViewModel extends ChangeNotifier {
  final ICategoryFind _categoryFind;
  final ICreditCardFind _creditCardFind;

  late final Command1<List<TransactionByTextEntity>, String> findByText;
  late final Command1<void, CreditCardTransactionEntity> delete;
  late final Command1<CreditCardTransactionEntity, CreditCardTransactionEntity> save;
  late final Command1<void, CreditCardTransactionEntity?> load;

  CreditCardExpenseFormViewModel({
    required ICreditCardTransactionSave creditCardTransactionSave,
    required ICreditCardTransactionDelete creditCardTransactionDelete,
    required IExpenseFind expenseFind,
    required ICategoryFind categoryFind,
    required ICreditCardFind creditCardFind,
  })  : _categoryFind = categoryFind,
        _creditCardFind = creditCardFind {
    findByText = Command1(expenseFind.findByText);
    delete = Command1(creditCardTransactionDelete.delete);
    save = Command1(creditCardTransactionSave.save);
    load = Command1(_load);
  }

  bool get isLoading => save.running || delete.running || load.running;

  List<CategoryEntity> _categories = [];

  List<CategoryEntity> get categories => List.unmodifiable(_categories);

  void setCategories(List<CategoryEntity> categories) => _categories = categories;

  List<CreditCardEntity> _creditCards = [];

  List<CreditCardEntity> get creditCards => List.unmodifiable(_creditCards);

  void setCreditCards(List<CreditCardEntity> creditCards) => _creditCards = creditCards;

  CreditCardTransactionEntity _creditCardExpense = CreditCardTransactionFactory.newEntity();

  CreditCardTransactionEntity get creditCardExpense => _creditCardExpense;

  Future<void> _load(CreditCardTransactionEntity? initialValue) async {
    if (initialValue != null) _creditCardExpense = initialValue;

    await Future.wait([
      _categoryFind.findAll(type: CategoryTypeEnum.expense, deleted: true).then((value) => _categories = value),
      _creditCardFind.findAll().then((value) => _creditCards = value),
    ]);

    if (initialValue != null) {
      final CreditCardEntity? creditCard = _creditCards.where((creditCard) => creditCard.deletedAt == null).singleOrNull;
      if (creditCard != null) _creditCardExpense.idCreditCard = creditCard.id;
    }
  }

  void setCategory(String idCategory) {
    _creditCardExpense.idCategory = idCategory;
    notifyListeners();
  }

  void setCreditCard(String idCreditCard) {
    _creditCardExpense.idCreditCard = idCreditCard;
    notifyListeners();
  }

  void setDate(DateTime date) {
    _creditCardExpense.date = date;
    notifyListeners();
  }
}
