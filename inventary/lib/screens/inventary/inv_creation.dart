import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:inventary/utils/color_palette.dart';

import '../../widgets/edit_bt.dart';
import '../../widgets/search_bar.dart';
import '../../widgets/add_bt.dart';


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

  final Map<String, TextEditingController> _qtyControllers = {};
  //Text that the user write in the search bar
  String _searchTerm = '';

  bool _isEditing(String id) => _editing[id] ?? false;

  int _getDisplayQuantity(String id, int baseQty) {
    if (_isEditing(id)) {
      return _tempQuantities[id] ?? baseQty;
    }
    return baseQty;
  }

  TextEditingController _getQtyController(String id, int initialValue) {
    if (_qtyControllers.containsKey(id)) {
      return _qtyControllers[id]!;
    }
    final controller = TextEditingController(text: initialValue.toString());
    _qtyControllers[id] = controller;
    return controller;
  }


  //Add button function
  void _openAddItemSheet() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController qtyController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // para que suba con el teclado
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final bottomInset = MediaQuery.of(ctx).viewInsets.bottom;

        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: bottomInset + 65,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Agregar Nuevo Ítem',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: TangareColor.orange,
                  ),
                ),
                const SizedBox(height: 16),

                // Item name
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Nombre del ítem',
                    filled: true,
                    fillColor: TangareColor.white,
                    labelStyle: const TextStyle(color: TangareColor.darkOrange),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: TangareColor.orange, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: TangareColor.darkOrange, width: 2.5),
                    ),
                  ),
                  style: const TextStyle(color: TangareColor.darkOrange, fontWeight: FontWeight.bold),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ingresa un nombre de un Item';
                    }
                    return null;
                  },
                ),


                const SizedBox(height: 12),

                // Quantity input
                TextFormField(
                  controller: qtyController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Cantidad',
                    filled: true,
                    fillColor: TangareColor.white,
                    labelStyle: const TextStyle(color: TangareColor.darkOrange),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: TangareColor.orange, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: TangareColor.darkOrange, width: 2.5),
                    ),
                  ),
                  
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ingresa una cantidad';
                    }
                    final parsed = int.tryParse(value.trim());
                    if (parsed == null || parsed < 0) {
                      return 'Ingresa un número válido';
                    }
                    return null;
                  },
                  style: const TextStyle(color: TangareColor.darkOrange, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                // Botones
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: TangareColor.white,
                          backgroundColor: TangareColor.black, 
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 12),

                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TangareColor.orange, 
                          foregroundColor: TangareColor.white, 
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                        ),
                        onPressed: () async {
                          if (!formKey.currentState!.validate()) return;

                          final name = nameController.text.trim();
                          final qty =
                              int.parse(qtyController.text.trim());

                          try {
                            await forms.add({
                              'item': name,
                              'cantidad': qty,
                            });

                            if (!mounted) return;

                            Navigator.of(context).pop(); 

                            //Messages notification
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Ítem agregado al inventario',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: TangareColor.white,
                                    fontSize: 19,
                                  ),
                                ),
                                backgroundColor: TangareColor.orange,
                              ),
                            );
                          } catch (e) {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Error al agregar: $e',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: TangareColor.white,
                                    fontSize: 19,
                                  ),
                                ),
                                backgroundColor: TangareColor.orange,
                              ),
                            );
                          }
                        },
                        child: const Text(
                          'Guardar',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
          child: Column(
            children: [
              // Search bar
              SearchBarWidget(
                onChanged: (value) {
                  setState(() {
                    _searchTerm = value.trim().toLowerCase();
                  });
                },
              ),

              const SizedBox(height: 15),

              const Divider(
                color: TangareColor.orange,
                thickness:2,
                indent: 20,
                endIndent: 20,
              ),
              const SizedBox(height: 15),

              // Items list
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: forms.snapshots(),
                  builder: (context, snapshot) {
                    // Loader inicial
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }

                    final allDocs = snapshot.data!.docs;

                    // Filtrar por searchTerm (en campo 'item')
                    final filteredDocs = allDocs.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final itemName =
                          data['item']?.toString().toLowerCase() ?? '';
                      if (_searchTerm.isEmpty) return true;
                      return itemName.contains(_searchTerm);
                    }).toList();

                    if (filteredDocs.isEmpty) {
                      return Center(
                        child: Text(
                          _searchTerm.isEmpty
                              ? 'No hay elementos en el inventario'
                              : 'No hay resultados para $_searchTerm',
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: filteredDocs.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 20),
                      itemBuilder: (context, index) {
                        final doc = filteredDocs[index];
                        final data = doc.data() as Map<String, dynamic>;
                        final String id = doc.id;

                        final String itemName =
                            data['item']?.toString() ?? 'Sin nombre';

                        final dynamic rawCantidad = data['cantidad'];
                        final int baseCantidad = rawCantidad is int
                            ? rawCantidad
                            : int.tryParse(
                                      rawCantidad?.toString() ?? '0',
                                    ) ??
                                0;

                        final int displayCantidad = _getDisplayQuantity(id, baseCantidad);

                        final qtyController = _getQtyController(id, displayCantidad);

                        return InventaryButtonWidget(
                          text: itemName,
                          quantity: displayCantidad,
                          isEditing: _isEditing(id),

                          quantityController: qtyController,

                          // Edit (toggle edition mode)
                          onPressed: () {
                            setState(() {
                              final current = _isEditing(id);
                              if (current) {
                                _editing[id] = false;
                                _tempQuantities.remove(id);
                                qtyController.text = baseCantidad.toString();
                              } else {
                                _editing[id] = true;
                                _tempQuantities[id] = displayCantidad;
                                qtyController.text = displayCantidad.toString();
                              }
                            });
                          },

                          // Botón +
                          onIncrement: () {
                            setState(() {
                              final current = _tempQuantities[id] ?? baseCantidad;
                              final next = current + 1;
                              _tempQuantities[id] = next;

                              if (_isEditing(id)) {
                                qtyController.text = next.toString();
                              }
                            });
                          },

                          // Botón -
                          onDecrement: () {
                            setState(() {
                              final current = _tempQuantities[id] ?? baseCantidad;
                              final next = current - 1;
                              final safe = next < 0 ? 0 : next;
                              _tempQuantities[id] = safe;

                              if (_isEditing(id)) {
                                qtyController.text = safe.toString();
                              }
                            });
                          },

                          // Cuando el usuario escribe en el input
                          onQuantityChanged: (newValue) {
                            setState(() {
                              _tempQuantities[id] = newValue;
                            });
                          },

                          // Save on Firestore
                          onSave: () async {
                            final newQty =
                                _tempQuantities[id] ?? baseCantidad;

                            try {
                              await doc.reference
                                  .update({'cantidad': newQty});

                              if (!mounted) return;

                              setState(() {
                                _editing[id] = false;
                                _tempQuantities.remove(id);
                                qtyController.text = newQty.toString();
                              });

                              ScaffoldMessenger.of(this.context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Inventario actualizado',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: TangareColor.white,
                                      fontSize: 19,
                                    ),
                                  ),
                                  backgroundColor: TangareColor.orange,
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
                                      color: TangareColor.white,
                                      fontSize: 19,
                                    ),
                                  ),
                                  backgroundColor: TangareColor.orange,
                                ),
                              );
                            }
                          },

                          // Delete Element
                          onDelete: () async {
                            try {
                              await doc.reference.delete();

                              if (!mounted) return;
                              ScaffoldMessenger.of(this.context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Elemento "$itemName" eliminado del inventario',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: TangareColor.white,
                                      fontSize: 19,
                                    ),
                                  ),
                                  backgroundColor: TangareColor.orange,
                                ),
                              );
                            } catch (e) {
                              if (!mounted) return;
                              ScaffoldMessenger.of(this.context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Error al eliminar: $e',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: TangareColor.white,
                                      fontSize: 19,
                                    ),
                                  ),
                                  backgroundColor: TangareColor.orange,
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
            ],
          ),
        ),
      ),

      bottomNavigationBar: Builder(
          builder: (context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FooterWidget(
                  onPressed: _openAddItemSheet,
                    //debugPrint('Me presionaste');
                ),

                Container(
                  width: double.infinity,
                  color: TangareColor.black,
                  padding: const EdgeInsets.only(top: 15, bottom: 60),
                  child: const Text(
                    'Agregar Nuevo Item',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: TangareColor.white,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
    );
  }
}
