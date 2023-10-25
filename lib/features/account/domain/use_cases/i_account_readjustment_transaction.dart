import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';

abstract interface class IAccountReadjustmentTransaction {
  Future<void> createTransaction({required AccountEntity account, required double readjustmentValue, required String description});
}
