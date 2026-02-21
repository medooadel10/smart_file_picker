/// A Flutter package for picking files (images, PDFs, videos) from the device,
/// with optional image-cropping support powered by [image_cropper].
///
/// ## Quick start
///
/// ```dart
/// import 'package:smart_file_picker/smart_file_picker.dart';
///
/// // Pick a gallery image with cropping
/// final file = await SmartFilePicker.pick(
///   FilePickerType.gallery,
///   config: SmartFilePickerConfig(enableCropping: true),
///   context: context,
/// );
///
/// // Pick multiple images
/// final files = await SmartFilePicker.pickMultiple();
/// ```
library;

export 'src/enums/file_picker_type.dart';
export 'src/models/smart_file.dart';
export 'src/models/smart_file_picker_config.dart';
export 'src/smart_file_picker.dart';
