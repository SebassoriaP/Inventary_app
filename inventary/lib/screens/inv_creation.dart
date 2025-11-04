import 'package:flutter/material.dart';
import '../widgets/normal_bt.dart'; 


class InventaryScreen extends StatelessWidget {
  const InventaryScreen({super.key});

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
                onPressed: () {
                  debugPrint('Me presionaste');
                  //debugPrint('Me presionaste');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
