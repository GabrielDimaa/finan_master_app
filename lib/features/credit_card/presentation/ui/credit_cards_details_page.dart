import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:collection/collection.dart';
import 'package:finan_master_app/di/dependency_injection.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_bill_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/enums/bill_status_enum.dart';
import 'package:finan_master_app/features/credit_card/presentation/ui/components/credit_card_widget.dart';
import 'package:finan_master_app/features/credit_card/presentation/ui/credit_card_bill_details_page.dart';
import 'package:finan_master_app/features/credit_card/presentation/ui/credit_card_bills_page.dart';
import 'package:finan_master_app/features/credit_card/presentation/ui/credit_card_expense_form_page.dart';
import 'package:finan_master_app/features/credit_card/presentation/ui/credit_card_form_page.dart';
import 'package:finan_master_app/features/credit_card/presentation/view_models/credit_cards_details_view_model.dart';
import 'package:finan_master_app/shared/classes/form_result_navigation.dart';
import 'package:finan_master_app/shared/extensions/date_time_extension.dart';
import 'package:finan_master_app/shared/extensions/double_extension.dart';
import 'package:finan_master_app/shared/extensions/string_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/app_router.dart';
import 'package:finan_master_app/shared/presentation/ui/components/message_error_widget.dart';
import 'package:finan_master_app/shared/presentation/ui/components/navigation/nav_drawer.dart';
import 'package:finan_master_app/shared/presentation/ui/components/no_content_widget.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreditCardsDetailsPage extends StatefulWidget {
  static const String route = 'credit-cards-details';
  static const int indexDrawer = 1;

  final String? idCreditCard;

  const CreditCardsDetailsPage({Key? key, this.idCreditCard}) : super(key: key);

  @override
  State<CreditCardsDetailsPage> createState() => _CreditCardsDetailsPageState();
}

class _CreditCardsDetailsPageState extends State<CreditCardsDetailsPage> with ThemeContext {
  final CreditCardsDetailsViewModel viewModel = DI.get<CreditCardsDetailsViewModel>();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final CarouselSliderController carouselController = CarouselSliderController();

