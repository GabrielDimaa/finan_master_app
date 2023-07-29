import 'package:finan_master_app/shared/exceptions/exceptions.dart';

class CategoryException extends BaseException {
  CategoryException(super.message, super.stackTrace);

  @override
  String toString() => message;
}
