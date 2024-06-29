import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';
import 'package:flutter/painting.dart';

enum BillStatusEnum {
  paid,
  overdue,
  closed,
  outstanding,
}

extension BillStatusExtension on BillStatusEnum {
  String get description => switch (this) {
        BillStatusEnum.paid => R.strings.billPaid,
        BillStatusEnum.overdue => R.strings.billOverdue,
        BillStatusEnum.closed => R.strings.billClosed,
        BillStatusEnum.outstanding => R.strings.billOutstanding,
      };

  Color get color => switch (this) {
        BillStatusEnum.paid => const Color(0xFF3AD377),
        BillStatusEnum.overdue => const Color(0xFFEF575B),
        BillStatusEnum.closed => const Color(0xFFDCC830),
        BillStatusEnum.outstanding => const Color(0xFF3C65F6),
      };
}
