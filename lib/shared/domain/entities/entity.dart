import 'package:uuid/uuid.dart';

abstract class Entity {
  final String id;
  DateTime? createdAt;
  DateTime? deletedAt;

  bool get isNew => createdAt == null;

  Entity({
    required String? id,
    required this.createdAt,
    required this.deletedAt,
  }) : id = id ?? const Uuid().v1();
}
