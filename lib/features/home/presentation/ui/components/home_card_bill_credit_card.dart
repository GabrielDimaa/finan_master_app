import 'package:carousel_slider/carousel_slider.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/enums/bill_status_enum.dart';
import 'package:finan_master_app/features/credit_card/presentation/ui/components/credit_card_simple_widget.dart';
import 'package:finan_master_app/features/credit_card/presentation/ui/credit_card_form_page.dart';
import 'package:finan_master_app/features/credit_card/presentation/ui/credit_cards_details_page.dart';
import 'package:finan_master_app/features/home/presentation/view_models/home_view_model.dart';
import 'package:finan_master_app/shared/classes/form_result_navigation.dart';
import 'package:finan_master_app/shared/extensions/double_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeCardBillCreditCard extends StatefulWidget {
  final HomeViewModel viewModel;

  const HomeCardBillCreditCard({super.key, required this.viewModel});

  @override
  State<HomeCardBillCreditCard> createState() => _HomeCardBillCreditCardState();
}

class _HomeCardBillCreditCardState extends State<HomeCardBillCreditCard> with ThemeContext {
  final CarouselController carouselController = CarouselController();
  int itemCarrouselCurrent = 0;

  BorderRadius get borderRadius => BorderRadius.circular(18);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel.loadBillsCreditCard,
      builder: (_, __) {
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
                  final prev = widget.viewModel.loadBillsCreditCard.previous;

                  if (widget.viewModel.loadBillsCreditCard.hasError) {
                    return Center(
                      child: Text(
                        widget.viewModel.loadBillsCreditCard.error.toString().replaceAll('Exception: ', ''),
                        style: textTheme.bodyMedium?.copyWith(color: colorScheme.error),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    );
                  }

                  if (widget.viewModel.loadBillsCreditCard.running && prev?.completed != true) {
                    return const Center(child: SizedBox(height: 30, width: 30, child: CircularProgressIndicator()));
                  }

                  final creditCards = widget.viewModel.loadBillsCreditCard.result ?? prev?.result ?? [];

                  if (creditCards.isEmpty) {
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
                          creditCards.length,
                          (index) => Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                CreditCardSimpleWidget(creditCard: creditCards[index].creditCard),
                                const SizedBox(height: 16),
                                Builder(
                                  builder: (_) {
                                    final BillStatusEnum status = creditCards[index].bill?.status ?? BillStatusEnum.outstanding;

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
                                ListenableBuilder(
                                  listenable: widget.viewModel,
                                  builder: (_, __) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (widget.viewModel.hideAmounts) ...[
                                          Text('●●●●', style: textTheme.titleLarge?.copyWith(fontSize: 18)),
                                        ] else ...[
                                          Text((creditCards[index].bill?.totalSpent ?? 0).money, style: textTheme.titleLarge?.copyWith(fontSize: 18)),
                                        ],
                                        const SizedBox(height: 4),
                                        Text('${strings.availableLimit} ${widget.viewModel.hideAmounts ? '●●●●' : (creditCards[index].creditCard.amountLimit).money}', style: textTheme.labelMedium),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        options: CarouselOptions(
                          height: 172,
                          padEnds: creditCards.length == 1,
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
                            creditCards.length,
                            (index) => Container(
                              width: itemCarrouselCurrent == index ? 10 : 6,
                              height: itemCarrouselCurrent == index ? 10 : 6,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colorScheme.primary.withValues(alpha: itemCarrouselCurrent == index ? 1 : 0.4),
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
    final FormResultNavigation<CreditCardEntity>? result = await context.pushNamedWithAd(CreditCardFormPage.route);

    if (result?.isSave == true && result?.value != null) widget.viewModel.load();
  }

  void goCreditCardDetails() => context.pushNamed(CreditCardsDetailsPage.route, extra: (widget.viewModel.loadBillsCreditCard.result ?? widget.viewModel.loadBillsCreditCard.previous?.result ?? [])[itemCarrouselCurrent].creditCard.id);
}
