import 'package:finan_master_app/di/dependency_injection.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_bill_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/enums/bill_status_enum.dart';
import 'package:finan_master_app/features/credit_card/presentation/notifiers/credit_card_bills_notifier.dart';
import 'package:finan_master_app/features/credit_card/presentation/states/credit_card_bills_state.dart';
import 'package:finan_master_app/features/credit_card/presentation/ui/components/credit_card_simple_widget.dart';
import 'package:finan_master_app/features/credit_card/presentation/ui/credit_card_bill_details_page.dart';
import 'package:finan_master_app/features/reports/presentation/enums/date_period_enum.dart';
import 'package:finan_master_app/shared/classes/form_result_navigation.dart';
import 'package:finan_master_app/shared/extensions/date_time_extension.dart';
import 'package:finan_master_app/shared/extensions/double_extension.dart';
import 'package:finan_master_app/shared/extensions/string_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/filters/date_period_filter.dart';
import 'package:finan_master_app/shared/presentation/ui/components/filters/filters_bottom_sheet.dart';
import 'package:finan_master_app/shared/presentation/ui/components/message_error_widget.dart';
import 'package:finan_master_app/shared/presentation/ui/components/sliver/sliver_app_bar_medium.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreditCardBillsPage extends StatefulWidget {
  static const String route = 'credit-card-bills';

  final CreditCardEntity creditCard;

  const CreditCardBillsPage({super.key, required this.creditCard});

  @override
  State<CreditCardBillsPage> createState() => _CreditCardBillsPageState();
}

class _CreditCardBillsPageState extends State<CreditCardBillsPage> with ThemeContext {
  final CreditCardBillsNotifier notifier = DI.get<CreditCardBillsNotifier>();

  late DateTime startDate;
  late DateTime endDate;

  List<CreditCardBillEntity> billsChanged = [];

