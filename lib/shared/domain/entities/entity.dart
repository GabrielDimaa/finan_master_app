import 'package:uuid/uuid.dart';

abstract class Entity {
  late final String id;
  DateTime? createdAt;
  DateTime? deletedAt;

  bool get isNew => createdAt == null;

  Entity({
    String? id,
    required this.createdAt,
    required this.deletedAt,
  }) {
    this.id = id ?? const Uuid().v1();
  }

  void validate() {}
}
