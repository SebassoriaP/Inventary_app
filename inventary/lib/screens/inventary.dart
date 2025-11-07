import 'package:flutter/material.dart';

import '../utils/color_palette.dart';

// import 'package:inventary/screens/home.dart';
import './inventary/inv_creation.dart';
import './inventary/inv_results.dart';


class InventaryPanel extends StatefulWidget {
  const InventaryPanel({super.key});

  @override
  State<InventaryPanel> createState() => _InventaryPanelState();
}

class _InventaryPanelState extends State<InventaryPanel> {

  //Boton de volver atrás, lo quite pq nose que tan útil resulte
  // void _goHome() {
  //   Navigator.pushAndRemoveUntil(
  //     context,
  //     MaterialPageRoute(builder: (_) => const HomeScreen()),
  //     (route) => false,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: TangareColor.orange,
          title: const Text(
            'Bienvenida Mamant!!!',
            style: TextStyle(
              color: TangareColor.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: const IconThemeData(color: TangareColor.white),
          actions: [
            // IconButton(
            //   icon: const Icon(Icons.logout),
            //   onPressed: _goHome,
            // ),
          ],
          bottom: const TabBar(
            indicatorColor: TangareColor.yellow,
            labelColor: TangareColor.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'EDICIÓN DE INVENTARIO'),
              Tab(text: 'RESULTADOS'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [InventaryScreen(), InvResults()],
        ),
      ),
    );
  }
}