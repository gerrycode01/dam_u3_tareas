import 'package:dam_u3_practica2_tarea/vistas/Materia/editarMateria.dart';
import 'package:flutter/material.dart';
import 'package:dam_u3_practica2_tarea/controlador/db_materia.dart';
import 'package:dam_u3_practica2_tarea/modelo/materia.dart';
import 'package:dam_u3_practica2_tarea/vistas/Materia/crearMateria.dart';

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
    if (mounted) {
      setState(() {
        materias = listaMaterias;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Materias', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pink.shade900,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const crearMateria()),
              ).then((_) => cargarLista());
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
        itemCount: materias.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: UniqueKey(), // Se recomienda usar UniqueKey para evitar problemas con el estado
            onDismissed: (direction) {
              DBMateria.delete(materias[index]).then((value) {
                mensaje("Materia eliminada correctamente", Colors.red);
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
                          builder: (context) => const editarMateria()));
                }, // Agrega una acción al tocar la tarjeta
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch, // Alineación horizontal
                  mainAxisAlignment: MainAxisAlignment.start, // Alineación vertical
                  children: [
                    SizedBox(height: 35,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        materias[index].nombre,
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
                        'Carrera: ${materias[index].docente}',
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Semestre: ${materias[index].semestre}',
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
