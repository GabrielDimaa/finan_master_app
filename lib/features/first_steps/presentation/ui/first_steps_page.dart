import 'package:finan_master_app/di/dependency_injection.dart';
import 'package:finan_master_app/features/account/presentation/ui/account_form_page.dart';
import 'package:finan_master_app/features/credit_card/presentation/ui/credit_card_form_page.dart';
import 'package:finan_master_app/features/first_steps/presentation/notifiers/first_steps_notifier.dart';
import 'package:finan_master_app/features/home/presentation/ui/home_page.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/expense_form_page.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/income_form_page.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FirstStepsPage extends StatefulWidget {
  static const String route = 'first-steps';

  final bool firstShowing;

  const FirstStepsPage({super.key, required this.firstShowing});

  @override
  State<FirstStepsPage> createState() => _FirstStepsPageState();
}

class _FirstStepsPageState extends State<FirstStepsPage> with ThemeContext {
  final FirstStepsNotifier notifier = DI.get<FirstStepsNotifier>();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: (_, __, ___) {
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Spacing.y(4),
                            Icon(Icons.verified_outlined, size: 65, color: colorScheme.primary),
                            const Spacing.y(2),
                            Text(strings.firstSteps, style: textTheme.headlineMedium),
                            const Spacing.y(),
                            Text(strings.firstStepsExplication, style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant)),
                            const Spacing.y(2),
                            ...ListTile.divideTiles(
                              context: context,
                              tiles: [
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                                  title: Text(strings.stepAccount),
                                  trailing: notifier.value.accountStepDone ? const Icon(Icons.task_alt_outlined, color: Color(0xFF3CDE87)) : const Icon(Icons.chevron_right_outlined),
                                  onTap: notifier.value.accountStepDone ? null : stepAccount,
                                ),
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                                  title: Text(strings.stepCreditCard),
                                  trailing: notifier.value.creditCardStepDone ? const Icon(Icons.task_alt_outlined, color: Color(0xFF3CDE87)) : const Icon(Icons.chevron_right_outlined),
                                  onTap: notifier.value.creditCardStepDone ? null : stepCreditCard,
                                ),
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                                  title: Text(strings.stepIncome),
                                  trailing: notifier.value.incomeStepDone ? const Icon(Icons.task_alt_outlined, color: Color(0xFF3CDE87)) : const Icon(Icons.chevron_right_outlined),
                                  onTap: notifier.value.incomeStepDone ? null : stepIncome,
                                ),
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                                  title: Text(strings.stepExpense),
                                  trailing: notifier.value.expenseStepDone ? const Icon(Icons.task_alt_outlined, color: Color(0xFF3CDE87)) : const Icon(Icons.chevron_right_outlined),
                                  onTap: notifier.value.expenseStepDone ? null : stepExpense,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (widget.firstShowing)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Visibility(
                          visible: notifier.value.done,
                          replacement: FilledButton.tonal(
                            onPressed: goHome,
                            child: Text(strings.skip),
                          ),
                          child: FilledButton(
                            onPressed: goHome,
                            child: Text(strings.continueButton),
                          ),
                        ),
                      )
                    else if (!notifier.value.done)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: FilledButton.tonal(
                          onPressed: notDisplayAgain,
                          child: Text(strings.notDisplayAgain),
                        ),
                      )
                  ],
                ),
                if (!widget.firstShowing)
                  const Padding(
                    padding: EdgeInsets.only(left: 4, top: 4),
                    child: BackButton(),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void goHome() => context.goNamed(HomePage.route);

  void notDisplayAgain() {
    notifier.value.done = true;
    notifier.save();

    context.pop();
  }

  Future<void> stepAccount() => context.pushNamed(AccountFormPage.route);

  Future<void> stepCreditCard() => context.pushNamed(CreditCardFormPage.route);

  Future<void> stepIncome() => context.pushNamed(IncomeFormPage.route);

  Future<void> stepExpense() => context.pushNamed(ExpenseFormPage.route);
}
