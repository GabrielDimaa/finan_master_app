import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_statement_entity.dart';

abstract interface class ICreditCardStatementDates {
  ({DateTime closingDate, DateTime dueDate}) generateDates({required int closingDay, required int dueDay, required DateTime baseDate});

  List<CreditCardStatementEntity> changeDates({required List<CreditCardStatementEntity> statements, required int closingDay, required int dueDay});
}
