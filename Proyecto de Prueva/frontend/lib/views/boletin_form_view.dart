import 'package:flutter/material.dart';
import '../models/boletin.dart';
import '../services/boletin_service.dart';


class BoletinFormView extends StatefulWidget {
  final Boletin? item;

  const BoletinFormView({super.key, this.item});

  @override
  State<BoletinFormView> createState() => _BoletinFormViewState();
}

class _BoletinFormViewState extends State<BoletinFormView> {
  final _formKey = GlobalKey<FormState>();
  final BoletinService _service = BoletinService();
  final TextEditingController _codigoVerificacionController = TextEditingController();
  final TextEditingController _fechaEmisionController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _promedioGeneralController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _codigoVerificacionController.text = widget.item!.codigoVerificacion.toString();
      _fechaEmisionController.text = widget.item!.fechaEmision.toString();
      _idController.text = widget.item!.id.toString();
      _promedioGeneralController.text = widget.item!.promedioGeneral.toString();
    }
  }

  @override
  void dispose() {
    _codigoVerificacionController.dispose();
    _fechaEmisionController.dispose();
    _idController.dispose();
    _promedioGeneralController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final item = Boletin(
        codigoVerificacion: _codigoVerificacionController.text,
          fechaEmision: _fechaEmisionController.text,
          id: int.tryParse(_idController.text) ?? 0,
          promedioGeneral: _promedioGeneralController.text,
      );

      if (widget.item == null) {
        await _service.create(item);
      } else {
        await _service.update(item.codigoVerificacion.toString(), item);
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
        title: Text(widget.item == null ? 'Crear Boletin' : 'Editar Boletin'),
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
              controller: _codigoVerificacionController,
              decoration: const InputDecoration(
                labelText: 'codigoVerificacion',
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
              controller: _fechaEmisionController,
              decoration: const InputDecoration(
                labelText: 'fechaEmision',
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
              controller: _promedioGeneralController,
              decoration: const InputDecoration(
                labelText: 'promedioGeneral',
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
