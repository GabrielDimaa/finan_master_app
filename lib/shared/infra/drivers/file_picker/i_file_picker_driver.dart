import 'dart:io';

abstract interface class IFilePickerDriver {
  Future<File?> pickFile({required List<String>? allowedExtensions});
}