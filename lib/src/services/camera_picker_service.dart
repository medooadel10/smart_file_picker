import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../enums/file_picker_type.dart';
import '../models/smart_file.dart';

/// Picks a single image using the device camera.
class CameraPickerService {
  final ImagePicker _picker;

  CameraPickerService({ImagePicker? picker})
      : _picker = picker ?? ImagePicker();

  Future<SmartFile?> pick() async {
    final picked = await _picker.pickImage(source: ImageSource.camera);
    if (picked == null) return null;
    return SmartFile(file: File(picked.path), type: FilePickerType.camera);
  }
}
