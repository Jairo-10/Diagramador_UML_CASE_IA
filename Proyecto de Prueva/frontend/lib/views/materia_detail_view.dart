import 'package:flutter/material.dart';
import '../models/materia.dart';

class MateriaDetailView extends StatelessWidget {
  final Materia item;

  const MateriaDetailView({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Materia'),
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
                  'Materia',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Divider(height: 32),
              _buildDetailRow('horasSemanales', item.horasSemanales.toString()),
                const SizedBox(height: 12),
              _buildDetailRow('id', item.id.toString()),
                const SizedBox(height: 12),
              _buildDetailRow('nombre', item.nombre.toString()),
                const SizedBox(height: 12),
              _buildDetailRow('sigla', item.sigla.toString()),
                const SizedBox(height: 12),
              const SizedBox(height: 16),
              Text('Docentes:', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              if (item.docente_materia.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(left: 16, bottom: 4),
                  child: Text('No hay docentes relacionados', style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey)),
                )
              else
                ...item.docente_materia.map((e) => Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 4),
                  child: Text('• ${e.docente?.especialidad}, ${e.docente?.fechaContrato}', style: const TextStyle(fontSize: 14), overflow: TextOverflow.ellipsis, maxLines: 2),
                )),
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
