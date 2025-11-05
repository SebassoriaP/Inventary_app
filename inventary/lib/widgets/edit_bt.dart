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

  const InventaryButtonWidget({
    super.key,
    required this.text,
    this.color = TangareColor.white,
    required this.onPressed,
    this.textColor = TangareColor.orange,
    this.height = 55,
    required this.quantity,
    this.isEditing = false,
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
        child: Column(
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
                        color: textColor,
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
                  ElevatedButton(
                    onPressed: () {
                      debugPrint('Reducir cantidad');
                    },
                    child: const Icon(Icons.remove),
                  ),
                  
                  ElevatedButton(
                    onPressed: () {
                       debugPrint('Aumentar cantidad');
                    },
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
