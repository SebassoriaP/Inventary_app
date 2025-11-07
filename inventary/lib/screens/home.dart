import 'package:flutter/material.dart';

import '../animation/smiles.dart';
import '../widgets/button.dart';
import '../utils/color_palette.dart';
import 'inventary.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // Detect the device orientation
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      body: SafeArea(
        // If it is horizontal we use scroll view to avoid overflow
        // If it is vertical we use the original layout
        child: isLandscape
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    SizedBox(
                      height: 220,
                      width: double.infinity,
                      child: SawCurveIntro(),
                    ),

                    const SizedBox(height: 16),

                    Image.asset(
                      'assets/tangare.png',
                      width: 200,
                      height: 150,
                      fit: BoxFit.contain,
                    ),

                    const SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      child: ButtonWidget(
                        text: 'Bienvenida Patricia',
                        color: TangareColor.orange,
                        textColor: TangareColor.white,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const InventaryPanel()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 220,
                          width: double.infinity,
                          child: SawCurveIntro(),
                          
                        ),
                        const SizedBox(height: 16),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                    child: ButtonWidget(
                      text: 'Bienvenida Patricia',
                      color: TangareColor.orange,
                      textColor: TangareColor.white,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const InventaryPanel()),
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
