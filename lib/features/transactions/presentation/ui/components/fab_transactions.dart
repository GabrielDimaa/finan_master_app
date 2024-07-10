import 'package:finan_master_app/features/credit_card/presentation/ui/credit_card_expense_form_page.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/expense_form_page.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/income_form_page.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/transfer_form_page.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/fab/expandable_fab.dart';
import 'package:finan_master_app/shared/presentation/ui/components/fab/expandable_fab_child.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FabTransactions extends StatefulWidget {
  const FabTransactions({super.key});

  @override
  State<FabTransactions> createState() => _FabTransactionsState();
}

class _FabTransactionsState extends State<FabTransactions> with ThemeContext {
  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
      iconOpen: const Icon(Icons.add),
      children: [
        ExpandableFabChild(
          icon: const Icon(Icons.arrow_downward_outlined),
          label: label(text: strings.expense),
          onPressed: goExpenseFormPage,
        ),
        ExpandableFabChild(
          icon: const Icon(Icons.arrow_upward_outlined),
          label: label(text: strings.income),
          onPressed: goIncomeFormPage,
        ),
        ExpandableFabChild(
          icon: const Icon(Icons.credit_card_outlined),
          label: label(text: strings.cardExpense),
          onPressed: goCreditCardExpenseFormPage,
        ),
        ExpandableFabChild(
          icon: const Icon(Icons.move_up_outlined),
          label: label(text: strings.transfer),
          onPressed: goTransferFormPage,
        ),
      ],
    );
  }

  Future<void> goExpenseFormPage() => context.pushNamed(ExpenseFormPage.route);

  Future<void> goIncomeFormPage() => context.pushNamed(IncomeFormPage.route);

  Future<void> goTransferFormPage() => context.pushNamed(TransferFormPage.route);

  Future<void> goCreditCardExpenseFormPage() => context.pushNamed(CreditCardExpensePage.route);

  Widget label({required String text}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: textTheme.labelMedium?.copyWith(color: colorScheme.onPrimaryContainer),
      ),
    );
  }
}
