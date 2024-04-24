import 'package:dam_u3_practica2_tarea/vistas/materia/editar_materia.dart';
import 'package:flutter/material.dart';
import 'package:dam_u3_practica2_tarea/controlador/db_materia.dart';
import 'package:dam_u3_practica2_tarea/modelo/materia.dart';
import 'package:dam_u3_practica2_tarea/vistas/materia/crear_materia.dart';

class VistaMateria extends StatefulWidget {
  const VistaMateria({super.key});

  @override
  State<VistaMateria> createState() => _VistaMateriaState();
}

class _VistaMateriaState extends State<VistaMateria> {
  List<Materia> materias = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Materias',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pink.shade900,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CrearMateria()),
              ).then((_) => cargarLista());
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: materias.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(materias[index].idmateria), // Utiliza el id de la materia como clave única
            direction: DismissDirection.endToStart, // Solo permite deslizar en una dirección
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) {
              // Lógica de eliminación de la materia
              DBMateria.delete(materias[index]).then((value) {
                mensaje("Materia eliminada correctamente", Colors.red);
                cargarLista();
              });
            },
            child: InkWell(
              onTap: () {
                // Navegación a la pantalla de edición de la materia
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditarMateria(
                      idmateria: materias[index].idmateria,
                    ),
                  ),
                ).then((_) => cargarLista()); // Asegura recargar la lista al volver
              },
              child: Card(
                clipBehavior: Clip.antiAlias,
                elevation: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AspectRatio(
                      aspectRatio: 3.0,
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
                          size: 40.0,
                          color: Colors.pink.shade600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        materias[index].nombre,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.pink.shade900,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Docente: ${materias[index].docente}',
                        style: const TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Semestre: ${materias[index].semestre}',
                        style: const TextStyle(fontSize: 10),
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
