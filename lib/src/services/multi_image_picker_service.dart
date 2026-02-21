import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../enums/file_picker_type.dart';
import '../models/smart_file.dart';

/// Picks multiple images from the device gallery.
class MultiImagePickerService {
  final ImagePicker _picker;

  MultiImagePickerService({ImagePicker? picker})
      : _picker = picker ?? ImagePicker();

  Future<List<SmartFile>> pick({int? limit}) async {
    final picked = await _picker.pickMultiImage(limit: limit);
    return picked
        .map((e) => SmartFile(file: File(e.path), type: FilePickerType.gallery))
        .toList();
  }
}
