import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_bill_entity.dart';

abstract interface class ICreditCardBillDates {
  ({DateTime closingDate, DateTime dueDate}) generateDates({required int closingDay, required int dueDay, required DateTime baseDate});

  List<CreditCardBillEntity> changeDates({required List<CreditCardBillEntity> bills, required int closingDay, required int dueDay});
}
