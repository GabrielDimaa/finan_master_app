import 'package:finan_master_app/features/transactions/infra/data_sources/i_transfer_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/models/transfer_model.dart';
import 'package:finan_master_app/shared/infra/data_sources/constants/tables_names_constant.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_batch.dart';
import 'package:finan_master_app/shared/infra/data_sources/local_data_source.dart';
import 'package:finan_master_app/shared/infra/models/model.dart';

class TransferLocalDataSource extends LocalDataSource<TransferModel> implements ITransferLocalDataSource {
  TransferLocalDataSource({required super.databaseLocal});

  @override
  String get tableName => transfersTableName;

  @override
  String get orderByDefault => 'date DESC';

  @override
  void createTable(IDatabaseLocalBatch batch) {
    batch.execute('''
      CREATE TABLE $tableName (
        ${baseColumnsSql()},
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        id_account_from TEXT NOT NULL REFERENCES $accountsTableName(${Model.idColumnName}) ON UPDATE CASCADE ON DELETE CASCADE,
        id_account_to TEXT NOT NULL REFERENCES $accountsTableName(${Model.idColumnName}) ON UPDATE CASCADE ON DELETE CASCADE
      );
    ''');
  }

  @override
  TransferModel fromMap(Map<String, dynamic> map, {String prefix = ''}) {
    final ({DateTime? createdAt, DateTime? deletedAt, String id}) base = baseFromMap(map, prefix: prefix);

    return TransferModel(
      id: base.id,
      createdAt: base.createdAt,
      deletedAt: base.deletedAt,
      amount: map['${prefix}amount'],
      date: DateTime.tryParse(map['${prefix}date'].toString())!.toLocal(),
      idAccountFrom: map['${prefix}id_account_from'],
      idAccountTo: map['${prefix}id_account_to'],
    );
  }
}
