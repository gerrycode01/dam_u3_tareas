import 'package:dam_u3_practica2_tarea/controlador/conexion.dart';
import 'package:dam_u3_practica2_tarea/modelo/tarea.dart';

class DBTarea {
  static Future<int> insert(Tarea tarea) async {
    final db = await Conexion.database;
    return db.insert('TAREA', tarea.toJSON());
  }

  static Future<List<Tarea>> readAll() async {
    final db = await Conexion.database;
    List<Map<String, dynamic>> tareas = await db.query('TAREA');
    if (tareas.isNotEmpty) {
      return List.generate(
          tareas.length,
          (index) => Tarea(
              idtarea: tareas[index]['IDTAREA'],
              idmateria: tareas[index]['IDMATERIA'],
              f_entrega: tareas[index]['F_ENTREGA'],
              descripcion: tareas[index]['DESCRIPCION']));
    }
    return List.generate(
        0,
        (index) =>
            Tarea(idtarea: 0, idmateria: '', f_entrega: '', descripcion: ''));
  }

  static Future<List<Tarea>> readAllWhere(String idmateria) async {
    final db = await Conexion.database;
    List<Map<String, dynamic>> tareas =
        await db.query('TAREA', where: 'IDMATERIA=?', whereArgs: [idmateria]);
    if (tareas.isNotEmpty) {
      return List.generate(
          tareas.length,
          (index) => Tarea(
              idtarea: tareas[index]['IDTAREA'],
              idmateria: tareas[index]['IDMATERIA'],
              f_entrega: tareas[index]['F_ENTREGA'],
              descripcion: tareas[index]['DESCRIPCION']));
    }
    return List.generate(
        0,
        (index) =>
            Tarea(idtarea: 0, idmateria: '', f_entrega: '', descripcion: ''));
  }

  static Future<int> update(Tarea tarea) async {
    final db = await Conexion.database;
    return db.update('TAREA', tarea.toJSON(),
        where: 'IDTAREA=?', whereArgs: [tarea.idtarea]);
  }

  static Future<int> delete(int idtarea) async {
    final db = await Conexion.database;
    return db.delete('TAREA', where: 'IDTAREA=?', whereArgs: [idtarea]);
  }
}
