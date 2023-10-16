import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_repository.dart';
import 'package:finan_master_app/features/credit_card/helpers/factories/credit_card_factory.dart';
import 'package:finan_master_app/features/credit_card/infra/data_sources/i_credit_card_local_data_source.dart';
import 'package:finan_master_app/features/credit_card/infra/models/credit_card_model.dart';

class CreditCardRepository implements ICreditCardRepository {
  final ICreditCardLocalDataSource _creditCardDataSource;

  CreditCardRepository({required ICreditCardLocalDataSource creditCardDataSource}) : _creditCardDataSource = creditCardDataSource;

  @override
  Future<CreditCardEntity> save(CreditCardEntity entity) async {
    final CreditCardModel creditCard = await _creditCardDataSource.upsert(CreditCardFactory.fromEntity(entity));
    return CreditCardFactory.toEntity(creditCard);
  }

  @override
  Future<void> delete(CreditCardEntity entity) => _creditCardDataSource.delete(CreditCardFactory.fromEntity(entity));

  @override
  Future<List<CreditCardEntity>> findAll() async {
    final List<CreditCardModel> result = await _creditCardDataSource.findAll();
    return result.map((e) => CreditCardFactory.toEntity(e)).toList();
  }

  @override
  Future<CreditCardEntity?> findById(String id) async {
    final CreditCardModel? model = await _creditCardDataSource.findById(id);
    return model != null ? CreditCardFactory.toEntity(model) : null;
  }
}
