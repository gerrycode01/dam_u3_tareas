import 'package:dam_u3_practica2_tarea/controlador/db_materia.dart';
import 'package:dam_u3_practica2_tarea/controlador/db_tarea.dart';
import 'package:dam_u3_practica2_tarea/modelo/materia_tarea.dart';
import 'package:dam_u3_practica2_tarea/modelo/tarea.dart';
import 'package:dam_u3_practica2_tarea/vistas/VistaTarea/crearTarea.dart';
import 'package:dam_u3_practica2_tarea/vistas/VistaTarea/editarTarea.dart';
import 'package:flutter/material.dart';

class VistaTarea extends StatefulWidget {
  const VistaTarea({super.key});

  @override
  State<VistaTarea> createState() => _VistaTareaState();
}

class _VistaTareaState extends State<VistaTarea> {
  List<MateriaTarea> tareas =[];
  @override

  void initState() {
    super.initState();
    cargarLista();
  }

  void cargarLista() async {
    List<MateriaTarea> listatareas = await DBTarea.readAllWithMateria();
      setState(() {
        tareas = listatareas;
      });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Tareas', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pink.shade900,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CrearTarea()),
              );
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: tareas.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: UniqueKey(), // Se recomienda usar UniqueKey para evitar problemas con el estado
            onDismissed: (direction) {
              DBTarea.delete(tareas[index].idtarea).then((value) {
                mensaje("Tarea eliminada correctamente", Colors.red);
                cargarLista();
              });
            },
            background: Container(color: Colors.red),
            child: Card(
              clipBehavior: Clip.antiAlias, // Añade esto para un mejor efecto visual al deslizar
              elevation: 5,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditarTarea()));
                }, // Agrega una acción al tocar la tarjeta
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch, // Alineación horizontal
                  mainAxisAlignment: MainAxisAlignment.start, // Alineación vertical
                  children: [
                    SizedBox(height: 35,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        tareas[index].descripcion,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.pink.shade900
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Carrera: ${tareas[index].f_entrega}',
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Semestre: ${tareas[index].docente}',
                        style: TextStyle(fontSize: 11),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
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
