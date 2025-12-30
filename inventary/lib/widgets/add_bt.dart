import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventary/utils/color_palette.dart';

class FooterWidget extends StatefulWidget  {
  final VoidCallback onPressed;

  final Color topColor; 
  final Color bottomColor; 

  const FooterWidget({
    super.key,
    required this.onPressed,
    this.topColor = Colors.transparent,
    this.bottomColor = TangareColor.black,
  });

  @override
  State<FooterWidget> createState() => _FooterWidgetState();
}

class _FooterWidgetState extends State<FooterWidget> {
  bool _pressed = false;

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
              color: widget.topColor,
            ),
            Container(
              color: widget.bottomColor,
              padding: const EdgeInsets.only(top: 30, bottom: 20),
              width: double.infinity,
            ),
          ],
        ),

        // Botón circular encima animado
        Positioned(
          top: 0,
          child: AnimatedScale(
            scale: _pressed ? 0.92 : 1.0,
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            child: AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    if (!_pressed)
                      const BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
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
                    onTapDown: (_) {
                      setState(() => _pressed = true);
                      HapticFeedback.selectionClick();
                    },
                    onTapUp: (_) {
                        setState(() => _pressed = false);
                        widget.onPressed();
                    },
                    onTapCancel: () {
                      setState(() => _pressed = false);
                    },
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
          ),
        ),
      ],
    );
  }
}
