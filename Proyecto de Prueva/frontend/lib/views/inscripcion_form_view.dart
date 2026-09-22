import 'package:flutter/material.dart';
import '../models/inscripcion.dart';
import '../services/inscripcion_service.dart';
import '../models/boletin.dart';
import '../models/curso.dart';
import '../models/estudiante.dart';
import '../services/boletin_service.dart';
import '../services/curso_service.dart';
import '../services/estudiante_service.dart';

class InscripcionFormView extends StatefulWidget {
  final Inscripcion? item;

  const InscripcionFormView({super.key, this.item});

  @override
  State<InscripcionFormView> createState() => _InscripcionFormViewState();
}

class _InscripcionFormViewState extends State<InscripcionFormView> {
  final _formKey = GlobalKey<FormState>();
  final InscripcionService _service = InscripcionService();
  final TextEditingController _costoMatriculaController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  final TextEditingController _fechaInscripcionController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _numeroFolioController = TextEditingController();
  String? _selectedBoletinId;
  String? _selectedCursoId;
  String? _selectedEstudianteId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _costoMatriculaController.text = widget.item!.costoMatricula.toString();
      _estadoController.text = widget.item!.estado.toString();
      _fechaInscripcionController.text = widget.item!.fechaInscripcion.toString();
      _idController.text = widget.item!.id.toString();
      _numeroFolioController.text = widget.item!.numeroFolio.toString();
      if (widget.item!.boletinId.isNotEmpty) { _selectedBoletinId = widget.item!.boletinId; }
      if (widget.item!.cursoId.isNotEmpty) { _selectedCursoId = widget.item!.cursoId; }
      if (widget.item!.estudianteId.isNotEmpty) { _selectedEstudianteId = widget.item!.estudianteId; }
    }
  }

  @override
  void dispose() {
    _costoMatriculaController.dispose();
    _estadoController.dispose();
    _fechaInscripcionController.dispose();
    _idController.dispose();
    _numeroFolioController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final item = Inscripcion(
        costoMatricula: _costoMatriculaController.text,
          estado: _estadoController.text,
          fechaInscripcion: _fechaInscripcionController.text,
          id: int.tryParse(_idController.text) ?? 0,
          numeroFolio: _numeroFolioController.text,
          boletinId: _selectedBoletinId ?? '',
          cursoId: _selectedCursoId ?? '',
          estudianteId: _selectedEstudianteId ?? '',
      );

      if (widget.item == null) {
        await _service.create(item);
      } else {
        await _service.update(item.costoMatricula.toString(), item);
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
        title: Text(widget.item == null ? 'Crear Inscripcion' : 'Editar Inscripcion'),
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
            TextFormField(
              controller: _costoMatriculaController,
              decoration: const InputDecoration(
                labelText: 'costoMatricula',
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
              controller: _estadoController,
              decoration: const InputDecoration(
                labelText: 'estado',
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
              controller: _fechaInscripcionController,
              decoration: const InputDecoration(
                labelText: 'fechaInscripcion',
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
              controller: _idController,
              decoration: const InputDecoration(
                labelText: 'id',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Este campo es requerido';
                }
                return null;
              },
            ),
                    const SizedBox(height: 16),
            TextFormField(
              controller: _numeroFolioController,
              decoration: const InputDecoration(
                labelText: 'numeroFolio',
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
FutureBuilder<List<Boletin>>(
              future: BoletinService().getAll(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                final items = snapshot.data!;
                // Eliminar duplicados por ID si existen
                final uniqueItems = {
                  for (var item in items) item.codigoVerificacion.toString(): item
                }.values.toList();
                // Verificar que el valor seleccionado exista en la lista
                final validValue = _selectedBoletinId != null && 
                    uniqueItems.any((e) => e.codigoVerificacion.toString() == _selectedBoletinId)
                    ? _selectedBoletinId
                    : null;
                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Boletin'),
                  value: validValue,
                  items: uniqueItems.map((e) => DropdownMenuItem(
                    value: e.codigoVerificacion.toString(),
                    child: Text(e.fechaEmision.toString()),
                  )).toList(),
                  onChanged: (v) {
                    setState(() {
                      _selectedBoletinId = v;
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
                    const SizedBox(height: 16),
FutureBuilder<List<Curso>>(
              future: CursoService().getAll(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                final items = snapshot.data!;
                // Eliminar duplicados por ID si existen
                final uniqueItems = {
                  for (var item in items) item.capacidadMax.toString(): item
                }.values.toList();
                // Verificar que el valor seleccionado exista en la lista
                final validValue = _selectedCursoId != null && 
                    uniqueItems.any((e) => e.capacidadMax.toString() == _selectedCursoId)
                    ? _selectedCursoId
                    : null;
                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Curso'),
                  value: validValue,
                  items: uniqueItems.map((e) => DropdownMenuItem(
                    value: e.capacidadMax.toString(),
                    child: Text(e.id.toString()),
                  )).toList(),
                  onChanged: (v) {
                    setState(() {
                      _selectedCursoId = v;
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
                    const SizedBox(height: 16),
FutureBuilder<List<Estudiante>>(
              future: EstudianteService().getAll(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                final items = snapshot.data!;
                // Eliminar duplicados por ID si existen
                final uniqueItems = {
                  for (var item in items) item.- apellido.toString(): item
                }.values.toList();
                // Verificar que el valor seleccionado exista en la lista
                final validValue = _selectedEstudianteId != null && 
                    uniqueItems.any((e) => e.- apellido.toString() == _selectedEstudianteId)
                    ? _selectedEstudianteId
                    : null;
                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Estudiante'),
                  value: validValue,
                  items: uniqueItems.map((e) => DropdownMenuItem(
                    value: e.- apellido.toString(),
                    child: Text(e.activo.toString()),
                  )).toList(),
                  onChanged: (v) {
                    setState(() {
                      _selectedEstudianteId = v;
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
