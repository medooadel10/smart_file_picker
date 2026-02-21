import 'package:flutter/material.dart';
import 'package:smart_file_picker/src/services/camera_picker_service.dart';

import 'enums/file_picker_type.dart';
import 'models/smart_file.dart';
import 'models/smart_file_picker_config.dart';
import 'services/gallery_picker_service.dart';
import 'services/image_cropper_service.dart';
import 'services/multi_image_picker_service.dart';
import 'services/pdf_picker_service.dart';
import 'services/video_picker_service.dart';

/// A versatile file picker with optional image-cropping support.
///
/// ### Basic usage
/// ```dart
/// // Pick a single image from the gallery (no cropping)
/// final result = await SmartFilePicker.pick(FilePickerType.gallery);
///
/// // Pick a camera photo and crop it
/// final result = await SmartFilePicker.pick(
///   FilePickerType.camera,
///   config: SmartFilePickerConfig(enableCropping: true),
///   context: context,
/// );
///
/// // Pick multiple images
/// final images = await SmartFilePicker.pickMultiple();
/// ```
class SmartFilePicker {
  SmartFilePicker._();

  // ── Internal services (overrideable for testing) ──────────────────────────

  static CameraPickerService _cameraService = CameraPickerService();
  static GalleryPickerService _galleryService = GalleryPickerService();
  static MultiImagePickerService _multiImageService = MultiImagePickerService();
  static PdfPickerService _pdfService = PdfPickerService();
  static VideoPickerService _videoService = VideoPickerService();
  static ImageCropperService _cropperService = ImageCropperService();

  /// Overrides internal services (useful in tests).
  @visibleForTesting
  static void overrideServices({
    CameraPickerService? camera,
    GalleryPickerService? gallery,
    MultiImagePickerService? multiImage,
    PdfPickerService? pdf,
    VideoPickerService? video,
    ImageCropperService? cropper,
  }) {
    if (camera != null) _cameraService = camera;
    if (gallery != null) _galleryService = gallery;
    if (multiImage != null) _multiImageService = multiImage;
    if (pdf != null) _pdfService = pdf;
    if (video != null) _videoService = video;
    if (cropper != null) _cropperService = cropper;
  }

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Picks a single file of the given [type].
  ///
  /// Pass a [config] to enable/configure cropping (images only).
  /// A [context] is required on web and is used to derive the Android toolbar
  /// color from the active theme when [SmartFilePickerConfig.androidToolbarColor]
  /// is not set.
  ///
  /// Returns `null` if the user cancels.
  static Future<SmartFile?> pick(
    FilePickerType type, {
    SmartFilePickerConfig config = const SmartFilePickerConfig(),
    BuildContext? context,
  }) async {
    SmartFile? result;

    switch (type) {
      case FilePickerType.camera:
        result = await _cameraService.pick();
      case FilePickerType.gallery:
        result = await _galleryService.pick();
      case FilePickerType.pdf:
        result = await _pdfService.pick();
      case FilePickerType.video:
        result = await _videoService.pick(
          maxDuration: config.maxVideoDuration,
        );
    }

    if (result == null) return null;

    // Apply cropping for image types when enabled.
    if (config.enableCropping && _isImage(type)) {
      final cropped = await _cropperService.crop(
        result.file,
        config: config,
        context: context, // ignore: use_build_context_synchronously
      );
      if (cropped == null) return null; // user cancelled crop
      return SmartFile(file: cropped, type: type);
    }

    return result;
  }

  /// Picks multiple images from the gallery.
  ///
  /// Pass a [config] to enable/configure cropping.
  /// When cropping is enabled each image is cropped individually; if the user
  /// cancels cropping for one image it is excluded from the result.
  ///
  /// Returns an empty list if the user cancels.
  static Future<List<SmartFile>> pickMultiple({
    SmartFilePickerConfig config = const SmartFilePickerConfig(),
    BuildContext? context,
  }) async {
    final results = await _multiImageService.pick(limit: config.maxImages);

    if (!config.enableCropping) return results;

    final cropped = <SmartFile>[];
    for (final smartFile in results) {
      final croppedFile = await _cropperService.crop(
        smartFile.file,
        config: config,
        context: context, // ignore: use_build_context_synchronously
      );
      if (croppedFile != null) {
        cropped.add(SmartFile(file: croppedFile, type: smartFile.type));
      }
    }
    return cropped;
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  static bool _isImage(FilePickerType type) =>
      type == FilePickerType.camera || type == FilePickerType.gallery;
}
