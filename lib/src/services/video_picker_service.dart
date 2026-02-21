import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../enums/file_picker_type.dart';
import '../models/smart_file.dart';

/// Picks a video from the device gallery.
class VideoPickerService {
  final ImagePicker _picker;

  VideoPickerService({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  Future<SmartFile?> pick(
      {Duration maxDuration = const Duration(seconds: 60)}) async {
    final picked = await _picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: maxDuration,
    );
    if (picked == null) return null;
    return SmartFile(file: File(picked.path), type: FilePickerType.video);
  }
}
