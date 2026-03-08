import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import '../providers/app_state.dart';
import '../models/scientist.dart';
import '../services/auth_service.dart';
import '../utils/responsive_helper.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F7);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Ayarlar'),
        centerTitle: true,
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            children: [
              // GÖRÜNÜM Section
              _buildSectionHeader('GÖRÜNÜM'),
              _buildGroupedContainer(
                context,
                isDark,
                children: [
                  _buildSettingsRow(
                    context,
                    icon: CupertinoIcons.paintbrush,
                    iconBgColor: Colors.deepPurple,
                    title: 'Tema Ayarı',
                    trailing: _buildChevronRow(context),
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => const _ThemeSettingsPage(),
                        ),
                      );
                    },
                  ),
                  _buildDivider(isDark),
                  _buildSettingsRow(
                    context,
                    icon: CupertinoIcons.resize,
                    iconBgColor: Colors.teal,
                    title: 'Görünüm Ölçeği',
                    trailing: _buildChevronRow(context),
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => const _ScaleSettingsPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // YÖNETİM Section
              _buildSectionHeader('YÖNETİM'),
              _buildGroupedContainer(
                context,
                isDark,
                children: [
                  _buildSettingsRow(
                    context,
                    icon: CupertinoIcons.photo,
                    iconBgColor: Colors.orange,
                    title: 'Görsel Yönetimi',
                    trailing: _buildChevronRow(context),
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => const _ImageManagementPage(),
                        ),
                      );
                    },
                  ),
                  _buildDivider(isDark),
                  _buildSettingsRow(
                    context,
                    icon: CupertinoIcons.music_note,
                    iconBgColor: Colors.red,
                    title: 'Ses Yönetimi',
                    trailing: _buildChevronRow(context),
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => const _AudioManagementPage(),
                        ),
                      );
                    },
                  ),
                  _buildDivider(isDark),
                  _buildSettingsRow(
                    context,
                    icon: CupertinoIcons.doc_text,
                    iconBgColor: Colors.blue,
                    title: 'İçerik Yönetimi',
                    trailing: _buildChevronRow(context),
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => const _ContentManagementPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // HESAP Section
              _buildSectionHeader('HESAP'),
              _buildGroupedContainer(
                context,
                isDark,
                children: [
                  _buildSettingsRow(
                    context,
                    icon: CupertinoIcons.lock_open,
                    iconBgColor: Colors.grey,
                    title: 'Oturumu Kapat',
                    trailing: _buildChevronRow(context),
                    onTap: () async {
                      final authService = AuthService();
                      await authService.init();
                      await authService.setRememberMe(false);
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 6, top: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildGroupedContainer(
    BuildContext context,
    bool isDark, {
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsRow(
    BuildContext context, {
    required IconData icon,
    required Color iconBgColor,
    required String title,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Icon(icon, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
            trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildChevronRow(BuildContext context) {
    return const Icon(
      CupertinoIcons.chevron_right,
      size: 16,
      color: Colors.grey,
    );
  }

  Widget _buildDivider(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 60),
      child: Divider(
        height: 1,
        color: isDark ? Colors.white12 : Colors.grey.shade200,
      ),
    );
  }
}

// ─── THEME SETTINGS PAGE ────────────────────────────────────────────────────

class _ThemeSettingsPage extends StatelessWidget {
  const _ThemeSettingsPage();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F7);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Tema Ayarı'),
        centerTitle: true,
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            children: [
              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: const Icon(
                          CupertinoIcons.moon_fill,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Text(
                          'Karanlık Mod',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      CupertinoSwitch(
                        value: appState.isDarkMode,
                        activeTrackColor: Theme.of(context).colorScheme.primary,
                        onChanged: (val) {
                          appState.toggleTheme();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─── SCALE SETTINGS PAGE ────────────────────────────────────────────────────

class _ScaleSettingsPage extends StatelessWidget {
  const _ScaleSettingsPage();

  @override
  Widget build(BuildContext context) {
    final isDark   = Theme.of(context).brightness == Brightness.dark;
    final bgColor  = isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F7);
    final cardColor = isDark ? const Color(0xFF2C2C2E) : Colors.white;

    final options = [
      (AppScaleMode.auto,   'Otomatik', 'Cihaz boyutuna göre en uygun ölçek',       CupertinoIcons.sparkles),
      (AppScaleMode.small,  'Küçük',    'Daha fazla içerik, daha küçük elemanlar',   CupertinoIcons.minus_circle),
      (AppScaleMode.medium, 'Orta',     'Dengeli görünüm',                           CupertinoIcons.circle),
      (AppScaleMode.large,  'Büyük',    'Daha az içerik, daha büyük elemanlar',      CupertinoIcons.plus_circle),
    ];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Görünüm Ölçeği'),
        centerTitle: true,
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            children: [
              // Açıklama
              Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 8),
                child: Text(
                  'Tüm ekranlar seçilen ölçeğe göre yeniden hesaplanır.',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: options.asMap().entries.map((entry) {
                    final i       = entry.key;
                    final mode    = entry.value.$1;
                    final label   = entry.value.$2;
                    final desc    = entry.value.$3;
                    final iconDt  = entry.value.$4;
                    final selected = appState.scaleMode == mode;

                    return Column(
                      children: [
                        if (i > 0)
                          Padding(
                            padding: const EdgeInsets.only(left: 60),
                            child: Divider(
                              height: 1,
                              color: isDark
                                  ? Colors.white12
                                  : Colors.grey.shade200,
                            ),
                          ),
                        InkWell(
                          onTap: () => appState.setScaleMode(mode),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.teal,
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: Icon(
                                    iconDt,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        label,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: selected
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                        ),
                                      ),
                                      Text(
                                        desc,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (selected)
                                  Icon(
                                    CupertinoIcons.checkmark_alt,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    size: 20,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─── IMAGE MANAGEMENT PAGE ──────────────────────────────────────────────────
class _ImageManagementPage extends StatelessWidget {
  const _ImageManagementPage();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F7);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Görsel Yönetimi'),
        centerTitle: true,
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            children: [
              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ...appState.scientists.asMap().entries.map((entry) {
                      final index = entry.key;
                      final scientist = entry.value;
                      return Column(
                        children: [
                          if (index > 0)
                            Padding(
                              padding: const EdgeInsets.only(left: 60),
                              child: Divider(
                                height: 1,
                                color: isDark
                                    ? Colors.white12
                                    : Colors.grey.shade200,
                              ),
                            ),
                          InkWell(
                            onTap: () =>
                                _pickAndCropImage(context, appState, scientist),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: SizedBox(
                                      width: 44,
                                      height: 44,
                                      child: _buildImageWidget(
                                        scientist.imagePath,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          scientist.name,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                          'Görseli değiştir',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    CupertinoIcons.camera,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    CupertinoIcons.chevron_right,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildImageWidget(String path) {
    if (path.startsWith('http')) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, e, s) => const Icon(Icons.person),
      );
    } else {
      return Image.file(
        File(path),
        fit: BoxFit.cover,
        errorBuilder: (_, e, s) => const Icon(Icons.person),
      );
    }
  }

  Future<void> _pickAndCropImage(
    BuildContext context,
    AppState appState,
    Scientist scientist,
  ) async {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: '${scientist.name} - Fotoğraf Düzenle',
            toolbarColor: primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9,
              CropAspectRatioPreset.original,
            ],
          ),
          IOSUiSettings(
            title: '${scientist.name} - Fotoğraf Düzenle',
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9,
              CropAspectRatioPreset.original,
            ],
          ),
        ],
      );

      if (croppedFile != null) {
        appState.updateScientistImage(scientist.id, croppedFile.path);
      }
    } catch (e) {
      // Crop başarısız olursa orijinal dosyayı kullan
      debugPrint('Image crop failed: $e');
      appState.updateScientistImage(scientist.id, pickedFile.path);
    }
  }
}

// ─── AUDIO MANAGEMENT PAGE ──────────────────────────────────────────────────

class _AudioManagementPage extends StatelessWidget {
  const _AudioManagementPage();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F7);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Ses Yönetimi'),
        centerTitle: true,
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            children: [
              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ...appState.scientists.asMap().entries.map((entry) {
                      final index = entry.key;
                      final scientist = entry.value;
                      final hasAudio =
                          scientist.audioUrl != null &&
                          scientist.audioUrl!.isNotEmpty;
                      return Column(
                        children: [
                          if (index > 0)
                            Padding(
                              padding: const EdgeInsets.only(left: 60),
                              child: Divider(
                                height: 1,
                                color: isDark
                                    ? Colors.white12
                                    : Colors.grey.shade200,
                              ),
                            ),
                          InkWell(
                            onTap: () =>
                                _pickAudioFile(context, appState, scientist),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: hasAudio
                                          ? Colors.green
                                          : Colors.grey,
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    child: Icon(
                                      hasAudio
                                          ? CupertinoIcons.speaker_2_fill
                                          : CupertinoIcons.speaker_slash,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          scientist.name,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                          hasAudio
                                              ? 'Ses dosyası mevcut'
                                              : 'Ses dosyası ekle',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (hasAudio)
                                    IconButton(
                                      icon: const Icon(
                                        CupertinoIcons.delete,
                                        color: Colors.red,
                                        size: 18,
                                      ),
                                      onPressed: () {
                                        appState.updateScientistAudio(
                                          scientist.id,
                                          null,
                                        );
                                      },
                                    ),
                                  const Icon(
                                    CupertinoIcons.chevron_right,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _pickAudioFile(
    BuildContext context,
    AppState appState,
    Scientist scientist,
  ) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );
    if (result != null && result.files.single.path != null) {
      appState.updateScientistAudio(scientist.id, result.files.single.path);
    }
  }
}

// ─── CONTENT MANAGEMENT PAGE ────────────────────────────────────────────────

class _ContentManagementPage extends StatelessWidget {
  const _ContentManagementPage();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F7);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('İçerik Yönetimi'),
        centerTitle: true,
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            children: [
              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ...appState.scientists.asMap().entries.map((entry) {
                      final index = entry.key;
                      final scientist = entry.value;
                      return Column(
                        children: [
                          if (index > 0)
                            Padding(
                              padding: const EdgeInsets.only(left: 60),
                              child: Divider(
                                height: 1,
                                color: isDark
                                    ? Colors.white12
                                    : Colors.grey.shade200,
                              ),
                            ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (_) => _ScientistContentPage(
                                    scientist: scientist,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    child: const Icon(
                                      CupertinoIcons.person,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Text(
                                      scientist.name,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  const Icon(
                                    CupertinoIcons.chevron_right,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─── SINGLE SCIENTIST CONTENT EDIT PAGE ─────────────────────────────────────

class _ScientistContentPage extends StatefulWidget {
  final Scientist scientist;
  const _ScientistContentPage({required this.scientist});

  @override
  State<_ScientistContentPage> createState() => _ScientistContentPageState();
}

class _ScientistContentPageState extends State<_ScientistContentPage> {
  late TextEditingController _aboutController;

  @override
  void initState() {
    super.initState();
    _aboutController = TextEditingController(text: widget.scientist.about);
  }

  @override
  void dispose() {
    _aboutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F7);
    final cardColor = isDark ? const Color(0xFF2C2C2E) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.scientist.name),
        centerTitle: true,
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          final scientist = appState.scientists.firstWhere(
            (s) => s.id == widget.scientist.id,
            orElse: () => widget.scientist,
          );

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            children: [
              // HAKKINDA Section
              Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 6),
                child: Text(
                  'HAKKINDA',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _aboutController,
                      maxLines: 5,
                      maxLength: 2000,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: 'Hakkında bilgisini giriniz...',
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: CupertinoButton.filled(
                        onPressed: () {
                          appState.updateScientistAbout(
                            widget.scientist.id,
                            _aboutController.text,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Hakkında bilgisi kaydedildi'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        child: const Text('Kaydet'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ESERLERİ Section
              Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 6),
                child: Row(
                  children: [
                    Text(
                      'ESERLERİ',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const Spacer(),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(24, 24),
                      child: const Icon(CupertinoIcons.add_circled, size: 22),
                      onPressed: () => _showAddWorkDialog(context, appState),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    if (scientist.works.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(24),
                        child: Text('Henüz eser eklenmemiş.'),
                      )
                    else
                      ...scientist.works.asMap().entries.map((entry) {
                        final i = entry.key;
                        final work = entry.value;
                        return Column(
                          children: [
                            if (i > 0)
                              Padding(
                                padding: const EdgeInsets.only(left: 60),
                                child: Divider(
                                  height: 1,
                                  color: isDark
                                      ? Colors.white12
                                      : Colors.grey.shade200,
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              child: Row(
                                children: [
                                  const Icon(CupertinoIcons.book, size: 18),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Text(
                                      work,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      CupertinoIcons.pencil,
                                      size: 18,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () => _showEditWorkDialog(
                                      context,
                                      appState,
                                      i,
                                      work,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      CupertinoIcons.delete,
                                      size: 18,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      final newWorks = List<String>.from(
                                        scientist.works,
                                      );
                                      newWorks.removeAt(i);
                                      appState.updateScientistWorks(
                                        widget.scientist.id,
                                        newWorks,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAddWorkDialog(BuildContext context, AppState appState) {
    String newWork = '';
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text('Yeni Eser Ekle'),
        content: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: CupertinoTextField(
            autofocus: true,
            placeholder: 'Eser adı',
            onChanged: (val) => newWork = val,
          ),
        ),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          CupertinoDialogAction(
            onPressed: () {
              if (newWork.isNotEmpty) {
                final scientist = appState.scientists.firstWhere(
                  (s) => s.id == widget.scientist.id,
                );
                final newWorks = List<String>.from(scientist.works)
                  ..add(newWork);
                appState.updateScientistWorks(widget.scientist.id, newWorks);
              }
              Navigator.pop(context);
            },
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
  }

  void _showEditWorkDialog(
    BuildContext context,
    AppState appState,
    int index,
    String oldWork,
  ) {
    String editWork = oldWork;
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text('Eseri Düzenle'),
        content: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: CupertinoTextField(
            autofocus: true,
            controller: TextEditingController(text: editWork),
            onChanged: (val) => editWork = val,
          ),
        ),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          CupertinoDialogAction(
            onPressed: () {
              if (editWork.isNotEmpty) {
                final scientist = appState.scientists.firstWhere(
                  (s) => s.id == widget.scientist.id,
                );
                final newWorks = List<String>.from(scientist.works);
                newWorks[index] = editWork;
                appState.updateScientistWorks(widget.scientist.id, newWorks);
              }
              Navigator.pop(context);
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }
}
