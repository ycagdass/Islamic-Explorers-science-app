import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();

  AudioPlayer get player => _player;

  Future<void> initAudio(String url) async {
    try {
      await _player.setUrl(url);
    } catch (e) {
      debugPrint("Error loading audio: $e");
    }
  }

  Future<void> play() async {
    if (_player.playing) return;
    await _player.play();
  }

  Future<void> pause() async {
    if (!_player.playing) return;
    await _player.pause();
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
