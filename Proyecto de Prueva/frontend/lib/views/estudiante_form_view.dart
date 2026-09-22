import 'package:flutter/material.dart';
import '../models/estudiante.dart';
import '../services/estudiante_service.dart';


class EstudianteFormView extends StatefulWidget {
  final Estudiante? item;

  const EstudianteFormView({super.key, this.item});

  @override
  State<EstudianteFormView> createState() => _EstudianteFormViewState();
}

class _EstudianteFormViewState extends State<EstudianteFormView> {
  final _formKey = GlobalKey<FormState>();
  final EstudianteService _service = EstudianteService();
  final TextEditingController _- apellidoController = TextEditingController();
  final TextEditingController _- celularController = TextEditingController();
  final TextEditingController _- ciController = TextEditingController();
  final TextEditingController _- fechaNacimientoController = TextEditingController();
  final TextEditingController _- idController = TextEditingController();
  final TextEditingController _- nombreController = TextEditingController();
  final TextEditingController _activoController = TextEditingController();
  final TextEditingController _codigoRudeController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _tutorContactoController = TextEditingController();
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
      _activoController.text = widget.item!.activo.toString();
      _codigoRudeController.text = widget.item!.codigoRude.toString();
      _idController.text = widget.item!.id.toString();
      _tutorContactoController.text = widget.item!.tutorContacto.toString();
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
    _activoController.dispose();
    _codigoRudeController.dispose();
    _idController.dispose();
    _tutorContactoController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final item = Estudiante(
        - apellido: _- apellidoController.text,
          - celular: _- celularController.text,
          - ci: _- ciController.text,
          - fechaNacimiento: _- fechaNacimientoController.text,
          - id: int.tryParse(_- idController.text) ?? 0,
          - nombre: _- nombreController.text,
          activo: _activoController.text,
          codigoRude: _codigoRudeController.text,
          id: int.tryParse(_idController.text) ?? 0,
          tutorContacto: _tutorContactoController.text,
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
        title: Text(widget.item == null ? 'Crear Estudiante' : 'Editar Estudiante'),
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
              controller: _activoController,
              decoration: const InputDecoration(
                labelText: 'activo',
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
              controller: _codigoRudeController,
              decoration: const InputDecoration(
                labelText: 'codigoRude',
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
              controller: _tutorContactoController,
              decoration: const InputDecoration(
                labelText: 'tutorContacto',
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
