import 'dart:io';

import '../enums/file_picker_type.dart';

/// Represents a file picked by [SmartFilePicker].
class SmartFile {
  /// The underlying [File] on disk.
  final File file;

  /// The type of the picked file.
  final FilePickerType type;

  /// Creates a [SmartFile].
  const SmartFile({required this.file, required this.type});

  @override
  String toString() => 'SmartFile(type: $type, path: ${file.path})';
}
