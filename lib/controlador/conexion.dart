import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Conexion {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _openDB();
    return _database!;
  }

  static Future<Database> _openDB() async {
    return openDatabase(join(await getDatabasesPath(), "practica1.db"),
        onCreate: (db, version) {
      return script(db);
    }, version: 1);
  }

  static Future<void> script(Database db) async {
    await db.execute('''
      CREATE TABLE MATERIA(
        IDMATERIA TEXT PRIMARY KEY,
        NOMBRE TEXT,
        SEMESTRE TEXT,
        DOCENTE TEXT
      );
    ''');
    await db.execute('''
      CREATE TABLE TAREA(
        IDTAREA INTEGER PRIMARY KEY AUTOINCREMENT,
        IDMATERIA TEXT,
        F_ENTREGA TEXT,
        DESCRIPCION TEXT,
        FOREIGN KEY(IDMATERIA) REFERENCES MATERIA(IDMATERIA)
      );
    ''');
  }
}
