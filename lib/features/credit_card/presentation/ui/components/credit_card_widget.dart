import 'package:finan_master_app/features/account/domain/enums/financial_institution_enum.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/enums/brand_card_enum.dart';
import 'package:flutter/material.dart';
import 'package:finan_master_app/l10n/generated/app_localizations.dart';

class CreditCardWidget extends StatelessWidget {
  final CreditCardEntity creditCard;
  final VoidCallback? onTap;

  const CreditCardWidget({super.key, required this.creditCard, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
      color: creditCard.financialInstitutionAccount!.creditCardBackgroundColor,
      elevation: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 8, top: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                creditCard.financialInstitutionAccount!.icon(48),
                const Spacer(),
                IconButton(
                  tooltip: AppLocalizations.of(context)!.edit,
                  onPressed: onTap,
                  color: creditCard.financialInstitutionAccount!.creditCardOnBackgroundColor,
                  icon: const Icon(Icons.edit_outlined, size: 20),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(creditCard.description, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: creditCard.financialInstitutionAccount!.creditCardOnBackgroundColor)),
                const Spacer(),
                creditCard.brand!.icon(40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
