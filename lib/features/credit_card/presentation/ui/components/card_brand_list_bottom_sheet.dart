import 'package:diacritic/diacritic.dart';
import 'package:finan_master_app/features/credit_card/domain/enums/brand_card_enum.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/draggable_bottom_sheet.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CardBrandListBottomSheet extends StatefulWidget {
  final CardBrandEnum? cardBrandSelected;

  const CardBrandListBottomSheet({Key? key, required this.cardBrandSelected}) : super(key: key);

  static Future<CardBrandEnum?> show({required BuildContext context, required CardBrandEnum? cardBrandSelected}) async {
    return await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      enableDrag: true,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (_) => CardBrandListBottomSheet(cardBrandSelected: cardBrandSelected),
    );
  }

  @override
  State<CardBrandListBottomSheet> createState() => _CardBrandListBottomSheetState();
}

class _CardBrandListBottomSheetState extends State<CardBrandListBottomSheet> with ThemeContext {
  final List<CardBrandEnum> list = CardBrandEnum.values.toList()..sort((a, b) => removeDiacritics(a.description).compareTo(removeDiacritics(b.description)));

  late CardBrandEnum? selected;

  @override
  void initState() {
    super.initState();

    selected = widget.cardBrandSelected;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableBottomSheet(
      builder: (scrollController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(strings.brands, style: textTheme.titleMedium),
            ),
            const Spacing.y(1.5),
            Expanded(
              child: ListView.separated(
                controller: scrollController,
                itemCount: list.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (_, index) {
                  final CardBrandEnum cardBrand = list[index];
                  return RadioListTile<CardBrandEnum>(
                    title: Row(
                      children: [
                        cardBrand.icon(),
                        const Spacing.x(),
                        Expanded(child: Text(cardBrand.description)),
                      ],
                    ),
                    controlAffinity: ListTileControlAffinity.trailing,
                    toggleable: true,
                    value: cardBrand,
                    groupValue: selected,
                    onChanged: (CardBrandEnum? value) {
                      setState(() => selected = value);
                      context.pop(selected);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
