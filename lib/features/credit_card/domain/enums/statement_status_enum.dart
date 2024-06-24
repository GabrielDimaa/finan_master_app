import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';
import 'package:flutter/painting.dart';

enum StatementStatusEnum {
  paid,
  overdue,
  closed,
  outstanding,
}

extension StatementStatusExtension on StatementStatusEnum {
  String get description => switch (this) {
        StatementStatusEnum.paid => R.strings.statementPaid,
        StatementStatusEnum.overdue => R.strings.statementOverdue,
        StatementStatusEnum.closed => R.strings.statementClosed,
        StatementStatusEnum.outstanding => R.strings.statementOutstanding,
      };

  Color get color => switch (this) {
        StatementStatusEnum.paid => const Color(0xFF3AD377),
        StatementStatusEnum.overdue => const Color(0xFFEF575B),
        StatementStatusEnum.closed => const Color(0xFFDCC830),
        StatementStatusEnum.outstanding => const Color(0xFF3C65F6),
      };
}
