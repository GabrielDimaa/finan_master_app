import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finan_master_app/features/user_account/infra/data_sources/i_user_account_cloud_data_source.dart';
import 'package:finan_master_app/features/user_account/infra/models/user_account_model.dart';
import 'package:finan_master_app/shared/classes/connectivity_network.dart';
import 'package:uuid/uuid.dart';

class UserAccountCloudDataSource implements IUserAccountCloudDataSource {
  final FirebaseFirestore _firestore;

  UserAccountCloudDataSource({required FirebaseFirestore firestore}) : _firestore = firestore;

  static const String _collectionName = 'users';

  @override
  Future<UserAccountModel> insert(UserAccountModel model) => _upsert(model);

  @override
  Future<UserAccountModel> update(UserAccountModel model) => _upsert(model);

  @override
  Future<UserAccountModel?> getByEmail(String email) async {
    await ConnectivityNetwork.hasInternet();

    final snapshot = await _firestore.collection(_collectionName).where('email', isEqualTo: email).limit(1).get();

    final Map<String, dynamic>? result = snapshot.docs.firstOrNull?.data();

    if (result == null) return null;

    final UserAccountModel userAccount = UserAccountModel(
      id: result['id'],
      createdAt: DateTime.tryParse(result['created_at'] ?? '')?.toLocal(),
      deletedAt: DateTime.tryParse(result['deleted_at'] ?? '')?.toLocal(),
      name: result['name'],
      email: result['email'],
    );

    return userAccount;
  }

  Future<UserAccountModel> _upsert(UserAccountModel model) async {
    await ConnectivityNetwork.hasInternet();

    final UserAccountModel? result = await getByEmail(model.email);

    final UserAccountModel userAccount = UserAccountModel(
      id: result?.id ?? const Uuid().v1(),
      createdAt: result?.createdAt ?? DateTime.now(),
      deletedAt: result?.deletedAt,
      name: model.name,
      email: model.email,
    );

    await _firestore.collection(_collectionName).doc(userAccount.id).set(userAccount.toMap());

    return model;
  }
}
