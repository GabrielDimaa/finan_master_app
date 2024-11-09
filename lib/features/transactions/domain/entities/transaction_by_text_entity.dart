class TransactionByTextEntity {
  final String description;
  final String idCategory;
  final String idAccount;
  final String? observation;

  TransactionByTextEntity({
    required this.description,
    required this.idCategory,
    required this.idAccount,
    required this.observation,
  });
}
