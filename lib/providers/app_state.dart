import 'package:flutter/material.dart';
import '../models/scientist.dart';
import '../services/storage_service.dart';
import '../utils/responsive_helper.dart';

class AppState extends ChangeNotifier {
  final StorageService _storageService = StorageService();

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  List<Scientist> _scientists = [];
  List<Scientist> get scientists => _scientists;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  AppScaleMode _scaleMode = AppScaleMode.auto;
  AppScaleMode get scaleMode => _scaleMode;

  Future<void> init() async {
    // Single SharedPreferences access — loads theme, scientists and scaleMode.
    final loaded = await _storageService.loadAll();
    _isDarkMode = loaded.isDark;
    _scaleMode  = loaded.scaleMode;

    if (loaded.scientists != null && loaded.scientists!.isNotEmpty) {
      _scientists = loaded.scientists!;
    } else {
      _loadDefaultScientists();
      // Fire-and-forget — no need to block startup waiting for the initial save.
      _saveScientists();
    }
    _isLoading = false;
    notifyListeners();
  }

  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    await _storageService.saveTheme(_isDarkMode);
  }

  /// Görünüm ölçeğini değiştirir ve kalıcı olarak kaydeder.
  Future<void> setScaleMode(AppScaleMode mode) async {
    if (_scaleMode == mode) return;
    _scaleMode = mode;
    notifyListeners();
    await _storageService.saveScaleMode(mode);
  }

  Future<void> _saveScientists() async {
    await _storageService.saveScientists(_scientists);
  }

  void updateScientistAbout(String id, String newAbout) {
    final index = _scientists.indexWhere((s) => s.id == id);
    if (index != -1) {
      _scientists[index].about = newAbout;
      notifyListeners();
      _saveScientists();
    }
  }

  void updateScientistWorks(String id, List<String> newWorks) {
    final index = _scientists.indexWhere((s) => s.id == id);
    if (index != -1) {
      _scientists[index].works = newWorks;
      notifyListeners();
      _saveScientists();
    }
  }

  void updateScientistImage(String id, String imagePath) {
    final index = _scientists.indexWhere((s) => s.id == id);
    if (index != -1) {
      _scientists[index].imagePath = imagePath;
      notifyListeners();
      _saveScientists();
    }
  }

  void updateScientistAudio(String id, String? audioPath) {
    final index = _scientists.indexWhere((s) => s.id == id);
    if (index != -1) {
      _scientists[index].audioUrl = audioPath;
      notifyListeners();
      _saveScientists();
    }
  }

  void _loadDefaultScientists() {
    _scientists = [
      Scientist(
        id: '1',
        name: 'Harezmi',
        title: 'Matematik & Astronomi',
        imagePath:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuB78_Vd2fCXQkWh1b8irNWV7-JRrDcCi4A51pT93izgLpFkSexRieHyGRVngWvHaiTfM2Bcd7OrelZpGF6SNiPvl6x6juHGmWasLAFKWQllE9nYnmJ0gQ8mO67g8qBkInEUxRQmP7S4DHXq6YEjis-WPbaFXkAF_bU-PfzbVulv46vi1VjnFJPvtRfw4A4Qt_emRANWQEBY_aU6BUnPQ_ThulirtY2Q4RwEt28uf8wtH4WTuSSxNezZQE2_PNeHXsF-ChO3mTUyDnU',
        about:
            'Cebir ve algoritmanın kurucusu olarak bilinen matematik, astronomi ve coğrafya bilgini.',
        works: ['El-Harezmi Cebir Risalesi', 'Zic-ül Harezmi'],
        audioUrl:
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      ),
      Scientist(
        id: '2',
        name: 'Ali Kuşçu',
        title: 'Gökbilimci',
        imagePath:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBrG6JadobqjjdE49zz0B09w4Dr3w3oR1bihLlDA0QgRhQRgbo74byeKLTT1dNuw3wWgFKFyzOu90x85S-Fgoxf3GtwuMNEaAuiZLskcjc5ZTPabGSsuhfs_87-XpvQn59mG2vdbFPV9KsZ3feHaIjhJ61TDEm5f8ixntGn1LOuBF3HgHBoFMecKKQoG6d_PpSVt8zkhxqW5fA1MqrZT5QAK10Ajx9oGg8zz2amAAWTusbYllcxB4ES1zRTIeTxNSfABdymji2AM-M',
        about:
            'Osmanlı devrinde yetişmiş önemli bir kelâm, mantık, dil ve astronomi bilgini.',
        works: ['Fethiyye', 'Risale fi\'l-Hey\'e'],
        audioUrl:
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
      ),
      Scientist(
        id: '3',
        name: 'İbn-i Sina',
        title: 'Tıp & Felsefe',
        imagePath:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBhpC2RzktxKdcP4DYvbSYkX3S7VIMi5DNqaPZZ8Jkr3p5wYkEU5E9SfXIfn0iWHHp0jOQrc4mKTpARKbEWtwwiYxN3CEUvTRf6zmVjMiWCXdWWD4Hs5QPT52RGXV6teeI9913ZCzxBwxxLKm-UolEMDyh2kfK_lvn2OcRdCmx7SxM1a-qh8i84TovVYcmRz50lK0hzBt2iuShGDAaqriH8-fXkVcWdgn2-GklTxvQFpJjIfc5V5RZNrh-gA2uId-NjYJFTuz5GGs8',
        about:
            'Küçük yaşta tıp eğitimi almış ve El-Kanun fi\'t-Tıb adlı ünlü eserini yazmış hekim ve düşünür.',
        works: ['El-Kanun fi\'t-Tıb', 'Kitabü\'ş-Şifa'],
        audioUrl:
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
      ),
      Scientist(
        id: '4',
        name: 'Uluğ Bey',
        title: 'Gökbilimci & Sultan',
        imagePath:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuDc8_kWeX8gYZe-K_f0JyqhctToIBrg7xa0Nftc3ocwTp6GS64cXckBX7YNG1TMeMOB014I5-CmexIo4n9b79lJ9qWLlLC4mbeHd6hYA4FLioJ30rXapo08nY5JFI_cFNpIL17nDrsTjIqJ2QkKCU2LyzCLjYd4dYptB9-Mj5Z3Tcco3dcfry2TuXqhfUcyFtkUEyp1EUpYnjm-xLKBHvi4d5dPxfNU56mzVzZyZd2-R2xmfziyxTRmzTsD2VyJvbagZEUYf18ei6E',
        about:
            'Büyük bir astronomi bilgini olup Semerkant Rasathanesini ve Medresesini kurmuştur.',
        works: ['Zic-i Uluğ Bey'],
        audioUrl:
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
      ),
      Scientist(
        id: '5',
        name: 'Cahit Arf',
        title: 'Matematikçi',
        imagePath:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBqdstcJ0zRB0Beb8ucVpkdSeHmRstgq5V2U5mJeqxDyrPm1JcGjQ-AwMwc1wGPLYvPaqXMj9WZh18ISLKRYY-ThbjXCLme_cMlzEAbCz5Y96o7GKZRh5Lr4zKKs7ZjW-jkCGY4DKcusiAufK8UA_hXL1XkbMh6WpN1xR4pYqkEFU6vSCLTWPMkRmZZxo6syWMgARAROB2b67rJ9MZ9fSX6-eFFm9xy30Xp5jK0JJ6EFhMNkx9Sab30stq3EDBq-ZeGBPVJ25Tz7z0',
        about:
            'Arf değişmezi, Arf halkaları ve Arf kapanışları gibi matematik dünyasına büyük katkıları olan dahi matematikçi.',
        works: ['Arf Değişmezi Makalesi'],
        audioUrl:
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
      ),
    ];
  }
}
