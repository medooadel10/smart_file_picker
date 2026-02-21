# smart_file_picker

A Flutter package for picking files — images (camera & gallery), PDFs, and videos — with optional image cropping powered by [`image_cropper`](https://pub.dev/packages/image_cropper).

## Features

| Type | API |
|------|-----|
| Camera photo | `SmartFilePicker.pick(FilePickerType.camera)` |
| Gallery image | `SmartFilePicker.pick(FilePickerType.gallery)` |
| Multiple images | `SmartFilePicker.pickMultiple()` |
| PDF document | `SmartFilePicker.pick(FilePickerType.pdf)` |
| Video | `SmartFilePicker.pick(FilePickerType.video)` |
| Image cropping | Pass `SmartFilePickerConfig(enableCropping: true)` |

## Installation

```yaml
dependencies:
  smart_file_picker: ^0.0.1
```

## Platform setup

### Android

Add to `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
```

For Android 13+ (API 33+) replace `READ_EXTERNAL_STORAGE` with:

```xml
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
<uses-permission android:name="android.permission.READ_MEDIA_VIDEO"/>
```

### iOS

Add to `Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>Used to capture photos.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Used to pick images and videos.</string>
```

## Usage

### Pick a single file

```dart
import 'package:smart_file_picker/smart_file_picker.dart';

// Gallery image — no cropping
final file = await SmartFilePicker.pick(FilePickerType.gallery);

// Camera photo with cropping
final file = await SmartFilePicker.pick(
  FilePickerType.camera,
  config: SmartFilePickerConfig(enableCropping: true),
  context: context, // required for cropping on web & theme color
);

// PDF
final file = await SmartFilePicker.pick(FilePickerType.pdf);

// Video (max 60 s by default)
final file = await SmartFilePicker.pick(
  FilePickerType.video,
  config: SmartFilePickerConfig(
    maxVideoDuration: Duration(seconds: 120),
  ),
);

if (file != null) {
  print(file.file.path); // dart:io File
  print(file.type);      // FilePickerType.gallery
}
```

### Pick multiple images

```dart
final images = await SmartFilePicker.pickMultiple(
  config: SmartFilePickerConfig(
    enableCropping: true,
    maxImages: 5,
  ),
  context: context,
);

for (final img in images) {
  print(img.file.path);
}
```

### Cropping configuration

```dart
SmartFilePickerConfig(
  enableCropping: true,

  // Offer original & square presets in the cropper
  cropAspectRatioPresets: [
    CropAspectRatioPreset.original,
    CropAspectRatioPreset.square,
    CropAspectRatioPreset.ratio16x9,
  ],

  // Lock to a fixed ratio (optional)
  lockedCropAspectRatio: CropAspectRatio(ratioX: 4, ratioY: 3),

  // Customize Android toolbar
  androidToolbarColor: Colors.teal,
  androidToolbarWidgetColor: Colors.white,
);
```

## API reference

### `SmartFilePicker`

| Method | Description |
|--------|-------------|
| `pick(type, {config, context})` | Pick one file. Returns `null` on cancel. |
| `pickMultiple({config, context})` | Pick multiple gallery images. Returns `[]` on cancel. |

### `FilePickerType`

`camera` · `gallery` · `pdf` · `video`

### `SmartFilePickerConfig`

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `enableCropping` | `bool` | `false` | Show cropper after picking an image |
| `cropAspectRatioPresets` | `List<CropAspectRatioPreset>` | `[original, square]` | Presets in cropper UI |
| `lockedCropAspectRatio` | `CropAspectRatio?` | `null` | Lock aspect ratio |
| `androidToolbarColor` | `Color?` | theme primary | Cropper toolbar background |
| `androidToolbarWidgetColor` | `Color` | `Colors.white` | Cropper toolbar icon color |
| `maxVideoDuration` | `Duration` | 60 s | Max video clip length |
| `maxImages` | `int?` | `null` | Max images in multi-pick |

### `SmartFile`

| Property | Type | Description |
|----------|------|-------------|
| `file` | `File` | The picked/cropped file |
| `type` | `FilePickerType` | The type of the picked file |

## Packages used

- [`image_picker`](https://pub.dev/packages/image_picker)
- [`file_picker`](https://pub.dev/packages/file_picker)
- [`image_cropper`](https://pub.dev/packages/image_cropper)

