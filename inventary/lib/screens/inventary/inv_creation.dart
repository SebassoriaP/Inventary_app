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
  final Map<String, String> _tempNames = {};
  final Map<String, TextEditingController> _nameControllers = {};


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

  String _getDisplayName(String id, String baseName) {
  if (_isEditing(id)) {
    return _tempNames[id] ?? baseName;
  }
  return baseName;
}

TextEditingController _getNameController(String id, String initialValue) {
  if (_nameControllers.containsKey(id)) {
    return _nameControllers[id]!;
  }
  final controller = TextEditingController(text: initialValue);
  _nameControllers[id] = controller;
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
void dispose() {
  for (final c in _qtyControllers.values) {
    c.dispose();
  }
  for (final c in _nameControllers.values) {
    c.dispose();
  }
  super.dispose();
}

  @override
Widget build(BuildContext context) {
  final bottomInset = MediaQuery.of(context).padding.bottom;

  return Scaffold(
    resizeToAvoidBottomInset: false,
    body: Stack(
      children: [
        // ✅ Main content (safe only on top, not bottom)
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
            child: Column(
              children: [
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
                  thickness: 2,
                  indent: 20,
                  endIndent: 20,
                ),
                const SizedBox(height: 15),

                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: forms.snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      final allDocs = snapshot.data!.docs;

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
                        padding: const EdgeInsets.only(bottom: 170),
                        itemCount: filteredDocs.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 20),
                        itemBuilder: (context, index) {
                          final doc = filteredDocs[index];
                          final data = doc.data() as Map<String, dynamic>;
                          final String id = doc.id;

                          final String itemName =
                              data['item']?.toString() ?? 'Sin nombre';

                          final dynamic rawCantidad = data['cantidad'];
                          final int baseCantidad = rawCantidad is int
                              ? rawCantidad
                              : int.tryParse(rawCantidad?.toString() ?? '0') ??
                                  0;

                          final int displayCantidad =
                              _getDisplayQuantity(id, baseCantidad);

                          final qtyController =
                              _getQtyController(id, displayCantidad);

                          final String displayName =
                              _getDisplayName(id, itemName);
                          final nameController =
                              _getNameController(id, displayName);

                          if (!_isEditing(id) &&
                              nameController.text != itemName) {
                            nameController.text = itemName;
                          }

                          return InventaryButtonWidget(
                            text: displayName,
                            quantity: displayCantidad,
                            isEditing: _isEditing(id),
                            quantityController: qtyController,
                            nameController: nameController,
                            onNameChanged: (v) =>
                                setState(() => _tempNames[id] = v),
                            onPressed: () {
                              setState(() {
                                final current = _isEditing(id);
                                if (current) {
                                  _editing[id] = false;
                                  _tempQuantities.remove(id);
                                  _tempNames.remove(id);
                                  qtyController.text = baseCantidad.toString();
                                  nameController.text = itemName;
                                } else {
                                  _editing[id] = true;
                                  _tempQuantities[id] = displayCantidad;
                                  _tempNames[id] = itemName;
                                  qtyController.text =
                                      displayCantidad.toString();
                                  nameController.text = itemName;
                                }
                              });
                            },
                            onIncrement: () {
                              setState(() {
                                final current =
                                    _tempQuantities[id] ?? baseCantidad;
                                final next = current + 1;
                                _tempQuantities[id] = next;
                                if (_isEditing(id)) {
                                  qtyController.text = next.toString();
                                }
                              });
                            },
                            onDecrement: () {
                              setState(() {
                                final current =
                                    _tempQuantities[id] ?? baseCantidad;
                                final safe =
                                    (current - 1) < 0 ? 0 : (current - 1);
                                _tempQuantities[id] = safe;
                                if (_isEditing(id)) {
                                  qtyController.text = safe.toString();
                                }
                              });
                            },
                            onQuantityChanged: (newValue) =>
                                setState(() => _tempQuantities[id] = newValue),
                            onSave: () async {
                              final newQty =
                                  _tempQuantities[id] ?? baseCantidad;
                              final newName =
                                  (_tempNames[id] ?? itemName).trim();
                              if (newName.isEmpty) return;

                              await doc.reference.update({
                                'cantidad': newQty,
                                'item': newName,
                              });

                              if (!mounted) return;
                              setState(() {
                                _editing[id] = false;
                                _tempQuantities.remove(id);
                                _tempNames.remove(id);
                                qtyController.text = newQty.toString();
                                nameController.text = newName;
                              });
                            },
                            onDelete: () async => doc.reference.delete(),
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

        // ✅ Footer MUST be sibling of SafeArea inside Stack
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FooterWidget(
                onPressed: _openAddItemSheet,
                topColor: Colors.transparent,
                bottomColor: TangareColor.black,
              ),
              Container(
                width: double.infinity,
                color: TangareColor.black,
                padding: EdgeInsets.only(
                  top: 15,
                  bottom: 50 + bottomInset, // ✅ fills the Android bottom area
                ),
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
          ),
        ),
      ],
    ),
  );
}
}