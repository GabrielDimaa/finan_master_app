import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_repository.dart';
import 'package:finan_master_app/features/credit_card/helpers/factories/credit_card_factory.dart';
import 'package:finan_master_app/features/credit_card/infra/data_sources/i_credit_card_local_data_source.dart';
import 'package:finan_master_app/features/credit_card/infra/models/credit_card_model.dart';

class CreditCardRepository implements ICreditCardRepository {
  final ICreditCardLocalDataSource _dataSource;

  CreditCardRepository({required ICreditCardLocalDataSource dataSource}) : _dataSource = dataSource;

  @override
  Future<CreditCardEntity> save(CreditCardEntity entity) async {
    final CreditCardModel creditCard = await _dataSource.upsert(CreditCardFactory.fromEntity(entity));
    return CreditCardFactory.toEntity(creditCard);
  }

  @override
  Future<List<CreditCardEntity>> findAll() async {
    final List<CreditCardModel> result = await _dataSource.findAll();
    return result.map((e) => CreditCardFactory.toEntity(e)).toList();
  }
}
