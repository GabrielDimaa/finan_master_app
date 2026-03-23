import 'package:finan_master_app/features/account/domain/enums/financial_institution_enum.dart';
import 'package:finan_master_app/shared/extensions/double_extension.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';

class HeaderTransactionDetailsSheet extends StatelessWidget {
  final String description;
  final double amount;
  final Color? amountColor;
  final IconData iconAvatar;
  final Color backgroundColorAvatar;
  final Color? onBackgroundColorAvatar;
  final FinancialInstitutionEnum? financialInstitution;

  const HeaderTransactionDetailsSheet({
    super.key,
    required this.description,
    required this.amount,
    this.amountColor,
    required this.iconAvatar,
    required this.backgroundColorAvatar,
    required this.onBackgroundColorAvatar,
    this.financialInstitution,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: backgroundColorAvatar,
          child: Icon(iconAvatar, color: onBackgroundColorAvatar, size: 30),
        ),
        const Spacing.y(),
        Text(description, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18)),
        Text(amount.money, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18, color: amountColor ?? (amount < 0 ? const Color(0XFFFF5454) : const Color(0XFF3CDE87)))),
        const Spacing.y(0.3),
        if (financialInstitution != null)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              financialInstitution!.icon(18),
              const Spacing.x(0.5),
              Text(financialInstitution!.description, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
      ],
    );
  }
}
