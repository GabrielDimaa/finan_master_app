import 'dart:io';

abstract interface class IShareDriver {
  Future<bool> shareFiles(List<File> files, {String? description});

  Future<bool> shareText(String text);
}
