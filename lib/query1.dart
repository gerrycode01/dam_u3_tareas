import 'package:dam_u3_practica2_tarea/controlador/conexion.dart';
import 'package:dam_u3_practica2_tarea/vistas/tarea/crear_tarea.dart';
import 'package:flutter/material.dart';
import 'package:dam_u3_practica2_tarea/controlador/db_materia.dart';
import 'package:dam_u3_practica2_tarea/modelo/materia.dart';

class Query1 extends StatefulWidget {
  const Query1({super.key});

  @override
  State<Query1> createState() => _Query1State();
}

class _Query1State extends State<Query1> {
  List<Materia> materias = [];

  @override
  void initState() {
    super.initState();
    cargarLista();
  }

  void cargarLista() async {
    List<Materia> listaMaterias =
        await DBMateria.readAllWhere(Conexion.semestres[1]);
    setState(() {
      materias = listaMaterias;
    });
  }

  @override
  Widget build(BuildContext context) {
    cargarLista();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Materias del Semestre',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.pink.shade900,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: materias.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                // Navegar a la nueva pantalla de detalles pasando la materia seleccionada
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      CrearTarea(idmateria: materias[index].idmateria),
                ));
              },
              child: Card(
                elevation: 4.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 2.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.pink.shade100,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                        ),
                        child: Icon(
                          Icons.school,
                          size: 48.0,
                          color: Colors.pink.shade600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        materias[index].nombre,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Profesor: ${materias[index].docente}',
                        style: const TextStyle(fontSize: 14.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Aquí podrías añadir más información relevante si fuera necesario.
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
