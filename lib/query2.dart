import 'package:dam_u3_practica2_tarea/modelo/materia_tarea.dart';
import 'package:dam_u3_practica2_tarea/modelo/tarea.dart';
import 'package:flutter/material.dart';
import 'package:dam_u3_practica2_tarea/controlador/db_tarea.dart';
import 'package:dam_u3_practica2_tarea/vistas/tarea/crear_tarea.dart';
import 'package:intl/intl.dart';

class Query2 extends StatefulWidget {
  const Query2({super.key});

  @override
  State<Query2> createState() => _Query2State();
}

class _Query2State extends State<Query2> {
  List<Tarea> tareas = [];
  List<MateriaTarea> todocontodo =[];
  String? idMateriaSeleccionada;
  @override
  void initState() {
    super.initState();
    cargarLista();
  }

  void cargarLista() async {

    List<MateriaTarea> todo = await DBTarea.readAllWithMateria();
    List<Tarea> listatareas = await DBTarea.readAll();
    listatareas = DBTarea.ordenarTareasPorFecha(listatareas);
    eliminarTareasAnteriores(listatareas, DBTarea.formatFecha(DateTime.now()));
    setState(() {
      tareas = listatareas;
      todocontodo = todo;
    });
  }

  void eliminarTareasAnteriores(List<Tarea> tareas, String fechaLimite) {
    DateTime fechaLimiteDateTime = DateFormat('yyyy-MM-dd').parse(fechaLimite);
    tareas.removeWhere(
        (tarea) => tarea.fechaEntrega.isBefore(fechaLimiteDateTime));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Materias pendientes',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pink.shade900,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: idMateriaSeleccionada,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.book, color: Colors.indigo),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    hint: const Text("Selecciona una materia"),
                    items: todocontodo.map((e) {
                      return DropdownMenuItem(
                          value: e.idmateria, child: Text(e.nombre));
                    }).toList(),
                    onChanged: (valor) {
                      setState(() {
                        idMateriaSeleccionada = valor!;
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {

                  },
                ),
              ],
            ),
          ),
          Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: tareas.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
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
                              Icons.assignment,
                              size: 48.0,
                              color: Colors.pink.shade600,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  tareas[index].descripcion,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.pink.shade900,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  'Fecha entrega: ${tareas[index].f_entrega}',
                                  style: const TextStyle(fontSize: 10),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
          )
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
