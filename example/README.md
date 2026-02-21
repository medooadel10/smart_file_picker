# smart_file_picker – Example App

A runnable Flutter app that demonstrates every public feature of the
[smart_file_picker](https://pub.dev/packages/smart_file_picker) package.

## Features demonstrated

| Feature | API |
|---|---|
| Take a photo with the camera | `SmartFilePicker.pick(FilePickerType.camera)` |
| Pick a single image from the gallery | `SmartFilePicker.pick(FilePickerType.gallery)` |
| Pick multiple images | `SmartFilePicker.pickMultiple()` |
| Pick a PDF document | `SmartFilePicker.pick(FilePickerType.pdf)` |
| Pick a video (with max duration) | `SmartFilePicker.pick(FilePickerType.video, config: ...)` |
| Enable image cropping | `SmartFilePickerConfig(enableCropping: true)` |
| Limit number of images | `SmartFilePickerConfig(maxImages: 5)` |

## Running the example

```bash
cd example
flutter pub get
flutter run
```

> Run on a **real device** to test the camera, gallery, and system file pickers.

## Code overview

```
example/
├── lib/
│   └── main.dart   ← The full example (single file, well-commented)
└── pubspec.yaml    ← Depends on smart_file_picker via a local path reference
```

### Key snippet – picking a single file

```dart
final SmartFile? file = await SmartFilePicker.pick(
  FilePickerType.gallery,
  config: const SmartFilePickerConfig(
    enableCropping: true,
  ),
  context: context,
);

if (file != null) {
  // file.file  → dart:io File
  // file.type  → FilePickerType.gallery
  print('Picked: ${file.file.path}');
}
```

### Key snippet – picking multiple images

```dart
final List<SmartFile> files = await SmartFilePicker.pickMultiple(
  config: SmartFilePickerConfig(
    enableCropping: true,
    maxImages: 5,
  ),
  context: context,
);

for (final f in files) {
  print('Image: ${f.file.path}');
}
```

### Key snippet – picking a video with a max duration

```dart
final SmartFile? video = await SmartFilePicker.pick(
  FilePickerType.video,
  config: const SmartFilePickerConfig(
    maxVideoDuration: Duration(seconds: 30),
  ),
);
```
