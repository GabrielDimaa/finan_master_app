enum AuthType {
  email(1),
  google(2);

  final int value;

  const AuthType(this.value);

  static AuthType getByValue(int value) => values.firstWhere((e) => e.value == value);
}
