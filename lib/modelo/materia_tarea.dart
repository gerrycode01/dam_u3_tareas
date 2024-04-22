class MateriaTarea {
  String idmateria; //llave primaria
  String nombre;
  String semestre;
  String docente;
  int idtarea; //llave primaria autoincrementable
  String f_entrega;
  String descripcion;

  MateriaTarea(
      {required this.idmateria,
      required this.nombre,
      required this.semestre,
      required this.docente,
      required this.idtarea,
      required this.f_entrega,
      required this.descripcion});
}
