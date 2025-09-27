import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/features/home/presentation/view_models/home_view_model.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/transactions_unpaid_unreceived_page.dart';
import 'package:finan_master_app/shared/extensions/double_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum _Type { income, expense }

class HomeCardTransactionUnpaidUnreceived extends StatefulWidget {
  final HomeViewModel viewModel;
  final _Type _type;

  const HomeCardTransactionUnpaidUnreceived.income({super.key, required this.viewModel}) : _type = _Type.income;

  const HomeCardTransactionUnpaidUnreceived.expense({super.key, required this.viewModel}) : _type = _Type.expense;

  @override
  State<HomeCardTransactionUnpaidUnreceived> createState() => _HomeCardTransactionUnpaidUnreceivedState();
}

class _HomeCardTransactionUnpaidUnreceivedState extends State<HomeCardTransactionUnpaidUnreceived> with ThemeContext {
  BorderRadius get borderRadius => BorderRadius.circular(18);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      child: InkWell(
        onTap: goTransactions,
        borderRadius: borderRadius,
        child: Padding(
          padding: const EdgeInsets.all(16).copyWith(right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(color: widget._type == _Type.expense ? const Color(0xFFFF5454) : const Color(0xFF3CDE87)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: widget._type == _Type.expense ? const Icon(Icons.call_received_outlined, size: 15, color: Color(0xFFFF5454)) : const Icon(Icons.call_made_outlined, size: 15, color: Color(0xFF3CDE87)),
              ),
              const Spacing.x(0.7),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget._type == _Type.expense ? strings.payable : strings.receivable, style: textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                    ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 18),
                      child: ListenableBuilder(
                        listenable: widget.viewModel.loadTransactionsUnpaidUnreceived,
                        builder: (_, __) {
                          final prev = widget.viewModel.loadTransactionsUnpaidUnreceived.previous;

                          if (widget.viewModel.loadTransactionsUnpaidUnreceived.hasError) {
                            return Text(
                              widget.viewModel.loadTransactionsUnpaidUnreceived.error.toString().replaceAll('Exception: ', ''),
                              style: textTheme.bodyMedium?.copyWith(color: colorScheme.error),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            );
                          }

                          if (widget.viewModel.loadTransactionsUnpaidUnreceived.running && prev?.completed != true) {
                            return const Align(
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(strokeWidth: 2.5),
                              ),
                            );
                          }

                          final amountsExpense = widget.viewModel.loadTransactionsUnpaidUnreceived.result?.amountsExpense ?? prev!.result!.amountsExpense;
                          final amountsIncome = widget.viewModel.loadTransactionsUnpaidUnreceived.result?.amountsIncome ?? prev!.result!.amountsIncome;

                          return Text(
                            widget._type == _Type.expense ? amountsExpense.money : amountsIncome.money,
                            style: textTheme.titleLarge?.copyWith(fontSize: 13),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_outlined, color: colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }

  void goTransactions() => context.pushNamed(TransactionsUnpaidUnreceivedPage.route, extra: widget._type == _Type.expense ? CategoryTypeEnum.expense : CategoryTypeEnum.income);
}
