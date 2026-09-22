import 'package:flutter/material.dart';
import '../models/calificacion.dart';

class CalificacionDetailView extends StatelessWidget {
  final Calificacion item;

  const CalificacionDetailView({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Calificacion'),
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
                  'Calificacion',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Divider(height: 32),
              _buildDetailRow('id', item.id.toString()),
                const SizedBox(height: 12),
              _buildDetailRow('notaFinal', item.notaFinal.toString()),
                const SizedBox(height: 12),
              _buildDetailRow('observacion', item.observacion.toString()),
                const SizedBox(height: 12),
              _buildDetailRow('trimestre', item.trimestre.toString()),
                const SizedBox(height: 12),
              if (item.inscripcion != null) _buildDetailRow('Inscripcion.- costoMatricula', item.inscripcion!.- costoMatricula.toString())
                const SizedBox(height: 12),
              if (item.inscripcion != null) _buildDetailRow('Inscripcion.- estado', item.inscripcion!.- estado.toString())
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
