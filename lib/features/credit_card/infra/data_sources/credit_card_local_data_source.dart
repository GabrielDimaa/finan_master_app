import 'package:collection/collection.dart';
import 'package:finan_master_app/features/credit_card/domain/enums/brand_card_enum.dart';
import 'package:finan_master_app/features/credit_card/infra/data_sources/i_credit_card_bill_local_data_source.dart';
import 'package:finan_master_app/features/credit_card/infra/data_sources/i_credit_card_local_data_source.dart';
import 'package:finan_master_app/features/credit_card/infra/models/credit_card_bill_model.dart';
import 'package:finan_master_app/features/credit_card/infra/models/credit_card_model.dart';
import 'package:finan_master_app/shared/infra/data_sources/constants/tables_names_constant.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_batch.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';
import 'package:finan_master_app/shared/infra/data_sources/local_data_source.dart';
import 'package:finan_master_app/shared/infra/models/model.dart';

class CreditCardLocalDataSource extends LocalDataSource<CreditCardModel> implements ICreditCardLocalDataSource {
  final ICreditCardBillLocalDataSource _creditCardBillLocalDataSource;

  CreditCardLocalDataSource({
    required super.databaseLocal,
    required ICreditCardBillLocalDataSource creditCardBillLocalDataSource,
  }) : _creditCardBillLocalDataSource = creditCardBillLocalDataSource;

  @override
  String get tableName => creditCardsTableName;

  @override
  String get orderByDefault => 'description COLLATE NOCASE';

  @override
  void createTable(IDatabaseLocalBatch batch) {
    batch.execute('''
      CREATE TABLE $tableName (
        ${baseColumnsSql()},
        description TEXT NOT NULL,
        amount_limit REAL NOT NULL,
        bill_closing_day INTEGER NOT NULL,
        bill_due_day INTEGER NOT NULL,
        brand INTEGER NOT NULL,
        id_account TEXT NOT NULL REFERENCES $accountsTableName(${Model.idColumnName}) ON UPDATE CASCADE ON DELETE RESTRICT
      );
    ''');
  }

  @override
  CreditCardModel fromMap(Map<String, dynamic> map, {String prefix = ''}) {
    final ({DateTime? createdAt, DateTime? deletedAt, String id}) base = baseFromMap(map, prefix: prefix);

    return CreditCardModel(
      id: base.id,
      createdAt: base.createdAt,
      deletedAt: base.deletedAt,
      description: map['${prefix}description'],
      amountLimit: map['${prefix}amount_limit'],
      billClosingDay: map['${prefix}bill_closing_day'],
      billDueDay: map['${prefix}bill_due_day'],
      brand: CardBrandEnum.getByValue(map['${prefix}brand'])!,
      idAccount: map['${prefix}id_account'],
      //É carregado este valor separadamente
      amountLimitUtilized: 0,
    );
  }

  @override
  Future<List<CreditCardModel>> selectFull({String? id, bool deleted = false, String? where, List? whereArgs, String? orderBy, int? offset, int? limit, String? groupBy, ITransactionExecutor? txn}) async {
    final List<CreditCardModel> creditCards = await super.selectFull(id: id, deleted: deleted, where: where, whereArgs: whereArgs, orderBy: orderBy, offset: offset, limit: limit, groupBy: groupBy, txn: txn);

    if (creditCards.isEmpty) return [];

    final List<CreditCardBillModel> bills = await _creditCardBillLocalDataSource.findAll(
      where: 'id_credit_card IN (${creditCards.map((_) => '?').join(', ')}) AND total_amount > ?',
      whereArgs: [...creditCards.map((e) => e.id), 0],
      txn: txn,
    );

    for (final creditCard in creditCards) {
      creditCard.amountLimitUtilized = bills.where((bill) => bill.idCreditCard == creditCard.id).map((bill) => bill.billAmount).sum;
    }

    return creditCards;
  }
}
