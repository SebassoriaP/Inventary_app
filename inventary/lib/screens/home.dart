import 'package:flutter/material.dart';
import '../animation/smiles.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "PRUEBAAAAA",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Franja superior con la animación (ajusta altura a tu gusto)
            SizedBox(
              height: 220,
              width: double.infinity,
              child: SawCurveIntro(
                // onFinished: () => Navigator.pushReplacementNamed(context, '/home'),
              ),
            ),

            // Resto de tu pantalla...
            Expanded(
              child: Center(
                child: Text(
                  'Contenido de Home',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