  @override
  void initState() {
    super.initState();

    Future(() async {
      await viewModel.load.execute(widget.idCreditCard);

      if (viewModel.creditCardSelected != null) {
        Future.delayed(const Duration(milliseconds: 200), () {
          carouselController.animateToPage(
            viewModel.creditCards.indexWhere((creditCard) => creditCard.id == viewModel.creditCardSelected!.id),
            duration: const Duration(milliseconds: 500),
            curve: Curves.ease,
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          tooltip: strings.menu,
          icon: const Icon(Icons.menu),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        ),
        title: Text(strings.creditCards),
        centerTitle: true,
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
            ],
          ),
        ],
      ),
      drawer: const NavDrawer(selectedIndex: CreditCardsDetailsPage.indexDrawer),
      floatingActionButton: FloatingActionButton(
        tooltip: strings.createCreditCard,
        onPressed: goCreditCard,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: Listenable.merge([viewModel, viewModel.load]),
          builder: (_, __) {
            if (viewModel.load.running) return const Center(child: CircularProgressIndicator());
            if (viewModel.load.hasError) return MessageErrorWidget(viewModel.load.error.toString());
            if (viewModel.creditCards.isEmpty) NoContentWidget(child: Text(strings.noCreditCardRegistered));

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacing.y(),
                  CarouselSlider(
                    carouselController: carouselController,
                    items: List.generate(
                      viewModel.creditCards.length,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: CreditCardWidget(
                          creditCard: viewModel.creditCards[index],
                          onTap: () => goCreditCard(viewModel.creditCards[index]),
                        ),
                      ),
                    ),
                    options: CarouselOptions(
                      padEnds: viewModel.creditCards.length == 1,
                      viewportFraction: 0.85,
                      aspectRatio: 2.4,
                      enableInfiniteScroll: false,
                      onPageChanged: (index, _) => viewModel.setCreditCardSelected(viewModel.creditCards[index]),
                    ),
                  ),
                  const Spacing.y(4),
                  _Limit(
                    amountLimit: viewModel.creditCardSelected?.amountLimit ?? 0,
                    amountLimitUtilized: viewModel.creditCardSelected?.amountLimitUtilized ?? 0,
                  ),
                  const Spacing.y(2),
                  ListenableBuilder(
                    listenable: viewModel.billsFind,
                    builder: (_, __) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: viewModel.billsFind.hasError
                            ? MessageErrorWidget(viewModel.billsFind.error.toString())
                            : viewModel.billsFind.completed
                                ? _Bill(
                                    creditCard: viewModel.creditCardSelected!,
                                    bills: viewModel.billsFind.result ?? [],
                                    onRefreshCreditCard: viewModel.refreshCreditCard,
                                  )
                                : const SizedBox.shrink(),
                      );
                    },
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> goCreditCard([CreditCardEntity? creditCard]) async {
    final FormResultNavigation<CreditCardEntity>? result = await context.pushNamedWithAd(CreditCardFormPage.route, extra: creditCard);
    if (result == null) return;

    if (result.isSave) {
      if (creditCard == null) {
        viewModel.setCreditCards([result.value!, ...viewModel.creditCards]);
        viewModel.setCreditCardSelected(viewModel.creditCards.first);
        carouselController.animateToPage(0, duration: const Duration(milliseconds: 500), curve: Curves.ease);
        return;
      }

      await viewModel.refreshCreditCard();
    }

    if (result.isDelete) {
      viewModel.setCreditCards(viewModel.creditCards..removeWhere((e) => e.id == creditCard?.id));
    }
  }

  Future<void> goCreditCardExpenseForm({required BuildContext context}) async {
    final FormResultNavigation? result = await context.pushNamedWithAd(CreditCardExpensePage.route);
    if (result != null) await viewModel.refreshCreditCard();
  }
}

class _Limit extends StatefulWidget {
  final double amountLimit;
  final double amountLimitUtilized;

  const _Limit({required this.amountLimit, required this.amountLimitUtilized});

  @override
  State<_Limit> createState() => _LimitState();
}

class _LimitState extends State<_Limit> with ThemeContext {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: textTheme.bodyLarge,
              text: strings.limit,
              children: [TextSpan(text: ' ${widget.amountLimit.money}', style: const TextStyle(fontWeight: FontWeight.w600))],
            ),
          ),
          const Spacing.y(1.5),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(color: colorScheme.surfaceContainer),
                  height: 6,
                ),
                Builder(
                  builder: (_) {
                    final value = widget.amountLimit == 0.0 ? 0.0 : (widget.amountLimitUtilized) / (widget.amountLimit);
                    return FractionallySizedBox(
                      widthFactor: min(max(value, 0.0), 1.0),
                      child: Container(
                        decoration: BoxDecoration(color: colorScheme.brightness == Brightness.light ? colorScheme.primary : colorScheme.inversePrimary),
                        height: 6,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const Spacing.y(),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    style: textTheme.bodyMedium,
                    text: strings.utilized,
                    children: [
                      TextSpan(text: ' ${widget.amountLimitUtilized.money}', style: const TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: textTheme.bodyMedium,
                    text: strings.available,
                    children: [
                      TextSpan(text: ' ${(widget.amountLimit - widget.amountLimitUtilized).truncateFractionalDigits(2).money}', style: const TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Bill extends StatefulWidget {
  final CreditCardEntity creditCard;
  final List<CreditCardBillEntity> bills;
  final VoidCallback onRefreshCreditCard;

  const _Bill({required this.creditCard, required this.bills, required this.onRefreshCreditCard});

  @override
  State<_Bill> createState() => _BillState();
}

class _BillState extends State<_Bill> with ThemeContext {
  final List<CreditCardBillEntity> bills = [];

  @override
  void initState() {
    super.initState();

    widget.bills.removeWhere((e) => e.status == BillStatusEnum.paid && e.billClosingDate.isBefore(DateTime(DateTime.now().year, DateTime.now().month)));

    final DateTime billFirst = widget.bills.firstOrNull?.billClosingDate ?? DateTime(DateTime.now().year, DateTime.now().month, widget.creditCard.billClosingDay);
    final DateTime billLast = widget.bills.lastOrNull?.billClosingDate ?? billFirst;

    DateTime date = billFirst;

    while (date.isBefore(billLast) || date.isAtSameMomentAs(billLast) || bills.length < 12) {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            children: [
              Text(strings.bills, style: textTheme.bodyLarge),
              const Spacer(),
              TextButton.icon(
                iconAlignment: IconAlignment.end,
                onPressed: goViewAll,
                label: Text(strings.viewAll),
                icon: const Icon(Icons.chevron_right_outlined),
              ),
            ],
          ),
        ),
        const Spacing.y(0.5),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: bills.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (_, index) {
              final CreditCardBillEntity bill = bills[index];

              return ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 108),
                child: Card(
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => goBillDetails(bill),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(bill.billClosingDate.formatMMMM().capitalizeFirstLetter()),
                          Text(bill.totalSpent.money, style: textTheme.titleMedium),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(bill.status.description, style: textTheme.bodySmall),
                              const SizedBox(height: 6),
                              Container(
                                height: 4,
                                width: 32,
                                decoration: BoxDecoration(
                                  color: bill.status.color,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> goViewAll() async {
    final FormResultNavigation<List<CreditCardBillEntity>>? result = await context.pushNamed(CreditCardBillsPage.route, extra: widget.creditCard);

    if (result?.isSave == true) {
      widget.onRefreshCreditCard();

      for (final CreditCardBillEntity bill in result!.value!) {
        final int index = bills.indexWhere((e) => e.id == bill.id);

        if (index >= 0) bills[index] = bill;
      }
    }
  }

  Future<void> goBillDetails(CreditCardBillEntity bill) async {
    final FormResultNavigation? result = await context.pushNamed(CreditCardBillDetailsPage.route, extra: CreditCardBillDetailsArgsPage(bill: bill, creditCard: widget.creditCard));
    if (result == null) return;

    widget.onRefreshCreditCard();

    final int index = bills.indexWhere((e) => e.id == result.value!.id);

    if (index >= 0) bills[index] = result.value!;
  }

  ({DateTime closingDate, DateTime dueDate}) generateDates(DateTime date) {
    final closingDate = DateTime(date.year, date.month, widget.creditCard.billClosingDay);
    final dueDate = DateTime(date.year, date.month, widget.creditCard.billDueDay);

    if (dueDate.isBefore(closingDate)) {
      dueDate.addMonths(1);
    }

    return (closingDate: closingDate, dueDate: dueDate);
  }
}
