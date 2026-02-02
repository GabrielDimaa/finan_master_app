import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';
import 'package:finan_master_app/features/credit_card/presentation/ui/credit_card_form_page.dart';
import 'package:finan_master_app/shared/classes/form_result_navigation.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/app_router.dart';
import 'package:finan_master_app/shared/presentation/ui/components/draggable_bottom_sheet.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreditCardsListBottomSheet extends StatefulWidget {
  final CreditCardEntity? creditCardSelected;
  final List<CreditCardEntity> creditCards;
  final void Function(CreditCardEntity)? onCreditCardCreated;

  const CreditCardsListBottomSheet({Key? key, required this.creditCardSelected, required this.creditCards, this.onCreditCardCreated}) : super(key: key);

  static Future<CreditCardEntity?> show({
    required BuildContext context,
    required CreditCardEntity? creditCardSelected,
    required List<CreditCardEntity> creditCards,
    void Function(CreditCardEntity)? onCreditCardCreated,
  }) async {
    return await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      enableDrag: true,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (_) => CreditCardsListBottomSheet(creditCardSelected: creditCardSelected, creditCards: creditCards, onCreditCardCreated: onCreditCardCreated),
    );
  }

  @override
  State<CreditCardsListBottomSheet> createState() => _CreditCardsListBottomSheetState();
}

class _CreditCardsListBottomSheetState extends State<CreditCardsListBottomSheet> with ThemeContext {
  @override
  Widget build(BuildContext context) {
    return DraggableBottomSheet(
      builder: (scrollController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(strings.creditCards, style: textTheme.titleMedium),
            ),
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: Visibility(
                  visible: widget.creditCards.isNotEmpty,
                  replacement: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.manage_search_outlined, size: 36),
                      const Spacing.y(),
                      Text(strings.noCreditCardRegistered),
                    ],
                  ),
                  child: RadioGroup<CreditCardEntity>(
                    groupValue: widget.creditCardSelected,
                    onChanged: (value) => context.pop(value),
                    child: ListView.separated(
                      controller: scrollController,
                      itemCount: widget.creditCards.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (_, index) {
                        final CreditCardEntity creditCard = widget.creditCards[index];
                        return RadioListTile<CreditCardEntity>(
                          title: Text(creditCard.description),
                          controlAffinity: ListTileControlAffinity.trailing,
                          toggleable: true,
                          value: creditCard,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton.tonalIcon(
                  icon: const Icon(Icons.add_outlined),
                  label: Text(strings.newCreditCard),
                  onPressed: goCreditCard,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> goCreditCard() async {
    final FormResultNavigation<CreditCardEntity>? result = await context.pushNamedWithAd(CreditCardFormPage.route);

    if (result?.isSave == true && result?.value != null) {
      widget.creditCards.add(result!.value!);
      widget.onCreditCardCreated?.call(result.value!);
    }
  }
}
