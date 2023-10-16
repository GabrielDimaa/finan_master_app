import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_statement_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_statement_dates.dart';
import 'package:finan_master_app/shared/extensions/date_time_extension.dart';

class CreditCardStatementDates implements ICreditCardStatementDates {
  @override
  ({DateTime closingDate, DateTime dueDate}) generateDates({required int closingDay, required int dueDay, required DateTime baseDate}) {
    DateTime closingDate = DateTime(baseDate.year, baseDate.month, closingDay, 23, 59, 59, 999);
    DateTime dueDate = DateTime(baseDate.year, baseDate.month, dueDay, 23, 59, 59, 999);

    if (closingDate.isBefore(baseDate)) {
      closingDate = closingDate.addMonth(1);
      dueDate = dueDate.addMonth(1);
    }

    if (closingDay > dueDay) {
      dueDate = dueDate.addMonth(1);
    }

    return (closingDate: closingDate, dueDate: dueDate);
  }

  @override
  List<CreditCardStatementEntity> changeDates({required List<CreditCardStatementEntity> statements, required int closingDay, required int dueDay}) {
    final DateTime dateNow = DateTime.now();

    for (final statement in statements) {
      //Se a data de fechamento da fatura for igual ou anterior a data atual, não altera a fatura.
      if (statement.statementClosingDate == dateNow || statement.statementClosingDate.isBefore(dateNow)) continue;

      DateTime statementClosingDate = DateTime(statement.statementClosingDate.year, statement.statementClosingDate.month, closingDay);
      DateTime statementDueDate = DateTime(statement.statementDueDate.year, statement.statementDueDate.month, dueDay);

      //Se a nova data de fechamento da fatura for igual ou anterior a data atual, não altera a fatura.
      if (statementClosingDate == dateNow || statementClosingDate.isBefore(dateNow)) continue;

      if (statementDueDate.isBefore(statementClosingDate)) {
        statementDueDate = statementDueDate.addMonth(1);
      }

      statement.statementClosingDate = statementClosingDate;
      statement.statementDueDate = statementDueDate;
    }

    return statements;
  }
}
