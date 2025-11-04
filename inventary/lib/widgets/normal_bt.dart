import 'package:flutter/material.dart';
import '../utils/color_palette.dart';

class InventaryButtonWidget extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;
  final Color textColor;
  final double height;
  final int quantity;

  const InventaryButtonWidget({
    super.key,
    required this.text,
    this.color = TangareColor.white,
    required this.onPressed,
    this.textColor = TangareColor.orange,
    this.height = 55,
    required this.quantity,
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
        child: Row(
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
                onPressed: onPressed, // usa la misma función o podrías cambiarla
              ),
            ),
          ],
        ),
      ),
    );
  }
}
