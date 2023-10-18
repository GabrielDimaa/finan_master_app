import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';
import 'package:flutter/painting.dart';

enum StatementStatusEnum {
  paid,
  overdue,
  closed,
  outstanding,
  noMovements
}

extension StatementStatusExtension on StatementStatusEnum {
  String get description => switch (this) {
        StatementStatusEnum.paid => R.strings.statementPaid,
        StatementStatusEnum.overdue => R.strings.statementOverdue,
        StatementStatusEnum.closed => R.strings.statementClosed,
        StatementStatusEnum.outstanding => R.strings.statementOutstanding,
        StatementStatusEnum.noMovements => R.strings.statementNoMovements
      };

  Color get color => switch (this) {
        StatementStatusEnum.paid => const Color(0xFF3AD377),
        StatementStatusEnum.overdue => const Color(0xFFEF575B),
        StatementStatusEnum.closed => const Color(0xFFB7A567),
        StatementStatusEnum.outstanding => const Color(0xFF8388FF),
        StatementStatusEnum.noMovements => const Color(0xFF727272)
      };
}
