import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:io';

import '../models/scientist.dart';
import '../providers/app_state.dart';
import '../services/audio_service.dart';

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
        Future.delayed(const Duration(milliseconds: 1500), () {
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
    _audioService.pause(); // Ensure we pause/stop before disposing
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
        title: Text(widget.scientist.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                      image: _getImageDecoration(widget.scientist.imagePath),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    widget.scientist.name,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.scientist.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildAudioPlayer(),
                ],
              ),
            ),
            const SizedBox(width: 32),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Expanded(child: _buildAboutSection()),
                  const SizedBox(height: 16),
                  Expanded(child: _buildWorksSection()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioPlayer() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Icon(Icons.headset, size: 36),
            const SizedBox(height: 8),
            const Text(
              "Sesli Anlatım",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            StreamBuilder<PlayerState>(
              stream: _audioService.player.playerStateStream,
              builder: (context, snapshot) {
                final playing = snapshot.data?.playing ?? false;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(playing ? Icons.pause : Icons.play_arrow),
                      iconSize: 42,
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () {
                        if (playing) {
                          _audioService.pause();
                        } else {
                          _audioService.play();
                        }
                      },
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
                return Slider(
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
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hakkında",
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  widget.scientist.about,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorksSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Eserleri",
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Expanded(
              child: Consumer<AppState>(
                builder: (context, appState, child) {
                  final updatedScientist = appState.scientists.firstWhere(
                    (s) => s.id == widget.scientist.id,
                    orElse: () => widget.scientist,
                  );
                  final works = updatedScientist.works;

                  if (works.isEmpty) {
                    return const Center(child: Text("Henüz eser eklenmemiş."));
                  }

                  return ListView.builder(
                    itemCount: works.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.menu_book),
                        title: Text(works[index]),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
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
