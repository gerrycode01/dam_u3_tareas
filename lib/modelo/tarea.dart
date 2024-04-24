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

}
