import 'package:finan_master_app/infra/data_sources/database_local/database_operation.dart';

abstract interface class IDatabaseBatch {
  Future<List<Object?>> commit();

  void insert(String table, Map<String, dynamic> values);

  void update(String table, Map<String, dynamic> values, {String? where, List<Object?>? whereArgs});

  void delete(String table, {String? where, List<dynamic>? whereArgs});

  void execute(String sql, [List<dynamic>? arguments]);

  void raw(String sql, DatabaseOperation operation, [List<dynamic>? arguments]);

  void query(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<dynamic>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  });
}
