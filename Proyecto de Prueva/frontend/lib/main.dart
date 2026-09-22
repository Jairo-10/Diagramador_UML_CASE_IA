import 'package:flutter/material.dart';
import 'views/boletin_list_view.dart';
import 'views/calificacion_list_view.dart';
import 'views/curso_list_view.dart';
import 'views/docente_list_view.dart';
import 'views/estudiante_list_view.dart';
import 'views/inscripcion_list_view.dart';
import 'views/materia_list_view.dart';
import 'views/persona_list_view.dart';
import 'views/docente_materia_list_view.dart';
import 'views/docente_materia_list_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Generator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Clases'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: const Icon(Icons.table_chart, size: 40),
              title: Text('Boletin'),
              subtitle: Text('Gestionar Boletin'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BoletinListView(),
                  ),
                );
              },
            ),
          ),
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: const Icon(Icons.table_chart, size: 40),
              title: Text('Calificacion'),
              subtitle: Text('Gestionar Calificacion'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CalificacionListView(),
                  ),
                );
              },
            ),
          ),
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: const Icon(Icons.table_chart, size: 40),
              title: Text('Curso'),
              subtitle: Text('Gestionar Curso'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CursoListView(),
                  ),
                );
              },
            ),
          ),
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: const Icon(Icons.table_chart, size: 40),
              title: Text('Docente'),
              subtitle: Text('Gestionar Docente'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DocenteListView(),
                  ),
                );
              },
            ),
          ),
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: const Icon(Icons.table_chart, size: 40),
              title: Text('Estudiante'),
              subtitle: Text('Gestionar Estudiante'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EstudianteListView(),
                  ),
                );
              },
            ),
          ),
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: const Icon(Icons.table_chart, size: 40),
              title: Text('Inscripcion'),
              subtitle: Text('Gestionar Inscripcion'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InscripcionListView(),
                  ),
                );
              },
            ),
          ),
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: const Icon(Icons.table_chart, size: 40),
              title: Text('Materia'),
              subtitle: Text('Gestionar Materia'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MateriaListView(),
                  ),
                );
              },
            ),
          ),
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: const Icon(Icons.table_chart, size: 40),
              title: Text('Persona'),
              subtitle: Text('Gestionar Persona'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PersonaListView(),
                  ),
                );
              },
            ),
          ),
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            color: Colors.purple.shade50,
            child: ListTile(
              leading: const Icon(Icons.link, size: 40, color: Colors.purple),
              title: Text('DocenteMateria'),
              subtitle: Text('Gestionar relación Docente - Materia'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DocenteMateriaListView(),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
