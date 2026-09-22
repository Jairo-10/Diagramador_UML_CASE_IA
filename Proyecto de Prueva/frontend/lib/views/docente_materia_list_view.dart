import 'package:flutter/material.dart';
import '../models/docente_materia.dart';
import '../services/docente_materia_service.dart';
import 'docente_materia_form_view.dart';
import 'docente_materia_detail_view.dart';

class DocenteMateriaListView extends StatefulWidget {
  const DocenteMateriaListView({super.key});

  @override
  State<DocenteMateriaListView> createState() => _DocenteMateriaListViewState();
}

class _DocenteMateriaListViewState extends State<DocenteMateriaListView> {
  final DocenteMateriaService _service = DocenteMateriaService();
  List<DocenteMateria> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    setState(() => _isLoading = true);
    try {
      final items = await _service.getAll();
      setState(() {
        _items = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar: $e')),
        );
      }
    }
  }

  Future<void> _deleteItem(String id) async {
    try {
      await _service.delete(id);
      _loadItems();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Eliminado exitosamente')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DocenteMateria (Relación)'),
        backgroundColor: Colors.purple,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? const Center(
                  child: Text('No hay relaciones. ¡Crea una nueva!'),
                )
              : ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    final firstDisplay = item.docente?.toString() ?? 'ID: ${item.docenteid}';
                    final secondDisplay = item.materia?.toString() ?? 'ID: ${item.materiaid}';
                    
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.link, color: Colors.purple),
                        title: Text('Docente ↔ Materia'),
                        subtitle: Text('$firstDisplay → $secondDisplay'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DocenteMateriaFormView(
                                      item: item,
                                    ),
                                  ),
                                );
                                _loadItems();
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Confirmar'),
                                    content: const Text(
                                      '¿Deseas eliminar esta relación?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Cancelar'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          _deleteItem(item.id.toString());
                                        },
                                        child: const Text('Eliminar'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DocenteMateriaDetailView(item: item),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DocenteMateriaFormView(),
            ),
          );
          _loadItems();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
