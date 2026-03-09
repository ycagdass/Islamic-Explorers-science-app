import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();

  AudioPlayer get player => _player;

  Future<void> initAudio(String url) async {
    try {
      // Android'de ses odağını düzgün yönetmek için audio session yapılandır
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.speech());

      // Yerel dosya yolu mu yoksa ağ URL'si mi kontrol et
      if (url.startsWith('http://') || url.startsWith('https://')) {
        await _player.setUrl(url);
      } else {
        await _player.setFilePath(url);
      }
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
