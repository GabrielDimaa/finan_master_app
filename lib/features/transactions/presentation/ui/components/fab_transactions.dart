import 'package:finan_master_app/features/transactions/presentation/ui/expense_form_page.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/income_form_page.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/transfer_form_page.dart';
import 'package:finan_master_app/shared/presentation/ui/components/fab/expandable_fab.dart';
import 'package:finan_master_app/shared/presentation/ui/components/fab/expandable_fab_child.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FabTransactions extends StatefulWidget {
  const FabTransactions({Key? key}) : super(key: key);

  @override
  State<FabTransactions> createState() => _FabTransactionsState();
}

class _FabTransactionsState extends State<FabTransactions> {
  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
      iconOpen: const Icon(Icons.add),
      children: [
        ExpandableFabChild(
          icon: const Icon(Icons.arrow_downward_outlined),
          onPressed: goIncomeFormPage,
        ),
        ExpandableFabChild(
          icon: const Icon(Icons.arrow_upward_outlined),
          onPressed: goExpenseFormPage,
        ),
        ExpandableFabChild(
          icon: const Icon(Icons.credit_card_outlined),
          onPressed: () {},
        ),
        ExpandableFabChild(
          icon: const Icon(Icons.move_up_outlined),
          onPressed: goTransferFormPage,
        ),
      ],
    );
  }

  Future<void> goExpenseFormPage() async {
    await context.pushNamed(ExpenseFormPage.route);
  }

  Future<void> goIncomeFormPage() async {
    await context.pushNamed(IncomeFormPage.route);
  }

  Future<void> goTransferFormPage() async {
    await context.pushNamed(TransferFormPage.route);
  }
}
