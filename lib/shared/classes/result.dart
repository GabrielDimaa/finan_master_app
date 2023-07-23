sealed class Result<S, F> {
  T fold<T>(T Function(S success) onSuccess, T Function(F failure) onFailure);

  S? successOrNull();

  F? failureOrNull();

  bool isSuccess();

  bool isError();

  factory Result.success(S success) => Success(success);

  factory Result.failure(F failure) => Failure(failure);
}

class Success<S, F> implements Result<S, F> {
  const Success(this._success);

  final S _success;

  @override
  T fold<T>(T Function(S success) onSuccess, T Function(F error) onFailure) => onSuccess(_success);

  @override
  S successOrNull() => _success;

  @override
  F? failureOrNull() => null;

  @override
  bool isSuccess() => true;

  @override
  bool isError() => false;

  @override
  int get hashCode => _success.hashCode;

  @override
  bool operator ==(Object other) => other is Success && other._success == _success;
}

class Failure<S, F> implements Result<S, F> {
  final F _failure;

  const Failure(this._failure);

  @override
  W fold<W>(W Function(S succcess) onSuccess, W Function(F failure) onFailure) => onFailure(_failure);

  @override
  S? successOrNull() => null;

  @override
  F failureOrNull() => _failure;

  @override
  bool isSuccess() => false;

  @override
  bool isError() => true;

  @override
  int get hashCode => _failure.hashCode;

  @override
  bool operator ==(Object other) => other is Failure && other._failure == _failure;
}
