import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_statement_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_statement_dates.dart';
import 'package:finan_master_app/shared/extensions/date_time_extension.dart';

class CreditCardStatementDates implements ICreditCardStatementDates {
  @override
  ({DateTime closingDate, DateTime dueDate}) generateDates({required int closingDay, required int dueDay, required DateTime baseDate}) {
    DateTime closingDate = DateTime(baseDate.year, baseDate.month, closingDay);
    DateTime dueDate = DateTime(baseDate.year, baseDate.month, dueDay, 23, 59, 59, 999);

    if (closingDate.isBefore(baseDate) || closingDate == baseDate) {
      closingDate = closingDate.addMonths(1);
      dueDate = dueDate.addMonths(1);
    }

    if (closingDay > dueDay) {
      dueDate = dueDate.addMonths(1);
    }

    return (closingDate: closingDate, dueDate: dueDate);
  }

  @override
  List<CreditCardStatementEntity> changeDates({required List<CreditCardStatementEntity> statements, required int closingDay, required int dueDay}) {
    final DateTime dateNow = DateTime.now();

    bool isAddMonth = false;
    bool isSubtractMonth = false;

    for (int index = 0; index < statements.length; index++) {
      final CreditCardStatementEntity statement = statements[index];

      //Se a data de fechamento da fatura for igual ou anterior a data atual, não altera a fatura.
      if (statement.statementClosingDate == dateNow || statement.statementClosingDate.isBefore(dateNow)) continue;

      /*
        Deve usar a data de fechamento no vencimento e depois aplicar a diferença caso fique inferior a data de fechamento.
        Sem isso poderá ocorrer o seguinte caso:
        * Fechamento: 27/05 - Vencimento: 02/06
        * Ao alterar para o fechamento no dia 20 e o vencimento no dia 25. As datas ficavam com um mês de diferença (20/05 - 25/06).
      */
      DateTime statementClosingDate = DateTime(statement.statementClosingDate.year, statement.statementClosingDate.month, closingDay);
      DateTime statementDueDate = DateTime(statement.statementClosingDate.year, statement.statementClosingDate.month, dueDay, 23, 59, 59, 999);

      //Se a nova data de fechamento da fatura for igual ou anterior a data atual, adiciona ela para o próximo mês.
      if (isAddMonth || statementClosingDate == dateNow || statementClosingDate.isBefore(dateNow)) {
        statementClosingDate = statementClosingDate.addMonths(1);
        statementDueDate = statementDueDate.addMonths(1);
        isAddMonth = true;
      }

      if (statementDueDate.isBefore(statementClosingDate)) {
        statementDueDate = statementDueDate.addMonths(1);
      }

      if (!isAddMonth) {
        //Diminui as datas em um mês e verifica se ainda é posterior a data de atual.
        final DateTime statementClosingDateSubtract = statementClosingDate.subtractMonths(1);
        final DateTime statementDueDateSubtract = statementDueDate.subtractMonths(1);
        if ((isSubtractMonth || index == 0) && statementClosingDateSubtract != dateNow && statementClosingDateSubtract.isAfter(dateNow)) {
          statementClosingDate = statementClosingDateSubtract;
          statementDueDate = statementDueDateSubtract;
          isSubtractMonth = true;
        }
      }

      statement.statementClosingDate = statementClosingDate;
      statement.statementDueDate = statementDueDate;
    }

    return statements;
  }
}
