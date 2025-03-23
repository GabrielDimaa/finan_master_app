import 'package:carousel_slider/carousel_slider.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/enums/bill_status_enum.dart';
import 'package:finan_master_app/features/credit_card/presentation/ui/components/credit_card_simple_widget.dart';
import 'package:finan_master_app/features/credit_card/presentation/ui/credit_card_form_page.dart';
import 'package:finan_master_app/features/credit_card/presentation/ui/credit_cards_details_page.dart';
import 'package:finan_master_app/features/home/presentation/notifiers/home_bills_credit_card_notifier.dart';
import 'package:finan_master_app/features/home/presentation/states/home_bills_credit_card_state.dart';
import 'package:finan_master_app/shared/classes/form_result_navigation.dart';
import 'package:finan_master_app/shared/extensions/double_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeCardBillCreditCard extends StatefulWidget {
  final HomeBillsCreditCardNotifier notifier;

  const HomeCardBillCreditCard({super.key, required this.notifier});

  @override
  State<HomeCardBillCreditCard> createState() => _HomeCardBillCreditCardState();
}

class _HomeCardBillCreditCardState extends State<HomeCardBillCreditCard> with ThemeContext {
  late HomeBillsCreditCardState state;

  final CarouselController carouselController = CarouselController();
  int itemCarrouselCurrent = 0;

  BorderRadius get borderRadius => BorderRadius.circular(18);

  @override
  void initState() {
    super.initState();
    state = widget.notifier.value;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.notifier,
      builder: (_, state, __) {
        return ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 200),
          child: Card(
            color: colorScheme.surfaceContainer,
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
            child: InkWell(
              borderRadius: borderRadius,
              onTap: goCreditCardDetails,
              child: Builder(
                builder: (_) {
                  final lastState = this.state;
                  this.state = state;

                  if (state is ErrorHomeBillsCreditCardState) {
                    return Center(
                      child: Text(
                        state.message.replaceAll('Exception: ', ''),
                        style: textTheme.bodyMedium?.copyWith(color: colorScheme.error),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    );
                  }

                  if (state is StartHomeBillsCreditCardState || (state is LoadingHomeBillsCreditCardState && lastState is! ListHomeBillsCreditCardState)) {
                    return const Center(child: SizedBox(height: 30, width: 30, child: CircularProgressIndicator()));
                  }

                  if (state.creditCardsWithBill.isEmpty) {
                    return Center(
                      child: ElevatedButton.icon(
                        onPressed: goCreditCardForm,
                        label: Text(strings.addCreditCard),
                        icon: const Icon(Icons.add),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      CarouselSlider(
                        items: List.generate(
                          state.creditCardsWithBill.length,
                          (index) => Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                CreditCardSimpleWidget(creditCard: state.creditCardsWithBill[index].creditCard),
                                const SizedBox(height: 16),
                                Builder(
                                  builder: (_) {
                                    final BillStatusEnum status = state.creditCardsWithBill[index].bill?.status ?? BillStatusEnum.outstanding;

                                    return Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 18,
                                          decoration: BoxDecoration(
                                            color: status.color,
                                            borderRadius: BorderRadius.circular(100),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(status.description, style: textTheme.bodyLarge),
                                      ],
                                    );
                                  },
                                ),
                                const SizedBox(height: 4),
                                Text((state.creditCardsWithBill[index].bill?.totalSpent ?? 0).money, style: textTheme.titleLarge?.copyWith(fontSize: 18)),
                                const SizedBox(height: 4),
                                Text('${strings.availableLimit} ${(state.creditCardsWithBill[index].creditCard.amountLimit).money}', style: textTheme.labelMedium),
                              ],
                            ),
                          ),
                        ),
                        options: CarouselOptions(
                          height: 172,
                          padEnds: state.creditCardsWithBill.length == 1,
                          viewportFraction: 1,
                          enableInfiniteScroll: false,
                          onPageChanged: (index, _) => setState(() => itemCarrouselCurrent = index),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 10,
                          children: List.generate(
                            state.creditCardsWithBill.length,
                            (index) => Container(
                              width: itemCarrouselCurrent == index ? 10 : 6,
                              height: itemCarrouselCurrent == index ? 10 : 6,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colorScheme.primary.withOpacity(itemCarrouselCurrent == index ? 1 : 0.4),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> goCreditCardForm() async {
    final FormResultNavigation<CreditCardEntity>? result = await context.pushNamed(CreditCardFormPage.route);

    if (result?.isSave == true && result?.value != null) widget.notifier.load();
  }

  void goCreditCardDetails() => context.pushNamed(CreditCardsDetailsPage.route, extra: widget.notifier.creditCardsWithBill[itemCarrouselCurrent].creditCard.id);
}
