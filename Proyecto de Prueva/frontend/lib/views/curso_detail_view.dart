import 'package:flutter/material.dart';
import '../models/curso.dart';

class CursoDetailView extends StatelessWidget {
  final Curso item;

  const CursoDetailView({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Curso'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Curso',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Divider(height: 32),
              _buildDetailRow('capacidadMax', item.capacidadMax.toString()),
                const SizedBox(height: 12),
              _buildDetailRow('id', item.id.toString()),
                const SizedBox(height: 12),
              _buildDetailRow('nombre', item.nombre.toString()),
                const SizedBox(height: 12),
              _buildDetailRow('turno', item.turno.toString()),
                const SizedBox(height: 12),
              const SizedBox(height: 16),
              Text('Docentes:', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              if (item.docente.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(left: 16, bottom: 4),
                  child: Text('No hay docentes registrados', style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey)),
                )
              else
                ...item.docente.map((e) => Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 4),
                  child: Text('• ${e.- especialidad.toString()}', style: const TextStyle(fontSize: 14)),
                ))
                const SizedBox(height: 12),
              const SizedBox(height: 16),
              Text('Inscripcions:', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              if (item.inscripcion.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(left: 16, bottom: 4),
                  child: Text('No hay inscripcions registrados', style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey)),
                )
              else
                ...item.inscripcion.map((e) => Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 4),
                  child: Text('• ${e.- costoMatricula.toString()}', style: const TextStyle(fontSize: 14)),
                ))
                const SizedBox(height: 12),
              const SizedBox(height: 16),
              Text('Cursos:', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              if (item.curso.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(left: 16, bottom: 4),
                  child: Text('No hay cursos registrados', style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey)),
                )
              else
                ...item.curso.map((e) => Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 4),
                  child: Text('• ${e.capacidadMax.toString()}', style: const TextStyle(fontSize: 14)),
                ))
                const SizedBox(height: 12),
              if (item.curso != null) _buildDetailRow('Curso.capacidadMax', item.curso!.capacidadMax.toString())
                const SizedBox(height: 12),
              if (item.curso != null) _buildDetailRow('Curso.nombre', item.curso!.nombre.toString())
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
