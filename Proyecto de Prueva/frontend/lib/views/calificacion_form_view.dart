import 'package:flutter/material.dart';
import '../models/calificacion.dart';
import '../services/calificacion_service.dart';
import '../models/inscripcion.dart';
import '../services/inscripcion_service.dart';

class CalificacionFormView extends StatefulWidget {
  final Calificacion? item;

  const CalificacionFormView({super.key, this.item});

  @override
  State<CalificacionFormView> createState() => _CalificacionFormViewState();
}

class _CalificacionFormViewState extends State<CalificacionFormView> {
  final _formKey = GlobalKey<FormState>();
  final CalificacionService _service = CalificacionService();
  final TextEditingController _notaFinalController = TextEditingController();
  final TextEditingController _observacionController = TextEditingController();
  final TextEditingController _trimestreController = TextEditingController();
  String? _selectedInscripcionId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _notaFinalController.text = widget.item!.notaFinal.toString();
      _observacionController.text = widget.item!.observacion.toString();
      _trimestreController.text = widget.item!.trimestre.toString();
      if (widget.item!.inscripcionId.isNotEmpty) { _selectedInscripcionId = widget.item!.inscripcionId; }
    }
  }

  @override
  void dispose() {
    _notaFinalController.dispose();
    _observacionController.dispose();
    _trimestreController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final item = Calificacion(
        id: widget.item?.id ?? 0,
          notaFinal: _notaFinalController.text,
          observacion: _observacionController.text,
          trimestre: _trimestreController.text,
          inscripcionId: _selectedInscripcionId ?? '',
      );

      if (widget.item == null) {
        await _service.create(item);
      } else {
        await _service.update(item.id.toString(), item);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.item == null
                ? 'Creado exitosamente'
                : 'Actualizado exitosamente'),
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Crear Calificacion' : 'Editar Calificacion'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [

                    const SizedBox(height: 16),
            if (widget.item != null)
              TextFormField(
                initialValue: widget.item!.id.toString(),
                decoration: const InputDecoration(
                  labelText: 'id (Auto)',
                  border: OutlineInputBorder(),
                ),
                enabled: false,
              ),
                    const SizedBox(height: 16),
            TextFormField(
              controller: _notaFinalController,
              decoration: const InputDecoration(
                labelText: 'notaFinal',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Este campo es requerido';
                }
                return null;
              },
            ),
                    const SizedBox(height: 16),
            TextFormField(
              controller: _observacionController,
              decoration: const InputDecoration(
                labelText: 'observacion',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Este campo es requerido';
                }
                return null;
              },
            ),
                    const SizedBox(height: 16),
            TextFormField(
              controller: _trimestreController,
              decoration: const InputDecoration(
                labelText: 'trimestre',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Este campo es requerido';
                }
                return null;
              },
            ),
                    const SizedBox(height: 16),
FutureBuilder<List<Inscripcion>>(
              future: InscripcionService().getAll(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                final items = snapshot.data!;
                // Eliminar duplicados por ID si existen
                final uniqueItems = {
                  for (var item in items) item.- costoMatricula.toString(): item
                }.values.toList();
                // Verificar que el valor seleccionado exista en la lista
                final validValue = _selectedInscripcionId != null && 
                    uniqueItems.any((e) => e.- costoMatricula.toString() == _selectedInscripcionId)
                    ? _selectedInscripcionId
                    : null;
                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Inscripcion'),
                  value: validValue,
                  items: uniqueItems.map((e) => DropdownMenuItem(
                    value: e.- costoMatricula.toString(),
                    child: Text(e.- estado.toString()),
                  )).toList(),
                  onChanged: (v) {
                    setState(() {
                      _selectedInscripcionId = v;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Este campo es requerido';
                    }
                    return null;
                  },
                );
              },
            ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                        ),
                        child: Text(
                          widget.item == null ? 'Crear' : 'Actualizar',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
