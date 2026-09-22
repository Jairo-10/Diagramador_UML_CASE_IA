import 'package:flutter/material.dart';
import '../models/curso.dart';
import '../services/curso_service.dart';
import '../models/curso.dart';
import '../services/curso_service.dart';

class CursoFormView extends StatefulWidget {
  final Curso? item;

  const CursoFormView({super.key, this.item});

  @override
  State<CursoFormView> createState() => _CursoFormViewState();
}

class _CursoFormViewState extends State<CursoFormView> {
  final _formKey = GlobalKey<FormState>();
  final CursoService _service = CursoService();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _turnoController = TextEditingController();
  String? _selectedCursoId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _idController.text = widget.item!.id.toString();
      _nombreController.text = widget.item!.nombre.toString();
      _turnoController.text = widget.item!.turno.toString();
      if (widget.item!.cursoId.isNotEmpty) { _selectedCursoId = widget.item!.cursoId; }
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _nombreController.dispose();
    _turnoController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final item = Curso(
        capacidadMax: widget.item?.capacidadMax ?? 0,
          id: int.tryParse(_idController.text) ?? 0,
          nombre: _nombreController.text,
          turno: _turnoController.text,
          cursoId: _selectedCursoId ?? '',
      );

      if (widget.item == null) {
        await _service.create(item);
      } else {
        await _service.update(item.capacidadMax.toString(), item);
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
        title: Text(widget.item == null ? 'Crear Curso' : 'Editar Curso'),
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
                initialValue: widget.item!.capacidadMax.toString(),
                decoration: const InputDecoration(
                  labelText: 'capacidadMax (Auto)',
                  border: OutlineInputBorder(),
                ),
                enabled: false,
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
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'nombre',
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
              controller: _turnoController,
              decoration: const InputDecoration(
                labelText: 'turno',
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
