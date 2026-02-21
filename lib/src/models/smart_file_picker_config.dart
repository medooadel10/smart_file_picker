import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

/// Configuration options for [SmartFilePicker].
class SmartFilePickerConfig {
  // ── Image cropping ─────────────────────────────────────────────────────────

  /// Whether to show the image-cropper after picking an image.
  ///
  /// Applies to [FilePickerType.camera], [FilePickerType.gallery], and
  /// multi-image picks. Defaults to `false`.
  final bool enableCropping;

  /// The aspect-ratio presets shown in the cropper UI.
  ///
  /// Defaults to `[original, square]`.
  final List<CropAspectRatioPreset> cropAspectRatioPresets;

  /// Lock the cropper to a fixed aspect ratio.
  ///
  /// When `null` the user can choose freely from [cropAspectRatioPresets].
  final CropAspectRatio? lockedCropAspectRatio;

  // ── Android cropper UI ────────────────────────────────────────────────────

  /// Toolbar background color for the Android cropper. Defaults to the
  /// primary color of the active [ThemeData].
  final Color? androidToolbarColor;

  /// Toolbar icon/title color for the Android cropper. Defaults to white.
  final Color androidToolbarWidgetColor;

  // ── Video ─────────────────────────────────────────────────────────────────

  /// Maximum duration for the video picker. Defaults to 60 seconds.
  final Duration maxVideoDuration;

  // ── Multi-image ───────────────────────────────────────────────────────────

  /// Maximum number of images that can be selected in a multi-image pick.
  ///
  /// `null` means no limit.
  final int? maxImages;

  /// Creates a [SmartFilePickerConfig].
  const SmartFilePickerConfig({
    this.enableCropping = false,
    this.cropAspectRatioPresets = const [
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.square,
    ],
    this.lockedCropAspectRatio,
    this.androidToolbarColor,
    this.androidToolbarWidgetColor = Colors.white,
    this.maxVideoDuration = const Duration(seconds: 60),
    this.maxImages,
  });
}