  @override
  void initState() {
    super.initState();

    Future(() async {
      final DateTime now = DateTime.now();

      startDate = DateTime(now.subtractMonths(2).year, now.subtractMonths(2).month, now.day).getInitialMonth();
      endDate = DateTime(now.addMonths(10).year, now.addMonths(10).month, now.day).getFinalMonth();

      await notifier.findByPeriod(startDate: startDate, endDate: endDate, idCreditCard: widget.creditCard.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // canPop: false,
      // onPopInvoked: (_) => context.pop(billsChanged.isNotEmpty ? FormResultNavigation.save(billsChanged) : null),
      onWillPop: () async {
        if (billsChanged.isNotEmpty) context.pop(FormResultNavigation.save(billsChanged));
        return true;
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBarMedium(
              title: Text(strings.bills),
              actions: [
                IconButton(
                  tooltip: strings.filters,
                  onPressed: filters,
                  icon: const Icon(Icons.filter_list_outlined),
                ),
              ],
            ),
            SliverPadding(
              padding: EdgeInsets.zero,
              sliver: SliverPersistentHeader(
                delegate: _CreditCardPersistentHeader(widget.creditCard),
                pinned: true,
              ),
            ),
            ValueListenableBuilder(
              valueListenable: notifier,
              builder: (_, state, __) {
                return switch (state) {
                  LoadingCreditCardBillsState _ || StartCreditCardBillsState _ => const SliverFillRemaining(hasScrollBody: false, child: Center(child: CircularProgressIndicator())),
                  ErrorCreditCardBillsState error => SliverFillRemaining(hasScrollBody: false, child: MessageErrorWidget(error.message)),
                  ListCreditCardBillsState _ => _List(
                      key: ObjectKey(state),
                      bills: state.bills,
                      creditCard: widget.creditCard,
                      onBillChanged: onBillChanged,
                      startDate: startDate,
                      endDate: endDate,
                    ),
                };
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> filters() async {
    await FiltersBottomSheet.show(
      context: context,
      filter: () => notifier.findByPeriod(startDate: startDate, endDate: endDate, idCreditCard: widget.creditCard.id),
      children: [
        DatePeriodFilter(
          periods: const [DatePeriodEnum.oneMonth, DatePeriodEnum.threeMonth, DatePeriodEnum.sixMonth, DatePeriodEnum.oneYear],
          dateRange: DateTimeRange(start: startDate, end: endDate),
          showClear: false,
          onSelected: (DateTime? dateTimeInitial, DateTime? dateTimeFinal) {
            startDate = dateTimeInitial ?? startDate;
            endDate = dateTimeFinal ?? endDate;
          },
        ),
      ],
    );
  }

  void onBillChanged(CreditCardBillEntity bill) {
    if (!billsChanged.any((e) => e.id == bill.id)) billsChanged.add(bill);
  }
}

class _CreditCardPersistentHeader extends SliverPersistentHeaderDelegate {
  final CreditCardEntity creditCard;

  _CreditCardPersistentHeader(this.creditCard);

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: CreditCardSimpleWidget(creditCard: creditCard),
    );
  }

  @override
  double get maxExtent => 68;

  @override
  double get minExtent => 68;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}

class _List extends StatefulWidget {
  final List<CreditCardBillEntity> bills;
  final CreditCardEntity creditCard;
  final void Function(CreditCardBillEntity bill) onBillChanged;
  final DateTime startDate;
  final DateTime endDate;

  const _List({super.key, required this.bills, required this.creditCard, required this.startDate, required this.endDate, required this.onBillChanged});

  @override
  State<_List> createState() => _ListState();
}

class _ListState extends State<_List> with ThemeContext {
  final List<CreditCardBillEntity> bills = [];

  @override
  void initState() {
    super.initState();

    final DateTime billFirst = widget.bills.firstOrNull?.billClosingDate ?? DateTime(widget.startDate.year, widget.startDate.month, widget.creditCard.billClosingDay);
    final DateTime billLast = widget.bills.lastOrNull?.billClosingDate ?? billFirst;

    DateTime date = billFirst;

    while (date.isBefore(billLast) || date.isAtSameMomentAs(billLast) || bills.length < (differenceInMonths(widget.startDate, widget.endDate) + 1)) {
      // Verificar se há uma fatura para o mês atual
      final CreditCardBillEntity bill = widget.bills.firstWhere(
        (bill) => bill.billClosingDate.year == date.year && bill.billClosingDate.month == date.month,
        orElse: () => CreditCardBillEntity(
          id: null,
          createdAt: null,
          deletedAt: null,
          billClosingDate: generateDates(date).closingDate,
          billDueDate: generateDates(date).dueDate,
          idCreditCard: widget.creditCard.id,
          transactions: [],
        ),
      );

      bills.add(bill);

      // Avançar para o próximo mês
      date = date.addMonths(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
      itemCount: bills.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (_, index) {
        final CreditCardBillEntity bill = bills[index];

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 18,
                decoration: BoxDecoration(
                  color: bill.status.color,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              const SizedBox(width: 10),
              Text(bill.status.description, style: textTheme.bodyLarge),
            ],
          ),
          subtitle: Text(bill.billClosingDate.formatYMMMM().capitalizeFirstLetter()),
          trailing: Text(bill.totalSpent.money, style: textTheme.titleMedium),
          onTap: () => goBillDetails(bill),
        );
      },
    );
  }

  ({DateTime closingDate, DateTime dueDate}) generateDates(DateTime date) {
    final closingDate = DateTime(date.year, date.month, widget.creditCard.billClosingDay);
    final dueDate = DateTime(date.year, date.month, widget.creditCard.billDueDay);

    if (dueDate.isBefore(closingDate)) {
      dueDate.addMonths(1);
    }

    return (closingDate: closingDate, dueDate: dueDate);
  }

  Future<void> goBillDetails(CreditCardBillEntity bill) async {
    final FormResultNavigation<CreditCardBillEntity>? result = await context.pushNamed(CreditCardBillDetailsPage.route, extra: CreditCardBillDetailsArgsPage(bill: bill, creditCard: widget.creditCard));

    if (result?.isSave == true) {
      final int index = bills.indexOf(bill);
      if (index >= 0) {
        bills[index] = result!.value!;
        widget.onBillChanged(result.value!);
      }
    }
  }
}
