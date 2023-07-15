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

  Map<String, dynamic> toMap();

  T clone();
}