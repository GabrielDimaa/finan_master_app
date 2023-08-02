enum FormResultOperationEnum { save, delete }

class FormResultNavigation<T> {
  final FormResultOperationEnum? _operation;
  final T? value;

  bool get isSave => _operation == FormResultOperationEnum.save;
  bool get isDelete => _operation == FormResultOperationEnum.delete;

  FormResultNavigation.save(T this.value) : _operation = FormResultOperationEnum.save;

  FormResultNavigation.delete()
      : value = null,
        _operation = FormResultOperationEnum.delete;
}
