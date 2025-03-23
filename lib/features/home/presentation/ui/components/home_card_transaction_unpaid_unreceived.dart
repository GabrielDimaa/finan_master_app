import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/features/home/presentation/notifiers/home_transactions_unpaid_unreceived_notifier.dart';
import 'package:finan_master_app/features/home/presentation/states/home_transactions_unpaid_unreceived_state.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/transactions_unpaid_unreceived_page.dart';
import 'package:finan_master_app/shared/extensions/double_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum _Type { income, expense }

class HomeCardTransactionUnpaidUnreceived extends StatefulWidget {
  final HomeTransactionsUnpaidUnreceivedNotifier notifier;
  final _Type _type;

  const HomeCardTransactionUnpaidUnreceived.income({super.key, required this.notifier}) : _type = _Type.income;

  const HomeCardTransactionUnpaidUnreceived.expense({super.key, required this.notifier}) : _type = _Type.expense;

  @override
  State<HomeCardTransactionUnpaidUnreceived> createState() => _HomeCardTransactionUnpaidUnreceivedState();
}

class _HomeCardTransactionUnpaidUnreceivedState extends State<HomeCardTransactionUnpaidUnreceived> with ThemeContext {
  late HomeTransactionsUnpaidUnreceivedState state;

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
                      child: ValueListenableBuilder(
                        valueListenable: widget.notifier,
                        builder: (_, state, __) {
                          final lastState = this.state;
                          this.state = state;

                          if (state is ErrorHomeTransactionsUnpaidUnreceivedState) {
                            return Text(
                              state.message.replaceAll('Exception: ', ''),
                              style: textTheme.bodyMedium?.copyWith(color: colorScheme.error),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            );
                          }

                          if (state is StartHomeTransactionsUnpaidUnreceivedState || (state is LoadingHomeTransactionsUnpaidUnreceivedState && lastState is! LoadedHomeTransactionsUnpaidUnreceivedState)) {
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
