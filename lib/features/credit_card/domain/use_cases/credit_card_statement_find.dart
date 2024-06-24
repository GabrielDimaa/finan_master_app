import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_statement_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_statement_repository.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_statement_find.dart';

class CreditCardStatementFind implements ICreditCardStatementFind {
  final ICreditCardStatementRepository _repository;

  CreditCardStatementFind({required ICreditCardStatementRepository repository}) : _repository = repository;

  @override
  Future<CreditCardStatementEntity?> findFirstInPeriod({required DateTime startDate, required DateTime endDate, required String idCreditCard}) => _repository.findFirstInPeriod(startDate: startDate, endDate: endDate, idCreditCard: idCreditCard);

  @override
  Future<List<CreditCardStatementEntity>> findAllAfterDate({required DateTime date, required String idCreditCard}) => _repository.findAllAfterDate(date: date, idCreditCard: idCreditCard);
}
