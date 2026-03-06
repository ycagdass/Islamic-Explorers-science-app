import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AuthService {
  static const String _dbName = 'auth.db';
  static const String _tableName = 'auth_data';
  Database? _db;

  Future<void> init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName(
            id INTEGER PRIMARY KEY,
            rememberMe INTEGER
          )
        ''');
        await db.insert(_tableName, {'id': 1, 'rememberMe': 0});
      },
    );
  }

  Future<bool> getRememberMe() async {
    if (_db == null) await init();
    final List<Map<String, dynamic>> maps = await _db!.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [1],
    );
    if (maps.isNotEmpty) {
      return (maps.first['rememberMe'] as int) == 1;
    }
    return false;
  }

  Future<void> setRememberMe(bool value) async {
    if (_db == null) await init();
    await _db!.update(
      _tableName,
      {'rememberMe': value ? 1 : 0},
      where: 'id = ?',
      whereArgs: [1],
    );
  }

  bool verifyPassword(String password) {
    return password == '1881';
  }
}
