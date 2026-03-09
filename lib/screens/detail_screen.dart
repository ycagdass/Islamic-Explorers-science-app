import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:io';

import '../models/scientist.dart';
import '../providers/app_state.dart';
import '../services/audio_service.dart';
import '../utils/responsive_helper.dart';
import '../widgets/scientist_background.dart';

class DetailScreen extends StatefulWidget {
  final Scientist scientist;

  const DetailScreen({super.key, required this.scientist});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with WidgetsBindingObserver {
  final AudioService _audioService = AudioService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.scientist.audioUrl != null &&
        widget.scientist.audioUrl!.isNotEmpty) {
      _audioService.initAudio(widget.scientist.audioUrl!).then((_) {
        if (mounted) _audioService.play();
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _audioService.pause();
    _audioService.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _audioService.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    final scaleMode = context.select<AppState, AppScaleMode>(
      (s) => s.scaleMode,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.scientist.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ScientistBackground(
          scientistName: widget.scientist.name,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final scale = ResponsiveHelper.compute(context, scaleMode);
              final isPhone = scale.screenType == ScreenType.phone;

              if (isPhone) {
                // ── PHONE: Dikey tek sütun ──────────────────────────────────
                return SingleChildScrollView(
                  padding: scale.pagePadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildPhotoSection(scale: scale),
                      const SizedBox(height: 16),
                      _buildAudioPlayer(scale: scale),
                      const SizedBox(height: 20),
                      _buildAboutSection(scale: scale, isMobile: true),
                      const SizedBox(height: 16),
                      _buildWorksSection(scale: scale, isMobile: true),
                      const SizedBox(height: 16),
                    ],
                  ),
                );
              } else {
                // ── TABLET: İki sütun ────────────────────────────────────────
                // Sol: fotoğraf + isim + kısa bilgi
                // Sağ: hakkında + eserleri + ses oynatıcı
                return Padding(
                  padding: scale.pagePadding,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sol kolon
                      SizedBox(
                        width:
                            constraints.maxWidth * scale.detailLeftWidthRatio,
                        child: SingleChildScrollView(
                          child: _buildPhotoSection(scale: scale),
                        ),
                      ),
                      SizedBox(width: scale.cardSpacing),
                      // Sağ kolon: hakkında + eserleri + ses oynatıcı
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              flex: 3,
                              child: _buildAboutSection(
                                scale: scale,
                                isMobile: false,
                              ),
                            ),
                            SizedBox(height: scale.cardRunSpacing),
                            Expanded(
                              flex: 2,
                              child: _buildWorksSection(
                                scale: scale,
                                isMobile: false,
                              ),
                            ),
                            SizedBox(height: scale.cardRunSpacing),
                            // Ses oynatıcı sağ kolonda altta
                            _buildAudioPlayer(scale: scale),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  // ── Fotoğraf + isim + unvan bölümü ─────────────────────────────────────────
  Widget _buildPhotoSection({required AppScale scale}) {
    final imageSize = scale.detailImageSize;
    final primary = Theme.of(context).colorScheme.primary;

    return Column(
      children: [
        // Dekoratif halkalar + fotoğraf
        SizedBox(
          width: imageSize + 24,
          height: imageSize + 24,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: imageSize + 22,
                height: imageSize + 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: primary.withValues(alpha: 0.25),
                    width: 1.5,
                  ),
                ),
              ),
              Container(
                width: imageSize + 10,
                height: imageSize + 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: primary.withValues(alpha: 0.45),
                    width: 2.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primary.withValues(alpha: 0.18),
                      blurRadius: 24,
                      spreadRadius: 3,
                    ),
                  ],
                ),
              ),
              Container(
                width: imageSize,
                height: imageSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: primary.withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                      spreadRadius: 2,
                    ),
                    const BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                  border: Border.all(color: primary, width: 3.0),
                  image: _getImageDecoration(widget.scientist.imagePath),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: scale.cardRunSpacing),
        Text(
          widget.scientist.name,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: (scale.titleFontSize * 1.3).clamp(16.0, 28.0),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          widget.scientist.title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w600,
            fontSize: (scale.cardTitleFontSize * 1.1).clamp(12.0, 18.0),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // ── Ses oynatıcı ─────────────────────────────────────────────────────────────
  Widget _buildAudioPlayer({required AppScale scale}) {
    return Card(
      elevation: 6,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(scale.cardSpacing * 0.6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.headset,
                  color: Theme.of(context).colorScheme.primary,
                  size: scale.iconSize,
                ),
                const SizedBox(width: 8),
                Text(
                  "Sesli Anlatım",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: scale.cardTitleFontSize,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            StreamBuilder<PlayerState>(
              stream: _audioService.player.playerStateStream,
              builder: (context, snapshot) {
                final playing = snapshot.data?.playing ?? false;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.1),
                      ),
                      child: IconButton(
                        icon: Icon(
                          playing
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                        ),
                        iconSize: scale.iconSize * 1.8,
                        color: Theme.of(context).colorScheme.primary,
                        onPressed: () {
                          if (playing) {
                            _audioService.pause();
                          } else {
                            _audioService.play();
                          }
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
            StreamBuilder<Duration>(
              stream: _audioService.player.positionStream,
              builder: (context, snapshot) {
                final duration = _audioService.player.duration ?? Duration.zero;
                final position = snapshot.data ?? Duration.zero;
                return SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Theme.of(context).colorScheme.primary,
                    inactiveTrackColor: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.2),
                    thumbColor: Theme.of(context).colorScheme.primary,
                    trackHeight: 4.0,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 6.0,
                    ),
                  ),
                  child: Slider(
                    value: position.inMilliseconds.toDouble().clamp(
                      0.0,
                      duration.inMilliseconds.toDouble() > 0
                          ? duration.inMilliseconds.toDouble()
                          : 0.0,
                    ),
                    max: duration.inMilliseconds.toDouble() > 0
                        ? duration.inMilliseconds.toDouble()
                        : 1.0,
                    onChanged: (val) {
                      _audioService.player.seek(
                        Duration(milliseconds: val.toInt()),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ── Hakkında bölümü ──────────────────────────────────────────────────────────
  Widget _buildAboutSection({required AppScale scale, required bool isMobile}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(scale.cardSpacing * 0.8),
        child: isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionHeader(
                    context,
                    Icons.info_outline,
                    'Hakkında',
                    scale,
                  ),
                  const Divider(height: 20),
                  Text(
                    widget.scientist.about,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.6,
                      fontSize: scale.cardTitleFontSize,
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionHeader(
                    context,
                    Icons.info_outline,
                    'Hakkında',
                    scale,
                  ),
                  const Divider(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        widget.scientist.about,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.6,
                          fontSize: scale.cardTitleFontSize,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // ── Eserleri bölümü ──────────────────────────────────────────────────────────
  Widget _buildWorksSection({required AppScale scale, required bool isMobile}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(scale.cardSpacing * 0.8),
        child: isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionHeader(
                    context,
                    Icons.menu_book_rounded,
                    'Eserleri',
                    scale,
                  ),
                  const Divider(height: 20),
                  Consumer<AppState>(
                    builder: (context, appState, child) {
                      final s = appState.scientists.firstWhere(
                        (x) => x.id == widget.scientist.id,
                        orElse: () => widget.scientist,
                      );
                      if (s.works.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(12),
                          child: Text("Henüz eser eklenmemiş."),
                        );
                      }
                      return Column(
                        children: s.works
                            .map((w) => _buildWorkItem(w, scale))
                            .toList(),
                      );
                    },
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionHeader(
                    context,
                    Icons.menu_book_rounded,
                    'Eserleri',
                    scale,
                  ),
                  const Divider(height: 20),
                  Expanded(
                    child: Consumer<AppState>(
                      builder: (context, appState, child) {
                        final s = appState.scientists.firstWhere(
                          (x) => x.id == widget.scientist.id,
                          orElse: () => widget.scientist,
                        );
                        if (s.works.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(12),
                            child: Text("Henüz eser eklenmemiş."),
                          );
                        }
                        return ListView(
                          children: s.works
                              .map((w) => _buildWorkItem(w, scale))
                              .toList(),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _sectionHeader(
    BuildContext context,
    IconData icon,
    String title,
    AppScale scale,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: scale.iconSize,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: scale.titleFontSize,
          ),
        ),
      ],
    );
  }

  Widget _buildWorkItem(String work, AppScale scale) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5),
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              work,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: scale.cardTitleFontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }

  DecorationImage _getImageDecoration(String path) {
    if (path.startsWith('http')) {
      return DecorationImage(image: NetworkImage(path), fit: BoxFit.cover);
    } else {
      return DecorationImage(image: FileImage(File(path)), fit: BoxFit.cover);
    }
  }
}
