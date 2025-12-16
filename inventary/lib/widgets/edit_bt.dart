import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/color_palette.dart';

class InventaryButtonWidget extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;      
  final Color textColor;
  final double height;
  final int quantity;
  final bool isEditing;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final VoidCallback? onSave;
  final VoidCallback? onDelete; 
  final ValueChanged<int>? onQuantityChanged;
  final TextEditingController? quantityController;
  final TextEditingController? nameController;
  final ValueChanged<String>? onNameChanged;


  const InventaryButtonWidget({
    super.key,
    required this.text,
    this.color = TangareColor.white,
    required this.onPressed,
    this.textColor = TangareColor.orange,
    this.height = 55,
    required this.quantity,
    this.isEditing = false,
    this.onIncrement,
    this.onDecrement,
    this.onSave,
    this.onDelete,
    this.onQuantityChanged,
    this.quantityController,
    this.nameController,
  this.onNameChanged,

  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: TangareColor.orange,
          borderRadius: BorderRadius.circular(45),
        ),
        child: Stack(
  clipBehavior: Clip.none,
  children: [
    Padding(
      padding: EdgeInsets.only(
        top: isEditing ? 55 : 0,
        left: isEditing ? 10 : 0,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                 constraints: BoxConstraints(minHeight: height),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: isEditing ? TangareColor.lightYellow : color,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isEditing ? TangareColor.orange : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: isEditing
                    ? TextFormField(
                        controller: nameController,
                        autofocus: true,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        minLines: 1,
                        maxLines: 3,
                        style: const TextStyle(
                          color: TangareColor.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (v) {
                          if (onNameChanged == null) return;
                          onNameChanged!(v.trimLeft());
                        },

                      )
                    : Text(
                        text,
                        softWrap: true,
                        maxLines: 3,
                        overflow: TextOverflow.visible,
                        style: const TextStyle(
                          color: TangareColor.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                  
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                flex: 1,
                child: Container(
                  height: height,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isEditing ? TangareColor.lightYellow : TangareColor.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isEditing ? TangareColor.orange : TangareColor.lightYellow,
                      width: 2,
                    ),
                    boxShadow: [
                      if (isEditing)
                        const BoxShadow(
                          color: TangareColor.orange,
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                    ],
                  ),
                  child: isEditing
                      ? TextFormField(
                          controller: quantityController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: TangareColor.darkOrange,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onChanged: (value) {
                            if (onQuantityChanged == null) return;

                            final t = value.trim();
                            if (t.isEmpty) return;

                            final parsed = int.tryParse(t);
                            if (parsed != null && parsed >= 0) {
                              onQuantityChanged!(parsed);
                            }
                          },
                        )
                      : Text(
                          quantity.toString(),
                          style: const TextStyle(
                            color: TangareColor.darkOrange,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                ),
              ),

              const SizedBox(width: 16),

              Material(
                color: TangareColor.black,
                shape: const CircleBorder(),
                child: Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    color: TangareColor.black,
                    shape: BoxShape.circle,
                    border: Border.all(color: TangareColor.orange, width: 2),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: TangareColor.white,
                      size: 50,
                    ),
                    onPressed: () {
                      HapticFeedback.selectionClick();
                      onPressed();
                    },
                  ),
                ),
              ),
            ],
          ),

          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isEditing ? 1.0 : 0.0,
              child: isEditing
                  ? Column(
                      children: [
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 70,
                              height: 70,
                              child: ElevatedButton(
                                onPressed: onDecrement != null
                                    ? () {
                                        HapticFeedback.lightImpact();
                                        onDecrement!();
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: EdgeInsets.zero,
                                  backgroundColor: TangareColor.white,
                                  foregroundColor: TangareColor.orange,
                                  elevation: 4,
                                ),
                                child: const Icon(Icons.remove, size: 36),
                              ),
                            ),
                            SizedBox(
                              width: 70,
                              height: 70,
                              child: ElevatedButton(
                                onPressed: onIncrement != null
                                    ? () {
                                        HapticFeedback.lightImpact();
                                        onIncrement!();
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: EdgeInsets.zero,
                                  backgroundColor: TangareColor.white,
                                  foregroundColor: TangareColor.orange,
                                  elevation: 4,
                                ),
                                child: const Icon(Icons.add, size: 36),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: onSave != null
                                ? () {
                                    HapticFeedback.selectionClick();
                                    onSave!();
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: TangareColor.yellow,
                              foregroundColor: TangareColor.black,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'GUARDAR',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    ),

    // Delete ahora va dentro del área tocable (sin negativos)
    if (isEditing)
      Positioned(
        top: 0,
        left: 0,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: isEditing ? 1.0 : 0.0,
          child: SizedBox(
          width: 52, // un poquito más grande = mejor tap
          height: 52,
          child: ElevatedButton(
            onPressed: () async {
              HapticFeedback.selectionClick();
              final bool? confirmed = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: TangareColor.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: const Text(
                      'Eliminar elemento',
                      style: TextStyle(
                        color: TangareColor.darkOrange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: Text(
                      '¿Seguro que deseas eliminar "$text" del inventario?',
                      style: const TextStyle(
                        color: TangareColor.black,
                        fontSize: 16,
                      ),
                    ),
                    actionsAlignment: MainAxisAlignment.spaceBetween,
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          Navigator.of(context).pop(true);
                        },
                        child: const Text(
                          'Eliminar',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  );
                },
              );

              if (confirmed == true && onDelete != null) {
                onDelete!();
              }
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: EdgeInsets.zero,
              backgroundColor: TangareColor.lightYellow,
              foregroundColor: TangareColor.black,
              elevation: 4,
            ),
            child: const Icon(Icons.delete, size: 24),
          ),
        ),
      ),
    ),
  ],
),

        
      );
  }
}
