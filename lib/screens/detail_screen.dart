import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:io';
import 'dart:ui' show ImageFilter;

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

  static const Map<String, _ScientistMotif> _motifs = {
    'harezmi': _ScientistMotif(
      label: 'Cebir ve Algoritma',
      heroFormula: 'x = (−b ± √Δ) / 2a',
      heroText: '∑∫',
      icon: Icons.calculate_rounded,
      tagline: "Cebir'in ve Algoritma'nın Babası",
      formulas: ['al-jabr', '٠ ١ ٢ ٣', 'ax²+bx+c=0', '∑ n(n+1)/2'],
    ),
    'ali': _ScientistMotif(
      label: 'Astronomi ve Gökbilim',
      heroFormula: 'α · RA · δ  —  Gök Koordinatları',
      heroText: '★✦',
      icon: Icons.explore_rounded,
      tagline: "Osmanlı'nın Büyük Gökbilimcisi",
      formulas: [
        'yörünge analizi',
        'gök koordinatı',
        'yıldız kataloğu',
        'θ = 30°',
      ],
    ),
    'ibn': _ScientistMotif(
      label: 'Tıp ve Tedavi Bilimi',
      heroFormula: "Canon Medicinae  —  El-Kânûn fi't-Tıbb",
      heroText: 'Rx',
      icon: Icons.healing_rounded,
      tagline: 'Tıp İlminin Kurucu Önderi',
      formulas: ['Rx nabız', 'bitkisel tedavi', 'hastalık tanısı', 'الشفاء'],
    ),
    'ulug': _ScientistMotif(
      label: 'Rasathane ve Yıldız Haritası',
      heroFormula: 'Zîc-i Sultânî  —  1018 Yıldız Kataloğu',
      heroText: '°′″',
      icon: Icons.public_rounded,
      tagline: 'Semerkand Rasathanesi Kurucusu',
      formulas: [
        '0° 30° 60° 90°',
        'gök küresi',
        'rasathane',
        'koordinat cetveli',
      ],
    ),
    'arf': _ScientistMotif(
      label: 'Arf İnvariantı ve Topoloji',
      heroFormula: 'Arf(f) ∈ {0,1}',
      heroText: '∈∂',
      icon: Icons.functions_rounded,
      tagline: 'Dünyaca Ünlü Türk Matematikçi',
      formulas: ['ℤ/2ℤ', 'Arf(q)=0', 'H²(M;ℤ/2)', 'q(x+y)−q(x)−q(y)'],
    ),
  };

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
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          widget.scientist.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: cs.surface.withValues(alpha: 0.82),
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: const ColoredBox(color: Colors.transparent),
          ),
        ),
        leading: IconButton(
          style: IconButton.styleFrom(
            backgroundColor: cs.surface.withValues(alpha: 0.45),
          ),
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ScientistBackground(
        scientistName: widget.scientist.name,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final scale = ResponsiveHelper.compute(context, scaleMode);
            final isPhone = scale.screenType == ScreenType.phone;
            final topPad =
                MediaQuery.of(context).padding.top + kToolbarHeight + 8.0;
            final pp = scale.pagePadding;
            final adjustedPad = EdgeInsets.only(
              top: topPad,
              left: pp.left,
              right: pp.right,
              bottom: pp.bottom,
            );

            if (isPhone) {
              // ── PHONE: Dikey tek sütun ──────────────────────────────────
              return SingleChildScrollView(
                padding: adjustedPad,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildPhotoSection(scale: scale),
                    const SizedBox(height: 16),
                    _buildAudioPlayer(scale: scale),
                    const SizedBox(height: 20),
                    _buildAboutSection(
                      scale: scale,
                      isMobile: true,
                      maxContentHeight: 280,
                    ),
                    const SizedBox(height: 16),
                    _buildWorksSection(scale: scale, isMobile: true),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            } else {
              // ── TABLET: İki sütun ────────────────────────────────────────
              return Padding(
                padding: adjustedPad,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: constraints.maxWidth * scale.detailLeftWidthRatio,
                      child: SingleChildScrollView(
                        child: _buildPhotoSection(scale: scale),
                      ),
                    ),
                    SizedBox(width: scale.cardSpacing),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildAboutSection(
                              scale: scale,
                              isMobile: false,
                              maxContentHeight: 360,
                            ),
                            SizedBox(height: scale.cardRunSpacing),
                            _buildWorksSection(
                              scale: scale,
                              isMobile: false,
                              maxContentHeight: 280,
                            ),
                            SizedBox(height: scale.cardRunSpacing),
                            _buildAudioPlayer(scale: scale),
                            SizedBox(height: scale.cardRunSpacing),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
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
        _buildMotifPanel(scale),
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
    final hasAudio =
        widget.scientist.audioUrl != null &&
        widget.scientist.audioUrl!.isNotEmpty;

    return Card(
      elevation: 2,
      shadowColor: Colors.black12.withValues(alpha: 0.30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: scale.cardSpacing * 0.50,
          vertical: scale.cardSpacing * 0.25,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.graphic_eq_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: scale.iconSize * 0.9,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Sesli Anlatım',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: (scale.cardTitleFontSize * 0.96).clamp(
                        12.0,
                        16.0,
                      ),
                    ),
                  ),
                ),
                StreamBuilder<PlayerState>(
                  stream: _audioService.player.playerStateStream,
                  builder: (context, snapshot) {
                    final playing = snapshot.data?.playing ?? false;
                    return FilledButton.tonalIcon(
                      style: FilledButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                      ),
                      onPressed: hasAudio
                          ? () {
                              if (playing) {
                                _audioService.pause();
                              } else {
                                _audioService.play();
                              }
                            }
                          : null,
                      icon: Icon(
                        playing
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                      ),
                      label: Text(playing ? 'Duraklat' : 'Oynat'),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 4),
            StreamBuilder<Duration>(
              stream: _audioService.player.positionStream,
              builder: (context, snapshot) {
                final duration = _audioService.player.duration ?? Duration.zero;
                final position = snapshot.data ?? Duration.zero;
                return Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Theme.of(context).colorScheme.primary,
                        inactiveTrackColor: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.20),
                        thumbColor: Theme.of(context).colorScheme.primary,
                        trackHeight: 3.0,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 5.0,
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
                        onChanged: hasAudio
                            ? (val) {
                                _audioService.player.seek(
                                  Duration(milliseconds: val.toInt()),
                                );
                              }
                            : null,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          _formatDuration(position),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const Spacer(),
                        Text(
                          _formatDuration(duration),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            if (!hasAudio)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'Bu bilim insanı için ses kaydı bulunamadı.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMotifPanel(AppScale scale) {
    final motif = _resolveMotif(widget.scientist.name);
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            cs.primary.withValues(alpha: isDark ? 0.28 : 0.20),
            cs.primary.withValues(alpha: isDark ? 0.14 : 0.10),
            cs.secondary.withValues(alpha: isDark ? 0.12 : 0.08),
          ],
        ),
        border: Border.all(
          color: cs.primary.withValues(alpha: 0.38),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withValues(alpha: 0.14),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _MotifPanelPainter(motif.heroText, cs.primary, isDark),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(scale.cardSpacing * 0.75),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: cs.primary.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: cs.primary.withValues(alpha: 0.30),
                            width: 1.2,
                          ),
                        ),
                        child: Icon(
                          motif.icon,
                          size: scale.iconSize * 0.88,
                          color: cs.primary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              motif.label,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              motif.tagline,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: cs.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: cs.surface.withValues(alpha: 0.58),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: cs.primary.withValues(alpha: 0.28),
                        width: 1.1,
                      ),
                    ),
                    child: Text(
                      motif.heroFormula,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.primary,
                        fontSize: (scale.cardTitleFontSize * 1.0).clamp(
                          11.0,
                          15.0,
                        ),
                        letterSpacing: 0.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: motif.formulas
                        .map(
                          (item) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: cs.surface.withValues(alpha: 0.62),
                              border: Border.all(
                                color: cs.primary.withValues(alpha: 0.22),
                              ),
                            ),
                            child: Text(
                              item,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    fontFamily: 'monospace',
                                    fontWeight: FontWeight.w600,
                                    fontSize:
                                        (scale.cardSubtitleFontSize * 0.95)
                                            .clamp(9.0, 13.0),
                                  ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _ScientistMotif _resolveMotif(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('harezmi')) return _motifs['harezmi']!;
    if (lower.contains('ali ku')) return _motifs['ali']!;
    if (lower.contains('ibn') || lower.contains('sina')) return _motifs['ibn']!;
    if (lower.contains('ulug')) return _motifs['ulug']!;
    if (lower.contains('arf') || lower.contains('cahit')) {
      return _motifs['arf']!;
    }

    return const _ScientistMotif(
      label: 'Bilimsel Tema',
      heroFormula: 'f(x) → bilim ve keşif',
      heroText: 'Δ',
      icon: Icons.science_rounded,
      tagline: 'Bilim ve Araştırma',
      formulas: ['f(x)', 'Δ', 'katalog', 'araştırma notları'],
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final hours = d.inHours;
    if (hours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  // ── Hakkında bölümü ──────────────────────────────────────────────────────────
  Widget _buildAboutSection({
    required AppScale scale,
    required bool isMobile,
    double? maxContentHeight,
  }) {
    final aboutText = Text(
      widget.scientist.about,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        height: 1.6,
        fontSize: scale.cardTitleFontSize,
      ),
    );

    final content = maxContentHeight != null
        ? ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxContentHeight),
            child: SingleChildScrollView(child: aboutText),
          )
        : aboutText;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(scale.cardSpacing * 0.8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _sectionHeader(context, Icons.info_outline, 'Hakkında', scale),
            const Divider(height: 20),
            content,
          ],
        ),
      ),
    );
  }

  // ── Eserleri bölümü ──────────────────────────────────────────────────────────
  Widget _buildWorksSection({
    required AppScale scale,
    required bool isMobile,
    double? maxContentHeight,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(scale.cardSpacing * 0.8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _sectionHeader(context, Icons.menu_book_rounded, 'Eserleri', scale),
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
                    child: Text('Henüz eser eklenmemiş.'),
                  );
                }

                final worksColumn = Column(
                  children: s.works
                      .map((w) => _buildWorkItem(w, scale))
                      .toList(),
                );

                if (maxContentHeight != null) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: maxContentHeight),
                    child: SingleChildScrollView(child: worksColumn),
                  );
                }

                return worksColumn;
              },
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

class _ScientistMotif {
  final String label;
  final List<String> formulas;
  final String heroFormula;
  final String heroText;
  final IconData icon;
  final String tagline;

  const _ScientistMotif({
    required this.label,
    required this.formulas,
    required this.heroFormula,
    required this.heroText,
    required this.icon,
    required this.tagline,
  });
}

// Motif panelinin arka planına dekoratif büyük sembol çizer
class _MotifPanelPainter extends CustomPainter {
  final String text;
  final Color color;
  final bool isDark;

  _MotifPanelPainter(this.text, this.color, this.isDark);

  @override
  void paint(Canvas canvas, Size size) {
    final tp = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: size.height * 0.78,
          color: color.withValues(alpha: isDark ? 0.11 : 0.07),
          fontWeight: FontWeight.w900,
        ),
      ),
    )..layout();
    tp.paint(
      canvas,
      Offset(size.width - tp.width - 10, (size.height - tp.height) / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _MotifPanelPainter old) =>
      old.text != text || old.isDark != isDark;
}
