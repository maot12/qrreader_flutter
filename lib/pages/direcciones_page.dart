import 'package:flutter/material.dart';
import 'package:qrreader/widgets/widgets.dart';

class DireccionesPage extends StatelessWidget {

  const DireccionesPage({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
      return const ScanTiles(tipo: 'http');
    }
}