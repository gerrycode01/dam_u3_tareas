import 'package:dam_u3_practica2_tarea/controlador/conexion.dart';
import 'package:dam_u3_practica2_tarea/modelo/materia_tarea.dart';
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

  static Future<List<MateriaTarea>> readAllWithMateria() async {
    final db = await Conexion.database;
    String sql = '''
    SELECT 
      MATERIA.IDMATERIA,
      MATERIA.NOMBRE,
      MATERIA.SEMESTRE,
      MATERIA.DOCENTE,
      TAREA.IDTAREA,
      TAREA.F_ENTREGA,
      TAREA.DESCRIPCION
    FROM MATERIA
    INNER JOIN TAREA ON TAREA.IDMATERIA = MATERIA.IDMATERIA;
    ''';
    List<Map<String, dynamic>> materiasTareas = await db.rawQuery(sql);
    if (materiasTareas.isNotEmpty) {
      return List.generate(
          materiasTareas.length,
          (index) => MateriaTarea(
              idmateria: materiasTareas[index]['IDMATERIA'],
              nombre: materiasTareas[index]['NOMBRE'],
              semestre: materiasTareas[index]['SEMESTRE'],
              docente: materiasTareas[index]['DOCENTE'],
              idtarea: materiasTareas[index]['IDTAREA'],
              f_entrega: materiasTareas[index]['F_ENTREGA'],
              descripcion: materiasTareas[index]['DESCRIPCION']));
    }
    return List.generate(
        0,
        (index) => MateriaTarea(
            idmateria: '',
            nombre: '',
            semestre: '',
            docente: '',
            idtarea: 0,
            f_entrega: '',
            descripcion: ''));
  }
}
