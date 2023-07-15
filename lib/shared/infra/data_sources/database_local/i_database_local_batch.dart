import 'package:finan_master_app/shared/infra/data_sources/database_local/database_operation.dart';

abstract interface class IDatabaseLocalBatch {
  Future<void> commit();

  void insert(String table, Map<String, dynamic> values);

  void update(String table, Map<String, dynamic> values, {String? where, List<Object?>? whereArgs});

  void delete(String table, {String? where, List<dynamic>? whereArgs});

  void execute(String sql, [List<dynamic>? arguments]);

  void raw(String sql, DatabaseOperation operation, [List<dynamic>? arguments]);
}
