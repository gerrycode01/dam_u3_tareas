import 'package:dam_u3_practica2_tarea/query1.dart';
import 'package:dam_u3_practica2_tarea/query2.dart';
import 'package:dam_u3_practica2_tarea/vistas/materia/vista_materia.dart';
import 'package:dam_u3_practica2_tarea/vistas/tarea/vista_tarea.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
      debugShowMaterialGrid: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final Color tinto = Colors.pink.shade900;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Sistema de Control de Tareas",
          style: TextStyle(
              color: Colors.white,
              fontSize: 17,
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.pink.shade900,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/fondofinal.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: ListView(
                  children: const [

                  ],
                )
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text(
                'Materias',
                style: TextStyle(
                  color: Colors.pink,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const VistaMateria()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.home_work),
              title: const Text(
                'Tareas',
                style: TextStyle(
                  color: Colors.pink,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const VistaTarea()));
              },
            ),
          ],
        ),
      ),
      body: _dinamico(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_work_outlined),
            label: 'Tablero',
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.deepOrange,
        onTap: _onItemTapped,
      ),
    );
  }
  Widget _dinamico() {
    switch (_currentIndex) {
      case 1:
        return const Query2();
      default:
        return const Query1();
    }
  }
}

