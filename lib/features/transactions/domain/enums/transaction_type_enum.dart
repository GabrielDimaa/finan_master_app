enum TransactionTypeEnum {
  expense(1),
  income(2),
  transfer(3);

  final int value;

  const TransactionTypeEnum(this.value);
}
