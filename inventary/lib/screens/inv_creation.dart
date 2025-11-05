import 'package:flutter/material.dart';
import '../widgets/edit_bt.dart'; 


class InventaryScreen extends StatefulWidget {
  const InventaryScreen({super.key});

@override
State<InventaryScreen> createState() => _InventaryScreenState();
}

class _InventaryScreenState extends State<InventaryScreen> {
  bool isEditing = false; 


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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: InventaryButtonWidget(
                text: 'Encofrado',
                quantity: 115,
                isEditing: isEditing,
                onPressed: () {
                  //debugPrint('Me presionaste');
                  setState(() {
                    isEditing = !isEditing; // altern edition mode and normal mode
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
