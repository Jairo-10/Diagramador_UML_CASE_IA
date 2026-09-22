import 'package:flutter/material.dart';
import '../models/persona.dart';
import '../services/persona_service.dart';


class PersonaFormView extends StatefulWidget {
  final Persona? item;

  const PersonaFormView({super.key, this.item});

  @override
  State<PersonaFormView> createState() => _PersonaFormViewState();
}

class _PersonaFormViewState extends State<PersonaFormView> {
  final _formKey = GlobalKey<FormState>();
  final PersonaService _service = PersonaService();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _celularController = TextEditingController();
  final TextEditingController _ciController = TextEditingController();
  final TextEditingController _fechaNacimientoController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _apellidoController.text = widget.item!.apellido.toString();
      _celularController.text = widget.item!.celular.toString();
      _ciController.text = widget.item!.ci.toString();
      _fechaNacimientoController.text = widget.item!.fechaNacimiento.toString();
      _idController.text = widget.item!.id.toString();
      _nombreController.text = widget.item!.nombre.toString();
    }
  }

  @override
  void dispose() {
    _apellidoController.dispose();
    _celularController.dispose();
    _ciController.dispose();
    _fechaNacimientoController.dispose();
    _idController.dispose();
    _nombreController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final item = Persona(
        apellido: _apellidoController.text,
          celular: _celularController.text,
          ci: _ciController.text,
          fechaNacimiento: _fechaNacimientoController.text,
          id: int.tryParse(_idController.text) ?? 0,
          nombre: _nombreController.text,
      );

      if (widget.item == null) {
        await _service.create(item);
      } else {
        await _service.update(item.apellido.toString(), item);
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
        title: Text(widget.item == null ? 'Crear Persona' : 'Editar Persona'),
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
              controller: _apellidoController,
              decoration: const InputDecoration(
                labelText: 'apellido',
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
              controller: _celularController,
              decoration: const InputDecoration(
                labelText: 'celular',
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
              controller: _ciController,
              decoration: const InputDecoration(
                labelText: 'ci',
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
              controller: _fechaNacimientoController,
              decoration: const InputDecoration(
                labelText: 'fechaNacimiento',
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
