import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

import '../models/smart_file_picker_config.dart';

/// Wraps [ImageCropper] and applies [SmartFilePickerConfig] settings.
class ImageCropperService {
  final ImageCropper _cropper;

  ImageCropperService({ImageCropper? cropper})
      : _cropper = cropper ?? ImageCropper();

  /// Launches the cropper for [image] using the provided [config].
  ///
  /// Returns the cropped [File], or `null` if the user cancels.
  Future<File?> crop(
    File image, {
    required SmartFilePickerConfig config,
    BuildContext? context,
  }) async {
    final primaryColor = context != null
        ? Theme.of(context).colorScheme.primary
        : const Color(0xFF6200EE);

    final toolbarColor = config.androidToolbarColor ?? primaryColor;

    final croppedFile = await _cropper.cropImage(
      sourcePath: image.path,
      aspectRatio: config.lockedCropAspectRatio,
      uiSettings: [
        AndroidUiSettings(
          toolbarColor: toolbarColor,
          toolbarWidgetColor: config.androidToolbarWidgetColor,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: config.lockedCropAspectRatio != null,
          aspectRatioPresets: config.cropAspectRatioPresets,
        ),
        IOSUiSettings(
          aspectRatioLockEnabled: config.lockedCropAspectRatio != null,
          aspectRatioPresets: config.cropAspectRatioPresets,
        ),
        WebUiSettings(
          context: context ??
              (throw FlutterError(
                'A BuildContext is required for web image cropping.',
              )),
        ),
      ],
    );

    if (croppedFile == null) return null;
    return File(croppedFile.path);
  }
}
