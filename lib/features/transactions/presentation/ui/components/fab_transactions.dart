import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/income_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/transfer_entity.dart';
import 'package:finan_master_app/features/transactions/presentation/notifiers/transactions_notifier.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/expense_form_page.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/income_form_page.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/transfer_form_page.dart';
import 'package:finan_master_app/shared/classes/form_result_navigation.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/fab/expandable_fab.dart';
import 'package:finan_master_app/shared/presentation/ui/components/fab/expandable_fab_child.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FabTransactions extends StatefulWidget {
  final TransactionsNotifier notifier;

  const FabTransactions({Key? key, required this.notifier}) : super(key: key);

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
          onPressed: () {},
        ),
        ExpandableFabChild(
          icon: const Icon(Icons.move_up_outlined),
          label: label(text: strings.transfer),
          onPressed: goTransferFormPage,
        ),
      ],
    );
  }

  Future<void> goExpenseFormPage() async {
    final FormResultNavigation<ExpenseEntity>? result = await context.pushNamed(ExpenseFormPage.route);

    if (result != null) await widget.notifier.refreshTransactions();
  }

  Future<void> goIncomeFormPage() async {
    final FormResultNavigation<IncomeEntity>? result = await context.pushNamed(IncomeFormPage.route);

    if (result != null) await widget.notifier.refreshTransactions();
  }

  Future<void> goTransferFormPage() async {
    final FormResultNavigation<TransferEntity>? result = await context.pushNamed(TransferFormPage.route);

    if (result != null) await widget.notifier.refreshTransactions();
  }

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
