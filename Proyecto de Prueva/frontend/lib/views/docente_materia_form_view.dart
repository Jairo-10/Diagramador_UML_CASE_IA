import 'package:flutter/material.dart';
import '../models/docente_materia.dart';
import '../models/docente.dart';
import '../models/materia.dart';
import '../services/docente_materia_service.dart';
import '../services/docente_service.dart';
import '../services/materia_service.dart';

class DocenteMateriaFormView extends StatefulWidget {
  final DocenteMateria? item;

  const DocenteMateriaFormView({super.key, this.item});

  @override
  State<DocenteMateriaFormView> createState() => _DocenteMateriaFormViewState();
}

class _DocenteMateriaFormViewState extends State<DocenteMateriaFormView> {
  final _formKey = GlobalKey<FormState>();
  final DocenteMateriaService _service = DocenteMateriaService();
  final DocenteService _docenteService = DocenteService();
  final MateriaService _materiaService = MateriaService();
  
  bool _isLoading = false;
  List<Docente> _docenteOptions = [];
  List<Materia> _materiaOptions = [];
  int? _selectedDocenteId;
  int? _selectedMateriaId;

  @override
  void initState() {
    super.initState();
    _loadOptions();
    if (widget.item != null) {
      _selectedDocenteId = widget.item!.docenteid;
      _selectedMateriaId = widget.item!.materiaid;
    }
  }

  Future<void> _loadOptions() async {
    try {
      final docenteList = await _docenteService.getAll();
      final materiaList = await _materiaService.getAll();
      setState(() {
        _docenteOptions = docenteList;
        _materiaOptions = materiaList;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar opciones: $e')),
        );
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDocenteId == null || _selectedMateriaId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes seleccionar ambas entidades')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final item = DocenteMateria(
        id: widget.item?.id ?? 0,
        docenteid: _selectedDocenteId!,
        materiaid: _selectedMateriaId!,
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
                ? 'Relación creada exitosamente'
                : 'Relación actualizada exitosamente'),
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
        title: Text(widget.item == null ? 'Crear Relación DocenteMateria' : 'Editar Relación DocenteMateria'),
        backgroundColor: Colors.purple,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    DropdownButtonFormField<int>(
                      value: _selectedDocenteId,
                      decoration: const InputDecoration(
                        labelText: 'Seleccionar Docente',
                        border: OutlineInputBorder(),
                      ),
                      items: _docenteOptions.map((item) {
                        return DropdownMenuItem<int>(
                          value: item.id,
                          child: Text(item.toString()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedDocenteId = value);
                      },
                      validator: (value) {
                        if (value == null) return 'Debes seleccionar una opción';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: _selectedMateriaId,
                      decoration: const InputDecoration(
                        labelText: 'Seleccionar Materia',
                        border: OutlineInputBorder(),
                      ),
                      items: _materiaOptions.map((item) {
                        return DropdownMenuItem<int>(
                          value: item.id,
                          child: Text(item.toString()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedMateriaId = value);
                      },
                      validator: (value) {
                        if (value == null) return 'Debes seleccionar una opción';
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
                          widget.item == null ? 'Crear Relación' : 'Actualizar Relación',
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
