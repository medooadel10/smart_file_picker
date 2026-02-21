/// smart_file_picker – Example Application
///
/// This app demonstrates every public API of the smart_file_picker package:
///
///  • [SmartFilePicker.pick]         – picking a single camera photo, gallery
///                                     image, PDF, or video.
///  • [SmartFilePicker.pickMultiple] – picking multiple gallery images.
///  • [SmartFilePickerConfig]        – enabling / configuring image cropping,
///                                     setting a max video duration, and
///                                     limiting the number of images.
///
/// Run this app on a real device to test camera and gallery access.
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smart_file_picker/smart_file_picker.dart';

void main() {
  runApp(const ExampleApp());
}

// ─────────────────────────────────────────────────────────────────────────────
// App root
// ─────────────────────────────────────────────────────────────────────────────

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'smart_file_picker Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Home page
// ─────────────────────────────────────────────────────────────────────────────

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ── State ──────────────────────────────────────────────────────────────────

  /// The last single file that was picked.
  SmartFile? _singleFile;

  /// Files returned from a multi-image pick.
  List<SmartFile> _multiFiles = [];

  // ── Config knobs (toggled by the user in the UI) ──────────────────────────

  bool _enableCropping = false;
  int? _maxImages; // null = unlimited

  // ── Helpers ────────────────────────────────────────────────────────────────

  /// Builds a [SmartFilePickerConfig] from the current UI settings.
  SmartFilePickerConfig get _config => SmartFilePickerConfig(
        enableCropping: _enableCropping,
        maxImages: _maxImages,
        maxVideoDuration: const Duration(seconds: 30),
      );

  /// Picks a single file and stores it in [_singleFile].
  Future<void> _pick(FilePickerType type) async {
    final file = await SmartFilePicker.pick(
      type,
      config: _config,
      context: context,
    );
    if (!mounted) return;
    if (file != null) setState(() => _singleFile = file);
  }

  /// Picks multiple images and stores them in [_multiFiles].
  Future<void> _pickMultiple() async {
    final files = await SmartFilePicker.pickMultiple(
      config: _config,
      context: context,
    );
    if (!mounted) return;
    if (files.isNotEmpty) setState(() => _multiFiles = files);
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('smart_file_picker Example'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Configuration card ───────────────────────────────────────────
          _SectionCard(
            title: 'Configuration',
            child: Column(
              children: [
                SwitchListTile(
                  dense: true,
                  title: const Text('Enable image cropping'),
                  subtitle: const Text(
                    'Applies to camera, gallery and multi-image picks.',
                  ),
                  value: _enableCropping,
                  onChanged: (v) => setState(() => _enableCropping = v),
                ),
                ListTile(
                  dense: true,
                  title: const Text('Max images (multi-pick)'),
                  subtitle: Text(
                    _maxImages == null
                        ? 'Unlimited'
                        : 'Up to $_maxImages images',
                  ),
                  trailing: SegmentedButton<int?>(
                    segments: const [
                      ButtonSegment(value: null, label: Text('∞')),
                      ButtonSegment(value: 3, label: Text('3')),
                      ButtonSegment(value: 5, label: Text('5')),
                    ],
                    selected: {_maxImages},
                    onSelectionChanged: (s) =>
                        setState(() => _maxImages = s.first),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Pick actions ─────────────────────────────────────────────────
          _SectionCard(
            title: 'Pick a File',
            child: Column(
              children: [
                // ── Camera ──────────────────────────────────────────────────
                // SmartFilePicker.pick(FilePickerType.camera)
                _PickButton(
                  label: 'Take a Photo (Camera)',
                  icon: Icons.camera_alt_outlined,
                  color: Colors.indigo,
                  onTap: () => _pick(FilePickerType.camera),
                ),
                const SizedBox(height: 8),

                // ── Gallery single ───────────────────────────────────────────
                // SmartFilePicker.pick(FilePickerType.gallery)
                _PickButton(
                  label: 'Pick Image from Gallery',
                  icon: Icons.photo_outlined,
                  color: Colors.teal,
                  onTap: () => _pick(FilePickerType.gallery),
                ),
                const SizedBox(height: 8),

                // ── Gallery multiple ─────────────────────────────────────────
                // SmartFilePicker.pickMultiple(...)
                _PickButton(
                  label: 'Pick Multiple Images',
                  icon: Icons.photo_library_outlined,
                  color: Colors.cyan,
                  onTap: _pickMultiple,
                ),
                const SizedBox(height: 8),

                // ── PDF ──────────────────────────────────────────────────────
                // SmartFilePicker.pick(FilePickerType.pdf)
                _PickButton(
                  label: 'Pick a PDF Document',
                  icon: Icons.picture_as_pdf_outlined,
                  color: Colors.deepOrange,
                  onTap: () => _pick(FilePickerType.pdf),
                ),
                const SizedBox(height: 8),

                // ── Video ────────────────────────────────────────────────────
                // SmartFilePicker.pick(FilePickerType.video)
                // maxVideoDuration is set to 30 s in _config above.
                _PickButton(
                  label: 'Pick a Video (max 30 s)',
                  icon: Icons.videocam_outlined,
                  color: Colors.purple,
                  onTap: () => _pick(FilePickerType.video),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Single-file result ───────────────────────────────────────────
          if (_singleFile != null)
            _SectionCard(
              title: 'Last Picked File',
              child: _FilePreview(file: _singleFile!),
            ),

          // ── Multi-file result ────────────────────────────────────────────
          if (_multiFiles.isNotEmpty) ...[
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Multi-Picked Images (${_multiFiles.length})',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _multiFiles
                    .map(
                      (f) => ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          f.file,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reusable widgets
// ─────────────────────────────────────────────────────────────────────────────

/// A card with a title and arbitrary [child] content.
class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

/// A full-width button that triggers a pick action.
class _PickButton extends StatelessWidget {
  const _PickButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonalIcon(
      style: FilledButton.styleFrom(
        backgroundColor: Color.alphaBlend(
          color.withValues(alpha: .12),
          Theme.of(context).colorScheme.surface,
        ),
        foregroundColor: color,
        minimumSize: const Size.fromHeight(48),
        alignment: Alignment.centerLeft,
      ),
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}

/// Displays a preview of a [SmartFile].
///
/// - Images are rendered with [Image.file].
/// - PDFs and videos show file metadata (name, size).
class _FilePreview extends StatelessWidget {
  const _FilePreview({required this.file});

  final SmartFile file;

  bool get _isImage =>
      file.type == FilePickerType.camera || file.type == FilePickerType.gallery;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final path = file.file.path;
    final name = path.split(Platform.pathSeparator).last;
    final sizeKb = (file.file.lengthSync() / 1024).toStringAsFixed(1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_isImage)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              file.file,
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
            ),
          )
        else
          Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: theme.colorScheme.surfaceContainerHighest,
            ),
            child: Icon(
              file.type == FilePickerType.pdf
                  ? Icons.picture_as_pdf
                  : Icons.videocam,
              size: 48,
              color: theme.colorScheme.primary,
            ),
          ),
        const SizedBox(height: 8),
        Text(
          name,
          style:
              theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          '${file.type.name.toUpperCase()} · $sizeKb KB',
          style: theme.textTheme.bodySmall
              ?.copyWith(color: theme.colorScheme.outline),
        ),
      ],
    );
  }
}
