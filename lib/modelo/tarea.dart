import 'package:intl/intl.dart';

class Tarea {
  int idtarea; //llave primaria autoincrementable
  String idmateria; //llave foranea
  String f_entrega;
  String descripcion;

  Tarea(
      {required this.idtarea,
      required this.idmateria,
      required this.f_entrega,
      required this.descripcion});

  Map<String, dynamic> toJSON() {
    return {
      //'idtarea':idtarea,
      'idmateria':idmateria,
      'f_entrega':f_entrega,
      'descripcion':descripcion
    };
  }

  DateTime get fechaEntrega {
    return DateFormat('yyyy-MM-dd').parse(f_entrega);
  }

  // Método estático para formatear DateTime a String
  static String formatFecha(DateTime fecha) {
    return DateFormat('yyyy-MM-dd').format(fecha);
  }

  List<Tarea> ordenarTareasPorFecha(List<Tarea> tareas) {
    tareas.sort((a, b) => a.fechaEntrega.compareTo(b.fechaEntrega));
    return tareas;
  }

  void eliminarTareasAnteriores(List<Tarea> tareas, String fechaLimite) {
    DateTime fechaLimiteDateTime = DateFormat('yyyy-MM-dd').parse(fechaLimite);
    tareas.removeWhere((tarea) => tarea.fechaEntrega.isBefore(fechaLimiteDateTime));
  }

  DateTime obtenerFechaAyer() {
    DateTime hoy = DateTime.now(); // Obtiene la fecha actual
    DateTime ayer = hoy.subtract(Duration(days: 1)); // Resta un día para obtener la fecha de ayer
    return ayer;
  }

}
