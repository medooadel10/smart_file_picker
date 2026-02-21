// This is a standalone example app showing how to use smart_file_picker.
// It lives here only for local development. In a real project you would add
// an `example/` directory instead.

import 'package:flutter/material.dart';
import 'package:smart_file_picker/smart_file_picker.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'smart_file_picker Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const _HomePage(),
    );
  }
}

class _HomePage extends StatefulWidget {
  const _HomePage();

  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  SmartFile? _picked;
  List<SmartFile> _multiPicked = [];
  bool _enableCropping = false;

  Future<void> _pick(FilePickerType type) async {
    final file = await SmartFilePicker.pick(
      type,
      config: SmartFilePickerConfig(enableCropping: _enableCropping),
      context: context,
    );
    if (file != null) setState(() => _picked = file);
  }

  Future<void> _pickMultiple() async {
    final files = await SmartFilePicker.pickMultiple(
      config: SmartFilePickerConfig(enableCropping: _enableCropping),
      context: context,
    );
    if (files.isNotEmpty) setState(() => _multiPicked = files);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('smart_file_picker Demo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SwitchListTile(
              title: const Text('Enable image cropping'),
              value: _enableCropping,
              onChanged: (v) => setState(() => _enableCropping = v),
            ),
            const Divider(),
            _ActionButton(
              label: 'Camera',
              icon: Icons.camera_alt,
              onTap: () => _pick(FilePickerType.camera),
            ),
            _ActionButton(
              label: 'Gallery (single)',
              icon: Icons.photo,
              onTap: () => _pick(FilePickerType.gallery),
            ),
            _ActionButton(
              label: 'Gallery (multiple)',
              icon: Icons.photo_library,
              onTap: _pickMultiple,
            ),
            _ActionButton(
              label: 'PDF',
              icon: Icons.picture_as_pdf,
              onTap: () => _pick(FilePickerType.pdf),
            ),
            _ActionButton(
              label: 'Video',
              icon: Icons.videocam,
              onTap: () => _pick(FilePickerType.video),
            ),
            const Divider(),
            if (_picked != null) ...[
              const Text('Last picked file:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (_picked!.type == FilePickerType.camera ||
                  _picked!.type == FilePickerType.gallery)
                Image.file(_picked!.file, height: 200, fit: BoxFit.cover)
              else
                Text(_picked!.file.path),
            ],
            if (_multiPicked.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text('${_multiPicked.length} images picked:',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _multiPicked
                    .map((f) => Image.file(f.file,
                        width: 80, height: 80, fit: BoxFit.cover))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }
}
