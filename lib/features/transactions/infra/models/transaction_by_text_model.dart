class TransactionByTextModel {
  final String description;
  final String idCategory;
  final String? idAccount;
  final String? idCreditCard;
  final String? observation;

  TransactionByTextModel({
    required this.description,
    required this.idCategory,
    required this.idAccount,
    required this.idCreditCard,
    required this.observation,
  });
}
