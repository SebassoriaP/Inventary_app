import 'package:flutter/material.dart';
import 'package:inventary/utils/color_palette.dart';

class FooterWidget extends StatelessWidget {
  final VoidCallback onPressed;

  final Color topColor; 
  final Color bottomColor; 

  const FooterWidget({
    super.key,
    required this.onPressed,
    this.topColor = Colors.transparent,
    this.bottomColor = TangareColor.orange,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        // Fondo dividido
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 30, // mitad del botón
              color: topColor,
            ),
            Container(
              color: bottomColor,
              padding: const EdgeInsets.only(top: 30, bottom: 20),
              width: double.infinity,
            ),
          ],
        ),

        // Botón circular encima
        Positioned(
          top: 0,
          child: Material(
            shape: const CircleBorder(),
            color: Colors.transparent,
            child: Ink(
              decoration: BoxDecoration(
                color: TangareColor.lightYellow,
                shape: BoxShape.circle,
                border: Border.all(color: TangareColor.orange, width: 10),
              ),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onPressed,
                child: const SizedBox(
                  width: 60,
                  height: 60,
                  child: Icon(
                    Icons.add,
                    color: TangareColor.darkOrange,
                    size: 50,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
