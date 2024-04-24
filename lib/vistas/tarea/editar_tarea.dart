import 'package:dam_u3_practica2_tarea/controlador/db_materia.dart';
import 'package:dam_u3_practica2_tarea/controlador/db_tarea.dart';
import 'package:dam_u3_practica2_tarea/modelo/materia.dart';
import 'package:dam_u3_practica2_tarea/modelo/tarea.dart';
import 'package:flutter/material.dart';

class EditarTarea extends StatefulWidget {
  const EditarTarea({super.key, required this.idtarea});

  final int idtarea;

  @override
  State<EditarTarea> createState() => _EditarTareaState();
}

class _EditarTareaState extends State<EditarTarea> {
  Tarea tarea =
      Tarea(idtarea: 0, idmateria: '', f_entrega: '', descripcion: '');
  List<Materia> materias = [];
  final _fechaentrega = TextEditingController();
  final _descripcion = TextEditingController();
  String? idMateria;
  final Color azulMarino = Colors.indigo.shade900;
  final Color naranja = Colors.deepOrange;
  final Color blanco = Colors.white;
  final Color negro = Colors.black;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cargarDatos();
  }

  void cargarDatos() async {
    Tarea tarea = await DBTarea.readOne(widget.idtarea);
    List<Materia> materias = await DBMateria.readAll();

    setState(() {
      this.materias = materias;
      this.tarea = tarea;
      _fechaentrega.text = tarea.f_entrega;
      _descripcion.text = tarea.descripcion;
      idMateria = tarea.idmateria;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Editar Tarea",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.pink.shade900,
      ),
      body: ListView(
        padding: const EdgeInsets.all(30),
        children: [
          DropdownButtonFormField(
              value: idMateria,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: Icon(Icons.book, color: azulMarino),
                filled: true,
                fillColor: blanco,
              ),
              hint: const Text("Selecciona una materia"),
              items: materias.map((e) {
                return DropdownMenuItem(
                    value: e.idmateria, child: Text(e.nombre));
              }).toList(),
              onChanged: (valor) {
                setState(() {
                  idMateria = valor!;
                });
              }),
          const SizedBox(height: 20),
          TextField(
            controller: _descripcion,
            decoration: InputDecoration(
              hintText: 'Descripcion de  tarea',
              hintStyle: TextStyle(color: negro.withOpacity(0.6)),
              filled: true,
              fillColor: blanco,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Icon(Icons.description, color: Colors.pink.shade900),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _fechaentrega,
            decoration: InputDecoration(
              hintText: 'Fecha',
              hintStyle: TextStyle(color: negro.withOpacity(0.6)),
              filled: true,
              fillColor: blanco,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Icon(Icons.date_range, color: Colors.pink.shade900),
            ),
            onTap: () async {
              // Mostrar picker de fecha
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null) {
                _fechaentrega.text = pickedDate
                    .toString()
                    .substring(0, 10); // Formatea la fecha como yyyy-mm-dd
              }
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: blanco,
              backgroundColor: Colors.pink.shade900,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              if (_descripcion.text.isEmpty) {
                mensaje('REGISTRA LA DESCRIPCION', Colors.red);
                return;
              }
              if (_fechaentrega.text.isEmpty) {
                mensaje('REGISTRA LA FECHA', Colors.red);
                return;
              }
              if (idMateria == null) {
                mensaje('REGISTRA UNA MATERIA POR FAVOR', Colors.red);
                return;
              } else {
                Tarea t = Tarea(
                    idtarea: widget.idtarea,
                    idmateria: idMateria.toString(),
                    f_entrega: _fechaentrega.text,
                    descripcion: _descripcion.text);
                DBTarea.update(t).then((value) {
                  if (value == 0) {
                    mensaje('ERROR DE ACTUALIZACION', Colors.red);
                    return;
                  }
                  mensaje("REGISTRO ACTUALIZADO", Colors.green);
                  Navigator.pop(context);
                });
              }
            },
            child: const Text('Aceptar'),
          ),
          const SizedBox(height: 10),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: blanco,
              backgroundColor: Colors.red.shade900,
              // Color de fondo
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void mensaje(String texto, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(texto),
        backgroundColor: color,
      ),
    );
  }
}
