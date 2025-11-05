import 'package:flutter/material.dart';
import 'package:inventary/utils/color_palette.dart';
import '../widgets/edit_bt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InventaryScreen extends StatefulWidget {
  const InventaryScreen({super.key});

  @override
  State<InventaryScreen> createState() => _InventaryScreenState();
}

class _InventaryScreenState extends State<InventaryScreen> {
  final CollectionReference forms =
      FirebaseFirestore.instance.collection('inventario');

  // Estado local por item
  final Map<String, bool> _editing = {};
  final Map<String, int> _tempQuantities = {};

  bool _isEditing(String id) => _editing[id] ?? false;

  int _getDisplayQuantity(String id, int baseQty) {
    return _tempQuantities[id] ?? baseQty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Inventario",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
          child: StreamBuilder<QuerySnapshot>(
            stream: forms.snapshots(),
            builder: (context, snapshot) {
              // Solo mostramos loader si aún no hay datos
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              final docs = snapshot.data!.docs;

              if (docs.isEmpty) {
                return const Center(
                  child: Text(
                    'No hay elementos en el inventario',
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }

              return ListView.separated(
                itemCount: docs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 20),
                itemBuilder: (context, index) {
                  final doc = docs[index];
                  final data = doc.data() as Map<String, dynamic>;
                  final String id = doc.id;

                  final String itemName =
                      data['item']?.toString() ?? 'Sin nombre';

                  final dynamic rawCantidad = data['cantidad'];
                  final int baseCantidad = rawCantidad is int
                      ? rawCantidad
                      : int.tryParse(rawCantidad?.toString() ?? '0') ?? 0;

                  final int displayCantidad =
                      _getDisplayQuantity(id, baseCantidad);

                  return InventaryButtonWidget(
                    text: itemName,
                    quantity: displayCantidad,
                    isEditing: _isEditing(id),
                    // Editar (toggle modo edición)
                    onPressed: () {
                      setState(() {
                        final current = _isEditing(id);
                        _editing[id] = !current;

                        if (!current && !_tempQuantities.containsKey(id)) {
                          _tempQuantities[id] = baseCantidad;
                        }
                      });
                    },
                    // Botón +
                    onIncrement: () {
                      setState(() {
                        final current = _tempQuantities[id] ?? baseCantidad;
                        _tempQuantities[id] = current + 1;
                      });
                    },
                    // Botón -
                    onDecrement: () {
                      setState(() {
                        final current = _tempQuantities[id] ?? baseCantidad;
                        final next = current - 1;
                        _tempQuantities[id] = next < 0 ? 0 : next;
                      });
                    },
                    // Save - Update Firestore
                    onSave: () async {
                      final newQty =
                          _tempQuantities[id] ?? baseCantidad;

                      try {
                        await doc.reference.update({'cantidad': newQty});

                        if (!mounted) return;

                        setState(() {
                          _editing[id] = false;
                          _tempQuantities.remove(id);
                        });

                        ScaffoldMessenger.of(this.context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Inventario actualizado',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: TangareColor.white
                              )
                            ),
                            backgroundColor: TangareColor.darkOrange,
                          ),
                        );
                      } catch (e) {
                        if (!mounted) return;

                        ScaffoldMessenger.of(this.context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Error al guardar: $e',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: TangareColor.white
                              )
                            ),
                            backgroundColor: TangareColor.darkOrange,                            
                          ),
                        );
                      }
                    },
                    onDelete: () async {
                      try {
                        await doc.reference.delete();

                        if (!mounted) return;
                        ScaffoldMessenger.of(this.context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Elemento "$itemName" eliminado del inventario',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: TangareColor.white
                              )
                            ),
                            backgroundColor: TangareColor.darkOrange,
                          ),
                        );

                      } catch (e) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(this.context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Error al eliminar: $e',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: TangareColor.white
                              )
                            ),
                            backgroundColor: TangareColor.darkOrange,
                          ),
                        );
                      }
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
