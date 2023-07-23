abstract class Model<T> {
  final String id;
  DateTime? createdAt;
  DateTime? deletedAt;

  static const idColumnName = 'id';
  static const createdAtColumnName = 'created_at';
  static const deletedAtColumnName = 'deleted_at';

  Model({
    required this.id,
    required this.createdAt,
    required this.deletedAt,
  });

  T clone();

  Map<String, dynamic> toMap();

  Map<String, dynamic> baseMap() {
    return {
      idColumnName: id,
      createdAtColumnName: createdAt?.toIso8601String(),
      deletedAtColumnName: deletedAt?.toIso8601String(),
    };
  }
}
