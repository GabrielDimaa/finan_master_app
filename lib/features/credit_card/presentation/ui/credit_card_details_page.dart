import 'dart:math';

import 'package:finan_master_app/features/account/domain/enums/financial_institution_enum.dart';
import 'package:finan_master_app/features/account/presentation/notifiers/account_notifier.dart';
import 'package:finan_master_app/features/account/presentation/states/accounts_state.dart';
import 'package:finan_master_app/features/category/presentation/notifiers/categories_notifier.dart';
import 'package:finan_master_app/features/category/presentation/states/categories_state.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_statement_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_transaction_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/enums/brand_card_enum.dart';
import 'package:finan_master_app/features/credit_card/domain/enums/statement_status_enum.dart';
import 'package:finan_master_app/features/credit_card/presentation/notifiers/credit_card_notifier.dart';
import 'package:finan_master_app/features/credit_card/presentation/notifiers/credit_card_statement_notifier.dart';
import 'package:finan_master_app/features/credit_card/presentation/states/credit_card_statement_state.dart';
import 'package:finan_master_app/features/credit_card/presentation/ui/components/pay_statement_dialog.dart';
import 'package:finan_master_app/features/credit_card/presentation/ui/components/statement_status_widget.dart';
import 'package:finan_master_app/features/credit_card/presentation/ui/credit_card_expense_form_page.dart';
import 'package:finan_master_app/features/credit_card/presentation/ui/credit_card_form_page.dart';
import 'package:finan_master_app/shared/classes/form_result_navigation.dart';
import 'package:finan_master_app/shared/extensions/date_time_extension.dart';
import 'package:finan_master_app/shared/extensions/double_extension.dart';
import 'package:finan_master_app/shared/extensions/int_extension.dart';
import 'package:finan_master_app/shared/extensions/string_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/dialog/error_dialog.dart';
import 'package:finan_master_app/shared/presentation/ui/components/monthly_filter.dart';
import 'package:finan_master_app/shared/presentation/ui/components/sliver/sliver_app_bar.dart';
import 'package:finan_master_app/shared/presentation/ui/components/sliver/sliver_scaffold.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class CreditCardDetailsPage extends StatefulWidget {
  static const route = 'credit-card-details';

  final CreditCardEntity creditCard;

  const CreditCardDetailsPage({Key? key, required this.creditCard}) : super(key: key);

  @override
  State<CreditCardDetailsPage> createState() => _CreditCardDetailsPageState();
}

class _CreditCardDetailsPageState extends State<CreditCardDetailsPage> with ThemeContext {
  final CreditCardNotifier creditCardNotifier = GetIt.I.get<CreditCardNotifier>();
  final AccountNotifier accountNotifier = GetIt.I.get<AccountNotifier>();
  final CategoriesNotifier categoriesNotifier = GetIt.I.get<CategoriesNotifier>();
  final CreditCardStatementNotifier creditCardStatementNotifier = GetIt.I.get<CreditCardStatementNotifier>();
  final ValueNotifier<bool> initialLoadingNotifier = ValueNotifier(true);

  bool creditCardChanged = false;

  DateTime dateTimeFilter = DateTime.now();

