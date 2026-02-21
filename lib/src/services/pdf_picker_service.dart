import 'dart:io';

import 'package:file_picker/file_picker.dart';

import '../enums/file_picker_type.dart';
import '../models/smart_file.dart';

/// Picks a single PDF document.
class PdfPickerService {
  Future<SmartFile?> pick() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    final path = result?.files.single.path;
    if (path == null) return null;
    return SmartFile(file: File(path), type: FilePickerType.pdf);
  }
}
