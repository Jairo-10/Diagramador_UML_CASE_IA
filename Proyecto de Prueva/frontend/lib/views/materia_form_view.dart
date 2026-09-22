import 'package:flutter/material.dart';
import '../models/materia.dart';
import '../services/materia_service.dart';


class MateriaFormView extends StatefulWidget {
  final Materia? item;

  const MateriaFormView({super.key, this.item});

  @override
  State<MateriaFormView> createState() => _MateriaFormViewState();
}

class _MateriaFormViewState extends State<MateriaFormView> {
  final _formKey = GlobalKey<FormState>();
  final MateriaService _service = MateriaService();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _siglaController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _idController.text = widget.item!.id.toString();
      _nombreController.text = widget.item!.nombre.toString();
      _siglaController.text = widget.item!.sigla.toString();
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _nombreController.dispose();
    _siglaController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final item = Materia(
        horasSemanales: widget.item?.horasSemanales ?? 0,
          id: int.tryParse(_idController.text) ?? 0,
          nombre: _nombreController.text,
          sigla: _siglaController.text,
      );

      if (widget.item == null) {
        await _service.create(item);
      } else {
        await _service.update(item.horasSemanales.toString(), item);
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
        title: Text(widget.item == null ? 'Crear Materia' : 'Editar Materia'),
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
                initialValue: widget.item!.horasSemanales.toString(),
                decoration: const InputDecoration(
                  labelText: 'horasSemanales (Auto)',
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
              controller: _siglaController,
              decoration: const InputDecoration(
                labelText: 'sigla',
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
