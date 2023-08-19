import 'package:diacritic/diacritic.dart';
import 'package:finan_master_app/features/account/domain/enums/financial_institution_enum.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/draggable_bottom_sheet.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FinancialInstitutions extends StatefulWidget {
  final FinancialInstitutionEnum? financialInstitution;

  const FinancialInstitutions({Key? key, required this.financialInstitution}) : super(key: key);

  static Future<FinancialInstitutionEnum?> show({required BuildContext context, required FinancialInstitutionEnum? financialInstitution}) async {
    return await showModalBottomSheet<FinancialInstitutionEnum?>(
      context: context,
      showDragHandle: true,
      enableDrag: true,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (_) => FinancialInstitutions(financialInstitution: financialInstitution),
    );
  }

  @override
  State<FinancialInstitutions> createState() => _FinancialInstitutionsState();
}

class _FinancialInstitutionsState extends State<FinancialInstitutions> with ThemeContext {
  final List<FinancialInstitutionEnum> list = FinancialInstitutionEnum.values.toList()..sort((a, b) => removeDiacritics(a.description).compareTo(removeDiacritics(b.description)));

  late FinancialInstitutionEnum? selected;

  @override
  void initState() {
    super.initState();

    selected = widget.financialInstitution;
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
              child: Text(strings.financialInstitutions, style: textTheme.titleMedium),
            ),
            const Spacing.y(1.5),
            Expanded(
              child: ListView.separated(
                controller: scrollController,
                itemCount: list.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (_, index) {
                  final FinancialInstitutionEnum financialInstitution = list[index];
                  return RadioListTile<FinancialInstitutionEnum>(
                    title: Row(
                      children: [
                        financialInstitution.icon(),
                        const Spacing.x(),
                        Expanded(child: Text(financialInstitution.description)),
                      ],
                    ),
                    controlAffinity: ListTileControlAffinity.trailing,
                    value: financialInstitution,
                    groupValue: selected,
                    onChanged: (FinancialInstitutionEnum? value) {
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
