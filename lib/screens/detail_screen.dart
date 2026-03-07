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
        // Delay playing slightly to allow screen transition
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _audioService.play();
          }
        });
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
              final isMobile = ResponsiveHelper.isMobile(context);

              if (isMobile) {
                // Phone / Small screen layout: Vertically stacked and completely scrollable together
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildLeftColumn(isMobile: true),
                      const SizedBox(height: 24),
                      _buildAboutSection(isMobile: true),
                      const SizedBox(height: 24),
                      _buildWorksSection(isMobile: true),
                    ],
                  ),
                );
              } else {
                // Tablet / Desktop layout: Two columns side-by-side
                final padding = ResponsiveHelper.getPadding(context);
                return Padding(
                  padding: padding,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: constraints.maxWidth * 0.35,
                        child: SingleChildScrollView(
                          child: _buildLeftColumn(isMobile: false),
                        ),
                      ),
                      const SizedBox(width: 32),
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: _buildAboutSection(isMobile: false),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: _buildWorksSection(isMobile: false),
                            ),
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

  Widget _buildLeftColumn({required bool isMobile}) {
    final imageSize = isMobile ? 200.0 : 280.0;
    return Column(
      children: [
        Container(
          width: imageSize,
          height: imageSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              isMobile ? 120 : 16,
            ), // Circle on mobile, rounded rect on tablet
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
            border: isMobile
                ? Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 3,
                  )
                : null,
            image: _getImageDecoration(widget.scientist.imagePath),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          widget.scientist.name,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          widget.scientist.title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        _buildAudioPlayer(),
      ],
    );
  }

  Widget _buildAudioPlayer() {
    return Card(
      elevation: 6,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.headset,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                const Text(
                  "Sesli Anlatım",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
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
                        iconSize: 48,
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

  Widget _buildAboutSection({required bool isMobile}) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              "Hakkında",
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const Divider(height: 24),
        if (isMobile)
          Text(
            widget.scientist.about,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
          )
        else
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                widget.scientist.about,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(height: 1.6),
              ),
            ),
          ),
      ],
    );

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(padding: const EdgeInsets.all(24.0), child: content),
    );
  }

  Widget _buildWorksSection({required bool isMobile}) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.menu_book_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              "Eserleri",
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const Divider(height: 24),
        Consumer<AppState>(
          builder: (context, appState, child) {
            final updatedScientist = appState.scientists.firstWhere(
              (s) => s.id == widget.scientist.id,
              orElse: () => widget.scientist,
            );
            final works = updatedScientist.works;

            if (works.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("Henüz eser eklenmemiş."),
              );
            }

            if (isMobile) {
              return Column(
                children: works.map((work) => _buildWorkItem(work)).toList(),
              );
            } else {
              return Expanded(
                child: ListView.builder(
                  itemCount: works.length,
                  itemBuilder: (context, index) {
                    return _buildWorkItem(works[index]);
                  },
                ),
              );
            }
          },
        ),
      ],
    );

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(padding: const EdgeInsets.all(24.0), child: content),
    );
  }

  Widget _buildWorkItem(String work) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(work, style: Theme.of(context).textTheme.bodyLarge),
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
