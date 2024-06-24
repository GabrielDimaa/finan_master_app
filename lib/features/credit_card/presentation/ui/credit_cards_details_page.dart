import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:collection/collection.dart';
import 'package:finan_master_app/di/dependency_injection.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_statement_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/enums/statement_status_enum.dart';
import 'package:finan_master_app/features/credit_card/presentation/notifiers/credit_card_statements_notifier.dart';
import 'package:finan_master_app/features/credit_card/presentation/notifiers/credit_cards_notifier.dart';
import 'package:finan_master_app/features/credit_card/presentation/states/credit_card_statements_state.dart';
import 'package:finan_master_app/features/credit_card/presentation/states/credit_cards_state.dart';
import 'package:finan_master_app/features/credit_card/presentation/ui/components/credit_card_widget.dart';
import 'package:finan_master_app/features/credit_card/presentation/ui/credit_card_form_page.dart';
import 'package:finan_master_app/shared/classes/form_result_navigation.dart';
import 'package:finan_master_app/shared/extensions/date_time_extension.dart';
import 'package:finan_master_app/shared/extensions/double_extension.dart';
import 'package:finan_master_app/shared/extensions/string_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/message_error_widget.dart';
import 'package:finan_master_app/shared/presentation/ui/components/navigation/nav_drawer.dart';
import 'package:finan_master_app/shared/presentation/ui/components/no_content_widget.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreditCardsPage extends StatefulWidget {
  static const String route = 'credit-cards-details';
  static const int indexDrawer = 1;

  const CreditCardsPage({Key? key}) : super(key: key);

  @override
  State<CreditCardsPage> createState() => _CreditCardsPageState();
}

class _CreditCardsPageState extends State<CreditCardsPage> with ThemeContext {
  final CreditCardsNotifier creditCardsNotifier = DI.get<CreditCardsNotifier>();
  final CreditCardStatementsNotifier statementsNotifier = DI.get<CreditCardStatementsNotifier>();
  final ValueNotifier<CreditCardEntity?> creditCardSelected = ValueNotifier<CreditCardEntity?>(null);

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    Future(() async {
      await creditCardsNotifier.findAll();

      creditCardSelected.addListener(() {
        if (creditCardSelected.value == null) {
          statementsNotifier.setStatements([]);
        } else {
          statementsNotifier.findAllAfterDate(date: DateTime.now().getInitialMonth(), idCreditCard: creditCardSelected.value!.id);
        }
      });

      creditCardSelected.value = creditCardsNotifier.value.creditCards.firstOrNull;
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
      ),
      drawer: const NavDrawer(selectedIndex: CreditCardsPage.indexDrawer),
      floatingActionButton: FloatingActionButton(
        tooltip: strings.createCreditCard,
        onPressed: goCreditCard,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: creditCardsNotifier,
          builder: (_, CreditCardsState state, __) {
            return switch (state) {
              LoadingCreditCardsState _ => const Center(child: CircularProgressIndicator()),
              ErrorCreditCardsState _ => MessageErrorWidget(state.message),
              EmptyCreditCardsState _ => NoContentWidget(child: Text(strings.noCreditCardRegistered)),
              StartCreditCardsState _ => const SizedBox.shrink(),
              ListCreditCardsState state => SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Spacing.y(),
                      CarouselSlider(
                        items: List.generate(
                          state.creditCards.length,
                          (index) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: CreditCardWidget(
                              creditCard: state.creditCards[index],
                              onTap: () => goCreditCard(state.creditCards[index]),
                            ),
                          ),
                        ),
                        options: CarouselOptions(
                          padEnds: state.creditCards.length == 1,
                          viewportFraction: 0.85,
                          aspectRatio: 2.4,
                          enableInfiniteScroll: false,
                          onPageChanged: (index, _) => setState(() => creditCardSelected.value = creditCardsNotifier.value.creditCards[index]),
                        ),
                      ),
                      const Spacing.y(4),
                      _Limit(amountLimit: creditCardSelected.value?.amountLimit ?? 0, amountLimitUtilized: creditCardSelected.value?.amountLimitUtilized ?? 0),
                      const Spacing.y(2),
                      ValueListenableBuilder(
                        valueListenable: statementsNotifier,
                        builder: (_, state, __) {
                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: switch (state) {
                              StartCreditCardStatementsState _ => const SizedBox.shrink(),
                              LoadingCreditCardStatementsState _ => const CircularProgressIndicator(),
                              ErrorCreditCardStatementsState state => MessageErrorWidget(state.message),
                              ListCreditCardStatementsState _ => _Bill(creditCard: creditCardSelected.value!, bills: statementsNotifier.value.statements),
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
            };
          },
        ),
      ),
    );
  }

  Future<void> goCreditCard([CreditCardEntity? creditCard]) async {
    final FormResultNavigation<CreditCardEntity>? result = await context.pushNamed(CreditCardFormPage.route, extra: creditCard);

    if (result == null) return;

    creditCardsNotifier.findAll();
  }

  @override
  void dispose() {
    creditCardSelected.dispose();
    super.dispose();
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
                    final value = (widget.amountLimitUtilized) / (widget.amountLimit);
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
  final List<CreditCardStatementEntity> bills;

  const _Bill({required this.creditCard, required this.bills});

  @override
  State<_Bill> createState() => _BillState();
}

class _BillState extends State<_Bill> with ThemeContext {
  final List<CreditCardStatementEntity> bills = [];

  @override
  void initState() {
    super.initState();

    final DateTime billFirst = widget.bills.firstOrNull?.statementClosingDate ?? DateTime(DateTime.now().year, DateTime.now().month, widget.creditCard.statementClosingDay);
    final DateTime billLast = widget.bills.lastOrNull?.statementClosingDate ?? billFirst;

    DateTime date = billFirst;

    while (date.isBefore(billLast) || date.isAtSameMomentAs(billLast) || bills.length < 12) {
      // Verificar se há uma fatura para o mês atual
      final CreditCardStatementEntity bill = widget.bills.firstWhere(
        (bill) => bill.statementClosingDate.year == date.year && bill.statementClosingDate.month == date.month,
        orElse: () => CreditCardStatementEntity(
          id: null,
          createdAt: null,
          deletedAt: null,
          statementClosingDate: date,
          statementDueDate: date,
          idCreditCard: widget.creditCard.id,
          transactions: [],
          paid: false,
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
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(strings.bills, style: textTheme.bodyLarge),
              const Spacer(),
              TextButton.icon(
                iconAlignment: IconAlignment.end,
                onPressed: () {},
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
              final CreditCardStatementEntity bill = bills[index];

              return ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 108),
                child: Card(
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(bill.statementClosingDate.formatMMMM().capitalizeFirstLetter()),
                          Text(bill.statementAmount.money, style: textTheme.titleMedium),
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
}
