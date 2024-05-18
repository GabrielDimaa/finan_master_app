import 'package:finan_master_app/shared/infra/models/model.dart';

class UserAccountModel extends Model {
  final String name;
  final String email;

  UserAccountModel({
    required super.id,
    required super.createdAt,
    required super.deletedAt,
    required this.name,
    required this.email,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      ...baseMap(),
      'name': name,
      'email': email,
    };
  }

  @override
  UserAccountModel clone() {
    return UserAccountModel(
      id: id,
      createdAt: createdAt,
      deletedAt: deletedAt,
      name: name,
      email: email,
    );
  }
}
