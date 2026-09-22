import 'package:flutter/material.dart';
import '../models/docente_materia.dart';

class DocenteMateriaDetailView extends StatelessWidget {
  final DocenteMateria item;

  const DocenteMateriaDetailView({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Relación DocenteMateria'),
        backgroundColor: Colors.purple,
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
                  'Relación Docente - Materia',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Divider(height: 32),
                _buildDetailRow('ID de Relación', item.id.toString()),
                const SizedBox(height: 12),
                _buildDetailRow('ID de Docente', item.docenteid.toString()),
                const SizedBox(height: 12),
                if (item.docente != null) _buildDetailRow('Docente.especialidad', item.docente!.especialidad.toString()),
                if (item.docente != null) const SizedBox(height: 12),
                if (item.docente != null) _buildDetailRow('Docente.fechaContrato', item.docente!.fechaContrato.toString()),
                if (item.docente != null) const SizedBox(height: 12),
                _buildDetailRow('ID de Materia', item.materiaid.toString()),
                const SizedBox(height: 12),
                if (item.materia != null) _buildDetailRow('Materia.horasSemanales', item.materia!.horasSemanales.toString()),
                if (item.materia != null) const SizedBox(height: 12),
                if (item.materia != null) _buildDetailRow('Materia.nombre', item.materia!.nombre.toString()),
                if (item.materia != null) const SizedBox(height: 12),
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
          width: 150,
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
