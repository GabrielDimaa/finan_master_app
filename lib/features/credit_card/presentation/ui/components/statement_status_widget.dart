import 'package:finan_master_app/features/credit_card/domain/enums/statement_status_enum.dart';
import 'package:flutter/material.dart';

class StatementStatusWidget extends StatelessWidget {
  final StatementStatusEnum status;

  const StatementStatusWidget({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: status.color, width: 1),
      ),
      child: Text(status.description, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: status.color)),
    );
  }
}
