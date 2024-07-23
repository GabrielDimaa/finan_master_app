import 'package:finan_master_app/features/account/domain/enums/financial_institution_enum.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/enums/brand_card_enum.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';

class CreditCardSimpleWidget extends StatelessWidget {
  final CreditCardEntity creditCard;

  const CreditCardSimpleWidget({super.key, required this.creditCard});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: creditCard.financialInstitutionAccount!.creditCardBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            creditCard.financialInstitutionAccount!.icon(),
            const Spacing.x(),
            Text(creditCard.description, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: creditCard.financialInstitutionAccount!.creditCardOnBackgroundColor)),
            const Spacer(),
            creditCard.brand!.icon(),
          ],
        ),
      ),
    );
  }
}
