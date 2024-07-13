import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/features/home/presentation/notifiers/home_monthly_transaction_notifier.dart';
import 'package:finan_master_app/features/home/presentation/states/home_monthly_transaction_state.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/transactions_list_page.dart';
import 'package:finan_master_app/shared/extensions/double_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum _Type { income, expense }

class HomeCardMonthlyTransaction extends StatefulWidget {
  final HomeMonthlyTransactionNotifier notifier;
  final _Type _type;

  const HomeCardMonthlyTransaction.income({super.key, required this.notifier}) : _type = _Type.income;

  const HomeCardMonthlyTransaction.expense({super.key, required this.notifier}) : _type = _Type.expense;

  @override
  State<HomeCardMonthlyTransaction> createState() => _HomeCardMonthlyTransactionState();
}

class _HomeCardMonthlyTransactionState extends State<HomeCardMonthlyTransaction> with ThemeContext {
  late HomeMonthlyTransactionState state;

  @override
  void initState() {
    super.initState();

    state = widget.notifier.value;
  }

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(color: widget._type == _Type.expense ? const Color(0xFFFF5454) : const Color(0xFF3CDE87)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: widget._type == _Type.expense ? const Icon(Icons.arrow_downward_outlined, size: 15, color: Color(0xFFFF5454)) : const Icon(Icons.arrow_upward_outlined, size: 15, color: Color(0xFF3CDE87)),
              ),
              const Spacing.y(),
              const Spacer(),
              Text(widget._type == _Type.expense ? strings.monthlyExpense : strings.monthlyIncome, style: textTheme.labelLarge?.copyWith(color: colorScheme.onSurfaceVariant)),
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 18),
                      child: ValueListenableBuilder(
                        valueListenable: widget.notifier,
                        builder: (_, state, __) {
                          final lastState = this.state;
                          this.state = state;

                          if (state is ErrorHomeMonthlyTransactionState) {
                            return Text(
                              state.message.replaceAll('Exception: ', ''),
                              style: textTheme.bodyMedium?.copyWith(color: colorScheme.error),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            );
                          }

                          if (state is StartHomeMonthlyTransactionState || (state is LoadingHomeMonthlyTransactionState && lastState is! LoadedHomeMonthlyTransactionState)) {
                            return const Align(
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(strokeWidth: 2.5),
                              ),
                            );
                          }

                          return Text(
                            widget._type == _Type.expense ? widget.notifier.value.amountsExpense.money : widget.notifier.value.amountsIncome.money,
                            style: textTheme.titleLarge?.copyWith(fontSize: 18),
                          );
                        },
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right_outlined, color: colorScheme.onSurfaceVariant),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void goTransactions() => context.goNamed(TransactionsListPage.route, extra: widget._type == _Type.expense ? CategoryTypeEnum.expense : CategoryTypeEnum.income);
}
