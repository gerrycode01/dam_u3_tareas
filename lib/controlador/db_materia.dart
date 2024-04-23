import 'package:dam_u3_practica2_tarea/controlador/conexion.dart';
import 'package:dam_u3_practica2_tarea/controlador/db_tarea.dart';
import 'package:dam_u3_practica2_tarea/modelo/materia.dart';
import 'package:dam_u3_practica2_tarea/modelo/tarea.dart';

class DBMateria {
  static Future<int> insert(Materia materia) async {
    final db = await Conexion.database;

    Materia mat = await DBMateria.readOne(materia.idmateria);

    if (mat.idmateria.isNotEmpty) {
      return 0;
    }
    return db.insert('MATERIA', materia.toJSON());
  }

  static Future<List<Materia>> readAll() async {
    final db = await Conexion.database;
    List<Map<String, dynamic>> materias = await db.query('MATERIA');
    if (materias.isNotEmpty) {
      return List.generate(
          materias.length,
          (index) => Materia(
              idmateria: materias[index]['IDMATERIA'],
              nombre: materias[index]['NOMBRE'],
              semestre: materias[index]['SEMESTRE'],
              docente: materias[index]['DOCENTE']));
    }
    return List.generate(
        0,
        (index) => Materia(
            idmateria: materias[0]['IDMATERIA'],
            nombre: materias[0]['NOMBRE'],
            semestre: materias[0]['SEMESTRE'],
            docente: materias[0]['DOCENTE']));
  }

  static Future<List<Materia>> readAllWhere(String semestre) async {
    final db = await Conexion.database;
    List<Map<String, dynamic>> materias = await db.query('MATERIA', where: 'SEMESTRE=?', whereArgs: [semestre]);
    if (materias.isNotEmpty) {
      return List.generate(
          materias.length,
              (index) => Materia(
              idmateria: materias[index]['IDMATERIA'],
              nombre: materias[index]['NOMBRE'],
              semestre: materias[index]['SEMESTRE'],
              docente: materias[index]['DOCENTE']));
    }
    return List.generate(
        0,
            (index) => Materia(
            idmateria: materias[0]['IDMATERIA'],
            nombre: materias[0]['NOMBRE'],
            semestre: materias[0]['SEMESTRE'],
            docente: materias[0]['DOCENTE']));
  }

  static Future<Materia> readOne(String idmateria) async {
    final db = await Conexion.database;
    List<Map<String, dynamic>> materia =
        await db.query('MATERIA', where: 'IDMATERIA=?', whereArgs: [idmateria]);
    if (materia.isNotEmpty) {
      return Materia(
          idmateria: materia[0]['IDMATERIA'],
          nombre: materia[0]['NOMBRE'],
          semestre: materia[0]['SEMESTRE'],
          docente: materia[0]['DOCENTE']);
    }
    return Materia(idmateria: '', nombre: '', semestre: '', docente: '');
  }

  static Future<int> update(Materia materia) async {
    final db = await Conexion.database;
    return db.update('MATERIA', materia.toJSON(),
        where: 'IDMATERIA=?', whereArgs: [materia.idmateria]);
  }

  static Future<int> delete(Materia materia) async {
    final db = await Conexion.database;

    List<Tarea> tareas = await DBTarea.readAllWhere(materia.idmateria);
    for (var tarea in tareas) {
      DBTarea.delete(tarea.idtarea);
    }

    return db.delete('MATERIA',
        where: 'IDMATERIA=?', whereArgs: [materia.idmateria]);
  }
}
