import 'package:flutter/material.dart';
import '../animation/smiles.dart';
import '../widgets/button.dart';
import '../utils/color_palette.dart';
import './inv_creation.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // centra verticalmente dentro del espacio
                children: [
                  SizedBox(
                    height: 220,
                    width: double.infinity,
                    child: SawCurveIntro(),
                  ),


           
                  Image.asset(
                    'assets/tangare.png', 
                    width: 200,
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: ButtonWidget(
                text: 'Bienvenida Patricia',
                color: TangareColor.orange,
                textColor: TangareColor.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const InventaryScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
