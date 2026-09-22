import 'package:flutter/material.dart';
import '../models/persona.dart';

class PersonaDetailView extends StatelessWidget {
  final Persona item;

  const PersonaDetailView({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Persona'),
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
                  'Persona',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Divider(height: 32),
              _buildDetailRow('apellido', item.apellido.toString()),
                const SizedBox(height: 12),
              _buildDetailRow('celular', item.celular.toString()),
                const SizedBox(height: 12),
              _buildDetailRow('ci', item.ci.toString()),
                const SizedBox(height: 12),
              _buildDetailRow('fechaNacimiento', item.fechaNacimiento.toString()),
                const SizedBox(height: 12),
              _buildDetailRow('id', item.id.toString()),
                const SizedBox(height: 12),
              _buildDetailRow('nombre', item.nombre.toString()),
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
