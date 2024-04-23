import 'package:dam_u3_practica2_tarea/controlador/conexion.dart';
import 'package:dam_u3_practica2_tarea/controlador/db_materia.dart';
import 'package:dam_u3_practica2_tarea/modelo/materia.dart';
import 'package:flutter/material.dart';

class editarMateria extends StatefulWidget {
  const editarMateria({super.key});

  @override
  State<editarMateria> createState() => _editarMateriaState();
}

class _editarMateriaState extends State<editarMateria> {
  List<Materia> materias = [];
  final _idmateria = TextEditingController();
  final _nombre = TextEditingController();
  final _docente = TextEditingController();
  String? _semestreseleccionado;

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
          "Editar Materia", style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.pink.shade900,
      ),
      body: ListView(
        padding: const EdgeInsets.all(30),
        children: [
          TextField(
            controller: _idmateria,
            decoration: InputDecoration(
              hintText: 'Id Materia',
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
            controller: _nombre,
            decoration: InputDecoration(
              hintText: 'Nombre de la Materia',
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
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: blanco,
              prefixIcon: Icon(Icons.school, color: Colors.pink.shade900),
            ),
            value: _semestreseleccionado,
            hint: Text('Seleccione un semestre',
                style: TextStyle(color: negro.withOpacity(0.6))),
            onChanged: (String? newValue) {
              setState(() {
                _semestreseleccionado = newValue;
              });
            },
            items: Conexion.semestres.map<DropdownMenuItem<String>>((
                String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(color: negro)),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _docente,
            decoration: InputDecoration(
              hintText: 'Nombre del docente',
              hintStyle: TextStyle(color: negro.withOpacity(0.6)),
              filled: true,
              fillColor: blanco,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Icon(Icons.person, color: Colors.pink.shade900),
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
              if (_idmateria == null) {
                mensaje('REGISTRA UN ID A LA MATERIA POR FAVOR', Colors.red);
                return;
              }
              if (_nombre == null) {
                mensaje('REGISTRA EL NOMBRE UNA MATERIA', Colors.red);
                return;
              }
              if (_docente == null) {
                mensaje('REGISTRA UN DOCENTE POR FAVOR', Colors.red);
                return;
              }
              if (_semestreseleccionado == null) {
                mensaje("Por favor, seleccione una carrera antes de agregar.",
                    Colors.red);
              } else {
                Materia ma = Materia(
                    idmateria: _idmateria.text,
                    nombre: _nombre.text,
                    semestre: _semestreseleccionado!,
                    docente: _docente.text
                );
                DBMateria.insert(ma).then((value) {
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
