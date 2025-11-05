import 'package:flutter/material.dart';
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
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: TangareColor.orange,
          borderRadius: BorderRadius.circular(45),
        ),
        child: Stack(
          clipBehavior: Clip.none, 
          children: [
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        height: height,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          text,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: TangareColor.darkOrange,
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
                          color: TangareColor.lightYellow,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          quantity.toString(),
                          style: TextStyle(
                            color: TangareColor.darkOrange,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // Edition Button
                    Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        color: TangareColor.black,
                        shape: BoxShape.circle,
                        border: Border.all(color: TangareColor.orange, width: 2),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: TangareColor.white,
                          size: 50,
                        ),
                        onPressed: onPressed,
                      ),
                    ),
                  ],
                ),

                if (isEditing) ...[
                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 70,
                        height: 70,
                        child: ElevatedButton(
                          onPressed: onDecrement,
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(), // Complete circle
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
                          onPressed: onIncrement,
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
                      onPressed: onSave,
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
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),

            //Delete button
            if (isEditing)
              Positioned(
                top: -27,  
                left: -25,
                child: SizedBox(
                  width: 45,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () async {
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
                              style: TextStyle(
                                color: TangareColor.black,
                                fontSize: 16,
                              ),
                            ),
     actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: TangareColor.white,
            backgroundColor: TangareColor.orange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text(
            'Cancelar',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text(
            'Eliminar',
            style: TextStyle(fontWeight: FontWeight.bold),
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
                    child: const Icon(Icons.delete, size: 22),
                  ),
                ),
              ),
            
          ],
        ),
        
      ),
    );
  }
}
