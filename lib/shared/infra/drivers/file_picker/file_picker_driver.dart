import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:finan_master_app/shared/infra/drivers/file_picker/i_file_picker_driver.dart';

class FilePickerDriver implements IFilePickerDriver {
  @override
  Future<File?> pickFile({required List<String>? allowedExtensions}) async {
    final FilePickerResult? filePicker = await FilePicker.platform.pickFiles(
      lockParentWindow: true,
      allowMultiple: false,
      allowedExtensions: Platform.isWindows ? allowedExtensions : null,
      type: Platform.isWindows ? FileType.custom : FileType.any,
    );

    if (filePicker == null) return null;

    return File(filePicker.files.single.path!);
  }
}
