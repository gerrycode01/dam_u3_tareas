import 'package:dam_u3_practica2_tarea/controlador/db_materia.dart';
import 'package:dam_u3_practica2_tarea/controlador/db_tarea.dart';
import 'package:dam_u3_practica2_tarea/modelo/materia.dart';
import 'package:dam_u3_practica2_tarea/modelo/tarea.dart';
import 'package:flutter/material.dart';

class CrearTarea extends StatefulWidget {
  const CrearTarea({super.key});

  @override
  State<CrearTarea> createState() => _CrearTareaState();
}

class _CrearTareaState extends State<CrearTarea> {
  List<Tarea> tareas = [];
  List<Materia> materias = [];
  String? _materiaseleccionado;
  final _fechaentrega = TextEditingController();
  final _descripcion = TextEditingController();
  String? idMateria;
  final Color azulMarino = Colors.indigo.shade900;
  final Color naranja = Colors.deepOrange;
  final Color blanco = Colors.white;
  final Color negro = Colors.black;

  @override
  void initState() {
    super.initState();
    cargarLista();
  }

  void cargarLista() async {
    List<Materia> listaMaterias = await DBMateria.readAll();
    setState(() {
      materias = listaMaterias;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Registrar Tarea", style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.pink.shade900,
      ),
      body: ListView(
        padding: const EdgeInsets.all(30),
        children: [
          DropdownButtonFormField(
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
              prefixIcon: Icon(
                  Icons.confirmation_number, color: Colors.pink.shade900),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _fechaentrega,
            decoration: InputDecoration(
              hintText: 'Selecciona una fecha',
              hintStyle: TextStyle(color: negro.withOpacity(0.6)),
              filled: true,
              fillColor: blanco,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Icon(Icons.book_online, color: Colors.pink.shade900),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: blanco, backgroundColor: Colors.pink.shade900,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              if (_descripcion == null) {
                mensaje('REGISTRA UN ID A LA MATERIA POR FAVOR', Colors.red);
                return;
              }
              if (_fechaentrega == null) {
                mensaje('REGISTRA EL NOMBRE UNA MATERIA', Colors.red);
                return;
              }
              if (_materiaseleccionado == null) {
                mensaje('REGISTRA UN DOCENTE POR FAVOR', Colors.red);
                return;
              } else {
                Tarea t = Tarea(
                    idtarea: 0,
                    idmateria: idMateria.toString(),
                    f_entrega: _fechaentrega.toString(),
                    descripcion: _descripcion.toString()
                );
                DBTarea.insert(t).then((value) {
                  if (value == 0) {
                    mensaje('INSERCION INCORRECTA', Colors.red);
                    return;
                  }
                  mensaje("SE HA INSERTADO EL PROFESOR", Colors.green);
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Agregar'),
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

  void mensaje(String s, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s), backgroundColor: color,
        )
    );
  }
}
