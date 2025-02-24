class TransactionByTextEntity {
  final String description;
  final String idCategory;
  final String? idAccount;
  final String? idCreditCard;
  final String? observation;

  TransactionByTextEntity({
    required this.description,
    required this.idCategory,
    required this.idAccount,
    required this.idCreditCard,
    required this.observation,
  });
}
