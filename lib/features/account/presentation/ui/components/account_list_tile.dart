import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/domain/enums/financial_institution_enum.dart';
import 'package:finan_master_app/shared/extensions/double_extension.dart';
import 'package:flutter/material.dart';

class AccountListTile extends StatelessWidget {
  final AccountEntity account;
  final VoidCallback onTap;

  const AccountListTile({Key? key, required this.account, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: account.financialInstitution!.icon(),
      title: Text(account.description),
      subtitle: Text(account.balance.money),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
