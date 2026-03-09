import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/scientist.dart';
import '../utils/responsive_helper.dart';

class StorageService {
  static const String _themeKey = 'isDarkMode';
  static const String _scientistsKey = 'scientistsData';
  static const String _scaleModeKey = 'appScaleMode';
  static const String _hasSeenOnboarding = 'hasSeenOnboarding';
  static const String _dataVersionKey = 'dataVersion';
  // Versiyon numarasını artırınca uygulama varsayılan bilim insanı
  // içeriklerini yeniden yükler (kullanıcı özelleştirmeleri korunmaz).
  static const int _currentDataVersion = 2;

  // Cached instance — SharedPreferences.getInstance() is called only once.
  SharedPreferences? _prefs;

  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// Loads theme, scientists and scaleMode in a single SharedPreferences access.
  Future<
    ({
      bool isDark,
      List<Scientist>? scientists,
      AppScaleMode scaleMode,
      bool hasSeenOnboarding,
    })
  >
  loadAll() async {
    final prefs = await _getPrefs();
    final isDark = prefs.getBool(_themeKey) ?? false;

    // Scale mode
    final scaleModeStr = prefs.getString(_scaleModeKey) ?? 'auto';
    final scaleMode = _scaleModeFromString(scaleModeStr);

    // Has seen onboarding
    final seenOnboarding = prefs.getBool(_hasSeenOnboarding) ?? false;

    // Scientists
    final storedVersion = prefs.getInt(_dataVersionKey) ?? 0;
    final data = (storedVersion >= _currentDataVersion)
        ? prefs.getString(_scientistsKey)
        : null; // Sürüm güncel değilse varsayılan verileri yükle
    if (data == null) {
      return (
        isDark: isDark,
        scientists: null,
        scaleMode: scaleMode,
        hasSeenOnboarding: seenOnboarding,
      );
    }
    final List<dynamic> jsonList = json.decode(data);
    final scientists = jsonList
        .map((j) => Scientist.fromJson(j as Map<String, dynamic>))
        .toList();
    return (
      isDark: isDark,
      scientists: scientists,
      scaleMode: scaleMode,
      hasSeenOnboarding: seenOnboarding,
    );
  }

  Future<void> saveTheme(bool isDark) async {
    final prefs = await _getPrefs();
    await prefs.setBool(_themeKey, isDark);
  }

  Future<bool> getTheme() async {
    final prefs = await _getPrefs();
    return prefs.getBool(_themeKey) ?? false;
  }

  Future<void> saveScaleMode(AppScaleMode mode) async {
    final prefs = await _getPrefs();
    await prefs.setString(_scaleModeKey, _scaleModeToString(mode));
  }

  Future<AppScaleMode> getScaleMode() async {
    final prefs = await _getPrefs();
    final str = prefs.getString(_scaleModeKey) ?? 'auto';
    return _scaleModeFromString(str);
  }

  Future<void> saveScientists(List<Scientist> scientists) async {
    final prefs = await _getPrefs();
    final String encoded = json.encode(
      scientists.map((s) => s.toJson()).toList(),
    );
    await prefs.setString(_scientistsKey, encoded);
    await prefs.setInt(_dataVersionKey, _currentDataVersion);
  }

  Future<List<Scientist>?> getScientists() async {
    final prefs = await _getPrefs();
    final String? data = prefs.getString(_scientistsKey);
    if (data == null) return null;
    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((jsonItem) => Scientist.fromJson(jsonItem)).toList();
  }

  Future<void> setHasSeenOnboarding(bool value) async {
    final prefs = await _getPrefs();
    await prefs.setBool(_hasSeenOnboarding, value);
  }

  // ─ Yardımcılar ─────────────────────────────────────────────────────────────

  static String _scaleModeToString(AppScaleMode mode) {
    switch (mode) {
      case AppScaleMode.auto:
        return 'auto';
      case AppScaleMode.small:
        return 'small';
      case AppScaleMode.medium:
        return 'medium';
      case AppScaleMode.large:
        return 'large';
    }
  }

  static AppScaleMode _scaleModeFromString(String s) {
    switch (s) {
      case 'small':
        return AppScaleMode.small;
      case 'medium':
        return AppScaleMode.medium;
      case 'large':
        return AppScaleMode.large;
      default:
        return AppScaleMode.auto;
    }
  }
}
