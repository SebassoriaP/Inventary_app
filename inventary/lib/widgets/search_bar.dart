import 'package:flutter/material.dart';
import '../utils/color_palette.dart';

class SearchBarWidget extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  const SearchBarWidget({
    super.key,
    this.hintText = 'Buscar en inventario',
    this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: TangareColor.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: TangareColor.orange,
          width: 3,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search,
            color: TangareColor.orange,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: const TextStyle(
                fontSize: 16,
                color: TangareColor.black,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: TangareColor.black,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
