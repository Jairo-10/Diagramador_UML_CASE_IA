import 'package:flutter/material.dart';
import '../models/docente.dart';
import '../services/docente_service.dart';
import '../models/curso.dart';
import '../services/curso_service.dart';

class DocenteFormView extends StatefulWidget {
  final Docente? item;

  const DocenteFormView({super.key, this.item});

  @override
  State<DocenteFormView> createState() => _DocenteFormViewState();
}

class _DocenteFormViewState extends State<DocenteFormView> {
  final _formKey = GlobalKey<FormState>();
  final DocenteService _service = DocenteService();
  final TextEditingController _- apellidoController = TextEditingController();
  final TextEditingController _- celularController = TextEditingController();
  final TextEditingController _- ciController = TextEditingController();
  final TextEditingController _- fechaNacimientoController = TextEditingController();
  final TextEditingController _- idController = TextEditingController();
  final TextEditingController _- nombreController = TextEditingController();
  final TextEditingController _especialidadController = TextEditingController();
  final TextEditingController _fechaContratoController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _salarioController = TextEditingController();
  String? _selectedCursoId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _- apellidoController.text = widget.item!.- apellido.toString();
      _- celularController.text = widget.item!.- celular.toString();
      _- ciController.text = widget.item!.- ci.toString();
      _- fechaNacimientoController.text = widget.item!.- fechaNacimiento.toString();
      _- idController.text = widget.item!.- id.toString();
      _- nombreController.text = widget.item!.- nombre.toString();
      _especialidadController.text = widget.item!.especialidad.toString();
      _fechaContratoController.text = widget.item!.fechaContrato.toString();
      _idController.text = widget.item!.id.toString();
      _salarioController.text = widget.item!.salario.toString();
      if (widget.item!.cursoId.isNotEmpty) { _selectedCursoId = widget.item!.cursoId; }
    }
  }

  @override
  void dispose() {
    _- apellidoController.dispose();
    _- celularController.dispose();
    _- ciController.dispose();
    _- fechaNacimientoController.dispose();
    _- idController.dispose();
    _- nombreController.dispose();
    _especialidadController.dispose();
    _fechaContratoController.dispose();
    _idController.dispose();
    _salarioController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final item = Docente(
        - apellido: _- apellidoController.text,
          - celular: _- celularController.text,
          - ci: _- ciController.text,
          - fechaNacimiento: _- fechaNacimientoController.text,
          - id: int.tryParse(_- idController.text) ?? 0,
          - nombre: _- nombreController.text,
          especialidad: _especialidadController.text,
          fechaContrato: _fechaContratoController.text,
          id: int.tryParse(_idController.text) ?? 0,
          salario: _salarioController.text,
          cursoId: _selectedCursoId ?? '',
      );

      if (widget.item == null) {
        await _service.create(item);
      } else {
        await _service.update(item.- apellido.toString(), item);
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
        title: Text(widget.item == null ? 'Crear Docente' : 'Editar Docente'),
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
              controller: _- apellidoController,
              decoration: const InputDecoration(
                labelText: '- apellido',
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
              controller: _- celularController,
              decoration: const InputDecoration(
                labelText: '- celular',
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
              controller: _- ciController,
              decoration: const InputDecoration(
                labelText: '- ci',
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
              controller: _- fechaNacimientoController,
              decoration: const InputDecoration(
                labelText: '- fechaNacimiento',
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
              controller: _- idController,
              decoration: const InputDecoration(
                labelText: '- id',
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
              controller: _- nombreController,
              decoration: const InputDecoration(
                labelText: '- nombre',
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
              controller: _especialidadController,
              decoration: const InputDecoration(
                labelText: 'especialidad',
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
              controller: _fechaContratoController,
              decoration: const InputDecoration(
                labelText: 'fechaContrato',
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
              controller: _salarioController,
              decoration: const InputDecoration(
                labelText: 'salario',
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