  @override
  void initState() {
    super.initState();

    Future(() async {
      try {
        await Future.wait([
          accountNotifier.findById(widget.creditCard.idAccount!),
          categoriesNotifier.findAll(deleted: true),
          creditCardStatementNotifier.findByPeriod(startDate: dateTimeFilter.getInitialMonth(), endDate: dateTimeFilter.getFinalMonth(), idCreditCard: widget.creditCard.id),
        ]);

        if (accountNotifier.value is ErrorAccountsState) throw Exception((accountNotifier.value as ErrorAccountsState).message);

        if (categoriesNotifier.value is ErrorCategoriesState) throw Exception((categoriesNotifier.value as ErrorCategoriesState).message);

        if (creditCardStatementNotifier.value is ErrorCreditCardStatementState) throw Exception((creditCardStatementNotifier.value as ErrorCreditCardStatementState).message);

        creditCardNotifier.setCreditCard(widget.creditCard);
      } catch (e) {
        if (!mounted) return;
        ErrorDialog.show(context, e.toString());
      } finally {
        initialLoadingNotifier.value = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (creditCardChanged) context.pop(FormResultNavigation.save(creditCardNotifier.creditCard));
        return Future.value(true);
      },
      child: ValueListenableBuilder(
        valueListenable: initialLoadingNotifier,
        builder: (_, initialLoading, __) {
          return ValueListenableBuilder(
            valueListenable: creditCardNotifier,
            builder: (_, __, ___) {
              return SliverScaffold(
                appBar: SliverAppBarMedium(
                  title: Text(creditCardNotifier.creditCard.description),
                  actions: [
                    PopupMenuButton(
                      tooltip: strings.moreOptions,
                      icon: const Icon(Icons.more_vert_outlined),
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                          onTap: () => goCreditCardExpenseForm(context: context),
                          child: Row(
                            children: [
                              const Icon(Icons.credit_card_outlined, size: 20),
                              const Spacing.x(),
                              Text(strings.cardExpense),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          onTap: () => goCreditCardForm(context),
                          child: Row(
                            children: [
                              const Icon(Icons.edit_outlined, size: 20),
                              const Spacing.x(),
                              Text(strings.edit),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                body: Builder(
                  builder: (_) {
                    if (initialLoading) return const SizedBox.shrink();

                    return SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Spacing.y(),
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 20,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  accountNotifier.value.account.financialInstitution!.icon(24),
                                  const Spacing.x(),
                                  Text(accountNotifier.value.account.description),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  creditCardNotifier.creditCard.brand!.icon(24),
                                  const Spacing.x(),
                                  Text(creditCardNotifier.creditCard.brand!.description),
                                ],
                              ),
                            ],
                          ),
                          const Spacing.y(1.5),
                          MonthlyFilter(
                            initialDate: dateTimeFilter,
                            onChange: (DateTime date) async {
                              dateTimeFilter = date;
                              await refreshStatement();
                            },
                          ),
                          const Spacing.y(1.5),
                          ValueListenableBuilder(
                            valueListenable: creditCardStatementNotifier,
                            builder: (_, state, __) {
                              return AnimatedSwitcher(
                                duration: const Duration(milliseconds: 500),
                                child: switch (state) {
                                  ErrorCreditCardStatementState error => Text(error.message),
                                  FilteringCreditCardStatementState _ => const CircularProgressIndicator(),
                                  ChangedCreditCardStatementState _ => Builder(
                                      builder: (_) {
                                        return Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 16),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  StatementStatusWidget(status: state.creditCardStatement?.status ?? StatementStatusEnum.noMovements),
                                                  const Spacing.y(),
                                                  Text(strings.totalSpent, style: textTheme.labelLarge),
                                                  Text((state.creditCardStatement?.totalSpent ?? 0).money, style: textTheme.headlineLarge),
                                                  const Spacing.y(),
                                                  Text('${strings.totalPaid}: ${(state.creditCardStatement?.totalPaid ?? 0).abs().money}', style: textTheme.labelLarge?.copyWith(color: colorScheme.onSurfaceVariant)),
                                                  Text('${strings.amountOutstanding}: ${(state.creditCardStatement?.statementAmount ?? 0).money}', style: textTheme.labelLarge?.copyWith(color: colorScheme.onSurfaceVariant)),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(0.0.moneyWithoutSymbol),
                                                      const Spacing.x(),
                                                      Flexible(
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(4),
                                                          child: ConstrainedBox(
                                                            constraints: const BoxConstraints(maxWidth: 300),
                                                            child: Stack(
                                                              children: [
                                                                Container(
                                                                  decoration: BoxDecoration(color: colorScheme.brightness == Brightness.light ? colorScheme.inversePrimary : colorScheme.onBackground),
                                                                  height: 4,
                                                                ),
                                                                Builder(builder: (_) {
                                                                  final value = (state.creditCardStatement?.statementAmount ?? 0) / (state.creditCardStatement?.amountLimit ?? 1);
                                                                  return FractionallySizedBox(
                                                                    widthFactor: min(max(value, 0.0), 1.0),
                                                                    child: Container(
                                                                      decoration: BoxDecoration(color: colorScheme.brightness == Brightness.light ? colorScheme.primary : colorScheme.inversePrimary),
                                                                      height: 4,
                                                                    ),
                                                                  );
                                                                }),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const Spacing.x(),
                                                      Text((state.creditCardStatement?.amountLimit ?? creditCardNotifier.creditCard.amountLimit).moneyWithoutSymbol),
                                                    ],
                                                  ),
                                                  Text(
                                                    '${strings.availableLimit}: ${(state.creditCardStatement?.amountAvailable ?? creditCardNotifier.creditCard.amountLimit).money}',
                                                    style: textTheme.labelLarge?.copyWith(color: colorScheme.onSurfaceVariant),
                                                  ),
                                                  const Spacing.y(),
                                                  Builder(
                                                    builder: (_) {
                                                      final dates = generateDates();

                                                      return ButtonBar(
                                                        alignment: MainAxisAlignment.spaceBetween,
                                                        buttonPadding: EdgeInsets.zero,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(strings.closureDate, style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                                                              Text((state.creditCardStatement?.statementClosingDate ?? dates.closingDate).format(), style: textTheme.titleMedium),
                                                            ],
                                                          ),
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.end,
                                                            children: [
                                                              Text(strings.dueDate, style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                                                              Text((state.creditCardStatement?.statementDueDate ?? dates.dueDate).format(), style: textTheme.titleMedium),
                                                            ],
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                  const Spacing.y(2),
                                                  if ((state.creditCardStatement?.statementAmount ?? 0) > 0)
                                                    SizedBox(
                                                      width: double.infinity,
                                                      child: FilledButton.icon(
                                                        onPressed: () => payStatement(state.creditCardStatement!),
                                                        icon: const Icon(Icons.credit_score_outlined),
                                                        label: Text(strings.payStatement),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                            if (state.creditCardStatement?.transactions.isNotEmpty ?? false) ...[
                                              const Spacing.y(2),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(strings.transactions, style: textTheme.titleSmall),
                                                ),
                                              ),
                                            ],
                                            ListView.separated(
                                              physics: const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: state.creditCardStatement?.transactions.length ?? 0,
                                              separatorBuilder: (_, __) => const Divider(),
                                              itemBuilder: (_, index) {
                                                final transaction = state.creditCardStatement!.transactions[index];
                                                final category = categoriesNotifier.value.categories.firstWhere((category) => category.id == transaction.idCategory);
                                                return ListTile(
                                                  leading: CircleAvatar(
                                                    backgroundColor: Color(category.color.toColor()!),
                                                    child: Icon(category.icon.parseIconData(), color: Colors.white),
                                                  ),
                                                  title: Text(transaction.description),
                                                  subtitle: Text(category.description),
                                                  trailing: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        transaction.amount.money,
                                                        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: transaction.amount < 0 ? const Color(0XFF3CDE87) : null),
                                                      ),
                                                      Text(transaction.date.formatDateToRelative()),
                                                    ],
                                                  ),
                                                  onTap: () => goCreditCardExpenseForm(context: context, entity: transaction),
                                                );
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  _ => const SizedBox.shrink(),
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> goCreditCardForm(BuildContext context) async {
    final FormResultNavigation<CreditCardEntity>? result = await context.pushNamed(CreditCardFormPage.route, extra: creditCardNotifier.creditCard);

    if (result?.isSave == true) {
      creditCardNotifier.setCreditCard(result!.value!);
      creditCardChanged = true;
      await refreshStatement();
    }

    if (result?.isDelete ?? false) {
      if (!mounted) return;
      context.pop(FormResultNavigation<CreditCardEntity>.delete());
    }
  }

  Future<void> payStatement(CreditCardStatementEntity statement) async {
    final CreditCardStatementEntity? result = await PayStatementDialog.show(context: context, statement: statement);
    if (result != null) await refreshStatement();
  }

  Future<void> goCreditCardExpenseForm({required BuildContext context, CreditCardTransactionEntity? entity}) async {
    if (entity != null && entity.amount < 0) return;

    final FormResultNavigation? result = await context.pushNamed(CreditCardExpensePage.route, extra: entity);
    if (result != null) await refreshStatement();
  }

  Future<void> refreshStatement() async {
    await creditCardStatementNotifier.findByPeriod(
      startDate: dateTimeFilter.getInitialMonth(),
      endDate: dateTimeFilter.getFinalMonth(),
      idCreditCard: creditCardNotifier.creditCard.id,
    );
  }

  ({DateTime closingDate, DateTime dueDate}) generateDates() {
    final closingDate = DateTime(dateTimeFilter.year, dateTimeFilter.month, creditCardNotifier.creditCard.statementClosingDay);
    final dueDate = DateTime(dateTimeFilter.year, dateTimeFilter.month, creditCardNotifier.creditCard.statementDueDay);

    if (dueDate.isBefore(closingDate)) {
      dueDate.addMonth(1);
    }

    return (closingDate: closingDate, dueDate: dueDate);
  }
}
