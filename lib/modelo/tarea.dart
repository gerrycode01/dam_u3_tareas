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
}
