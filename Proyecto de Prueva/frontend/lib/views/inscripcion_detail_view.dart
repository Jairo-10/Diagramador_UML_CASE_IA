import 'package:flutter/material.dart';
import '../models/inscripcion.dart';

class InscripcionDetailView extends StatelessWidget {
  final Inscripcion item;

  const InscripcionDetailView({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Inscripcion'),
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
                  'Inscripcion',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Divider(height: 32),
              _buildDetailRow('costoMatricula', item.costoMatricula.toString()),
                const SizedBox(height: 12),
              _buildDetailRow('estado', item.estado.toString()),
                const SizedBox(height: 12),
              _buildDetailRow('fechaInscripcion', item.fechaInscripcion.toString()),
                const SizedBox(height: 12),
              _buildDetailRow('id', item.id.toString()),
                const SizedBox(height: 12),
              _buildDetailRow('numeroFolio', item.numeroFolio.toString()),
                const SizedBox(height: 12),
              if (item.boletin != null) _buildDetailRow('Boletin.codigoVerificacion', item.boletin!.codigoVerificacion.toString())
                const SizedBox(height: 12),
              if (item.boletin != null) _buildDetailRow('Boletin.fechaEmision', item.boletin!.fechaEmision.toString())
                const SizedBox(height: 12),
              const SizedBox(height: 16),
              Text('Calificacions:', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              if (item.calificacion.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(left: 16, bottom: 4),
                  child: Text('No hay calificacions registrados', style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey)),
                )
              else
                ...item.calificacion.map((e) => Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 4),
                  child: Text('• ${e.notaFinal.toString()}', style: const TextStyle(fontSize: 14)),
                ))
                const SizedBox(height: 12),
              if (item.curso != null) _buildDetailRow('Curso.capacidadMax', item.curso!.capacidadMax.toString())
                const SizedBox(height: 12),
              if (item.curso != null) _buildDetailRow('Curso.nombre', item.curso!.nombre.toString())
                const SizedBox(height: 12),
              if (item.estudiante != null) _buildDetailRow('Estudiante.activo', item.estudiante!.activo.toString())
                const SizedBox(height: 12),
              if (item.estudiante != null) _buildDetailRow('Estudiante.codigoRude', item.estudiante!.codigoRude.toString())
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
