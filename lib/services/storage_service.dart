import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/scientist.dart';

class StorageService {
  static const String _themeKey = 'isDarkMode';
  static const String _scientistsKey = 'scientistsData';

  Future<void> saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDark);
  }

  Future<bool> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false;
  }

  Future<void> saveScientists(List<Scientist> scientists) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(
      scientists.map((s) => s.toJson()).toList(),
    );
    await prefs.setString(_scientistsKey, encoded);
  }

  Future<List<Scientist>?> getScientists() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_scientistsKey);
    if (data == null) return null;

    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((jsonItem) => Scientist.fromJson(jsonItem)).toList();
  }
}
