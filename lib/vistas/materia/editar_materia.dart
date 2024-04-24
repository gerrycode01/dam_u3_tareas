import 'package:dam_u3_practica2_tarea/controlador/conexion.dart';
import 'package:dam_u3_practica2_tarea/controlador/db_materia.dart';
import 'package:dam_u3_practica2_tarea/modelo/materia.dart';
import 'package:flutter/material.dart';

class EditarMateria extends StatefulWidget {
  const EditarMateria({super.key, required this.idmateria});

  final String idmateria;

  @override
  State<EditarMateria> createState() => _EditarMateriaState();
}

class _EditarMateriaState extends State<EditarMateria> {
  Materia materia =
      Materia(idmateria: '', nombre: '', semestre: '', docente: '');
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
    Materia materia = await DBMateria.readOne(widget.idmateria);
    setState(() {
      this.materia = materia;
      _nombre.text = materia.nombre;
      _docente.text = materia.docente;
      _semestreseleccionado = materia.semestre;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Editar materia",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.pink.shade900,
      ),
      body: ListView(
        padding: const EdgeInsets.all(30),
        children: [
          TextField(
            controller: _nombre,
            decoration: InputDecoration(
              hintText: 'Nombre de la materia',
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
            onChanged: (newValue) {
              setState(() {
                _semestreseleccionado = newValue!;
              });
            },
            items: Conexion.semestres
                .map<DropdownMenuItem<String>>((String value) {
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
              foregroundColor: blanco,
              backgroundColor: Colors.pink.shade900,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              if (_nombre.text.isEmpty) {
                mensaje('REGISTRA EL NOMBRE UNA MATERIA', Colors.red);
                return;
              }
              if (_docente.text.isEmpty) {
                mensaje('REGISTRA UN DOCENTE POR FAVOR', Colors.red);
                return;
              }
              if (_semestreseleccionado == null) {
                mensaje("Por favor, seleccione una carrera antes de agregar.",
                    Colors.red);
                return;
              }
              Materia ma = Materia(
                  idmateria: widget.idmateria,
                  nombre: _nombre.text,
                  semestre: _semestreseleccionado.toString(),
                  docente: _docente.text);
              DBMateria.update(ma).then((value) {
                if (value == 0) {
                  mensaje('ERROR AL ACTUALIZAR', Colors.red);
                  return;
                }
                mensaje("CAMBIOS REGISTRADOS", Colors.green);
              });
              Navigator.pop(context);
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

  void mensaje(String s, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(s),
      backgroundColor: color,
    ));
  }
}
