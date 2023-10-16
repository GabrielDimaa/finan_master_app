import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_statement_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_statement_dates.dart';
import 'package:finan_master_app/shared/extensions/date_time_extension.dart';

class StatementDates implements IStatementDates {
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
      if (statement.invoiceClosingDate == dateNow || statement.invoiceClosingDate.isBefore(dateNow)) continue;

      DateTime invoiceClosingDate = DateTime(statement.invoiceClosingDate.year, statement.invoiceClosingDate.month, closingDay);
      DateTime invoiceDueDate = DateTime(statement.invoiceDueDate.year, statement.invoiceDueDate.month, dueDay);

      //Se a nova data de fechamento da fatura for igual ou anterior a data atual, não altera a fatura.
      if (invoiceClosingDate == dateNow || invoiceClosingDate.isBefore(dateNow)) continue;

      if (invoiceDueDate.isBefore(invoiceClosingDate)) {
        invoiceDueDate = invoiceDueDate.addMonth(1);
      }

      statement.invoiceClosingDate = invoiceClosingDate;
      statement.invoiceDueDate = invoiceDueDate;
    }

    return statements;
  }
}
