import 'package:finan_master_app/features/first_steps/infra/data_sources/i_first_steps_local_data_source.dart';
import 'package:finan_master_app/features/first_steps/infra/models/first_steps_model.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_batch.dart';
import 'package:finan_master_app/shared/infra/data_sources/local_data_source.dart';

class FirstStepsLocalDataSource extends LocalDataSource<FirstStepsModel> implements IFirstStepsLocalDataSource {
  FirstStepsLocalDataSource({required super.databaseLocal});

  @override
  String get tableName => 'first_steps';

  @override
  void createTable(IDatabaseLocalBatch batch) {
    batch.execute('''
      CREATE TABLE $tableName (
        ${baseColumnsSql()},
        account_step_done INTEGER NOT NULL DEFAULT 0,
        credit_card_step_done INTEGER NOT NULL DEFAULT 0,
        income_step_done INTEGER NOT NULL DEFAULT 0,
        expense_step_done INTEGER NOT NULL DEFAULT 0
      );
    ''');
  }

  @override
  FirstStepsModel fromMap(Map<String, dynamic> map, {String prefix = ''}) {
    final ({DateTime? createdAt, DateTime? deletedAt, String id}) base = baseFromMap(map, prefix: prefix);

    return FirstStepsModel(
      id: base.id,
      createdAt: base.createdAt,
      deletedAt: base.deletedAt,
      accountStepDone: map['${prefix}account_step_done'] == 1,
      creditCardStepDone: map['${prefix}credit_card_step_done'] == 1,
      incomeStepDone: map['${prefix}income_step_done'] == 1,
      expenseStepDone: map['${prefix}expense_step_done'] == 1,
    );
  }
}
