import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../widgets/button.dart';
import '../../utils/color_palette.dart';

class InvResults extends StatefulWidget {
  const InvResults({super.key});

  @override
  State<InvResults> createState() => _InvResultsState();
}

class _InvResultsState extends State<InvResults> {
  final CollectionReference forms =
      FirebaseFirestore.instance.collection('inventario');

  Future<void> _exportCsv() async {
    try {
      // Read the Firestore
      final snapshot = await forms.get();
      
      if (!mounted) return;
      if (snapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No hay datos en el inventario para exportar',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: TangareColor.white,
                fontSize: 19,
              ),
            ),
            backgroundColor: TangareColor.orange,
          ),
        );
        return;
      }

      //Create the CSV content
      final buffer = StringBuffer();
      buffer.writeln('Item,Cantidad');

      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final item = (data['item'] ?? '').toString().replaceAll(',', ' ');
        final cantidad = data['cantidad'] ?? 0;

        buffer.writeln('$item,$cantidad');
      }

      // 3) Save the file in the device sandbox
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/inventario.csv';
      final file = File(path);
      await file.writeAsString(buffer.toString());

      //Share and download the file
      await Share.shareXFiles(
        [XFile(path)],
        text: 'Inventario exportado en CSV',
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al exportar: $e',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: TangareColor.white,
              fontSize: 19,
            ),
          ),
          backgroundColor: TangareColor.orange,
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TangareColor.white,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  const Color.fromRGBO(255, 255, 255, 0.5),
                  BlendMode.modulate,
                ),
                child: Image.asset(
                  'assets/tangare.png',
                  width: 250,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: TangareColor.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'TU INVENTARIO:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: TangareColor.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Divider(
                    color: TangareColor.black,
                    thickness: 2,
                    indent: 20,
                    endIndent: 20,
                  ),

                  const SizedBox(height: 10),

                  ButtonWidget(
                    text: 'Descargar Excel',
                    color: TangareColor.orange,
                    textColor: TangareColor.white,
                    onPressed: _exportCsv,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}