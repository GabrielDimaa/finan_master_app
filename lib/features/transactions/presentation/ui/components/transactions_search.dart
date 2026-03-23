import 'package:finan_master_app/di/dependency_injection.dart';
import 'package:finan_master_app/features/account/domain/enums/financial_institution_enum.dart';
import 'package:finan_master_app/features/credit_card/presentation/ui/credit_card_expense_details_sheet.dart';
import 'package:finan_master_app/features/transactions/domain/entities/transaction_search_entity.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/components/details/expense_details_sheet.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/components/details/income_details_sheet.dart';
import 'package:finan_master_app/features/transactions/presentation/view_models/search_transactions_view_model.dart';
import 'package:finan_master_app/shared/classes/form_result_navigation.dart';
import 'package:finan_master_app/shared/extensions/date_time_extension.dart';
import 'package:finan_master_app/shared/extensions/double_extension.dart';
import 'package:finan_master_app/shared/extensions/int_extension.dart';
import 'package:finan_master_app/shared/extensions/string_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';
import 'package:finan_master_app/shared/presentation/ui/components/debounce_search_bar.dart';
import 'package:finan_master_app/shared/presentation/ui/components/message_error_widget.dart';
import 'package:finan_master_app/shared/presentation/ui/components/no_content_widget.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionsSearch extends StatefulWidget {
  const TransactionsSearch._();

  static Future<void> show({required BuildContext context}) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) {
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: const TransactionsSearch._(),
        );
      },
    );
  }

  @override
  State<TransactionsSearch> createState() => _TransactionsSearchState();
}

class _TransactionsSearchState extends State<TransactionsSearch> with ThemeContext {
  final TransactionsSearchViewModel viewModel = DI.get<TransactionsSearchViewModel>();

  final ScrollController scrollController = ScrollController();

  String currentText = '';

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() async {
      if (scrollController.position.pixels > scrollController.position.maxScrollExtent - 300) {
        await viewModel.search.execute(currentText);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DebounceSearchBar(
      onChanged: (text) async {
        currentText = text;

        if (text.isEmpty) {
          viewModel.reset();
          return;
        }

        viewModel.search.execute(currentText);
      },
      builder: (_) {
        return AnimatedBuilder(
          animation: Listenable.merge([viewModel, viewModel.search]),
          builder: (_, __) {
            if (viewModel.search.hasError && viewModel.items.isEmpty) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: MessageErrorWidget(viewModel.search.error.toString()),
              );
            }

            if (viewModel.search.running && viewModel.items.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.items.isEmpty) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: NoContentWidget(child: Text(strings.resultNotFound)),
              );
            }

            final items = buildGroupedList(viewModel.items);

            return ListView.builder(
              controller: scrollController,
              padding: EdgeInsets.zero,
              itemCount: items.length + (viewModel.search.running ? 1 : 0),
              itemBuilder: (_, index) {
                if (index >= items.length) {
                  return const Padding(
                    padding: EdgeInsets.all(12),
                    child: Center(
                      child: SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      ),
                    ),
                  );
                }

                final item = items.elementAt(index);

                if (item is _TransactionHeader) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: Text(
                      item.date.formatDateToRelative() + (item.date.year != DateTime.now().year ? ' ${DateFormat.y(AppLocale().locale.languageCode).format(item.date)}' : ''),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  );
                }

                final transaction = (item as _TransactionRow).transaction;

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  leading: CircleAvatar(
                    backgroundColor: Color(transaction.category.color.toColor()!),
                    child: Icon(transaction.category.icon.parseIconData(), color: Colors.white),
                  ),
                  title: Text(transaction.description),
                  subtitle: Text(transaction.category.description),
                  onTap: () => goDetails(transaction),
                  trailing: Column(
                    spacing: 6,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (transaction.creditCard == null && !transaction.paidOrReceived) ...[
                            const Icon(Icons.push_pin_outlined, size: 18),
                            const Spacing.x(0.5),
                          ],
                          Text(transaction.amount.money, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: transaction.amount < 0 ? const Color(0XFFFF5454) : const Color(0XFF3CDE87))),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          transaction.account?.financialInstitution.icon(16) ?? const Icon(Icons.credit_card, size: 16),
                          const Spacing.x(0.5),
                          Text(transaction.account?.financialInstitution.description ?? transaction.creditCard!.account.financialInstitution.description, style: textTheme.bodySmall),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  List<_TransactionListItem> buildGroupedList(Iterable<TransactionSearchEntity> transactions) {
    final List<_TransactionListItem> list = [];

    DateTime? currentDate;

    for (final t in transactions) {
      if (currentDate == null || !currentDate.isSameDay(t.date)) {
        currentDate = t.date;
        list.add(_TransactionHeader(currentDate));
      }

      list.add(_TransactionRow(t));
    }

    return list;
  }

  Future<Iterable<TransactionSearchEntity>> searchFunction(String text) async {
    await viewModel.search.execute(text);

    return viewModel.items.map((e) => e);
  }

  Future<void> goDetails(TransactionSearchEntity transaction) async {
    FormResultNavigation? resultNavigation;

    if (transaction.amount > 0) {
      await IncomeDetailsSheet.show(context: context, id: transaction.id, onChanged: (value) => resultNavigation = value);
    } else if (transaction.creditCard != null) {
      await CreditCardExpenseDetailsSheet.show(context: context, id: transaction.id, onChanged: (value) => resultNavigation = value);
    } else {
      await ExpenseDetailsSheet.show(context: context, id: transaction.id, onChanged: (value) => resultNavigation = value);
    }

    if (resultNavigation != null) {
      viewModel.reset();
      await viewModel.search.execute(currentText);
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}

sealed class _TransactionListItem {}

class _TransactionHeader extends _TransactionListItem {
  final DateTime date;

  _TransactionHeader(this.date);
}

class _TransactionRow extends _TransactionListItem {
  final TransactionSearchEntity transaction;

  _TransactionRow(this.transaction);
}
