import 'package:flutter_test/flutter_test.dart';
import 'package:smart_file_picker/smart_file_picker.dart';

void main() {
  test('FilePickerType has all expected values', () {
    expect(FilePickerType.values, contains(FilePickerType.camera));
    expect(FilePickerType.values, contains(FilePickerType.gallery));
    expect(FilePickerType.values, contains(FilePickerType.pdf));
    expect(FilePickerType.values, contains(FilePickerType.video));
  });

  test('SmartFilePickerConfig defaults are correct', () {
    const config = SmartFilePickerConfig();
    expect(config.enableCropping, isFalse);
    expect(config.maxVideoDuration, const Duration(seconds: 60));
    expect(config.maxImages, isNull);
  });
}
