import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qrreader/models/scan_model.dart';

import 'package:qrreader/pages/pages.dart';
import 'package:qrreader/providers/providers.dart';

import 'package:qrreader/widgets/widgets.dart';

import '../providers/ui_provider.dart';

class HomePage extends StatelessWidget {

  const HomePage({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Historial'),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_forever),
                onPressed: () {

                  Provider.of<ScanListProvider>(context, listen: false).borrarTodos();

                },
              )
            ],
          ),
            body: _HomePageBody(),

          floatingActionButton: ScanButton(),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: CustomNavigationBar(),//Center
        ); //Scaffold
    }
}

class _HomePageBody extends StatelessWidget {
  const _HomePageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Obtener el select menu opt
    final uiProvider = Provider.of<UiProvider>(context);

    //Cambiar para monstrar la pagina respectiva
    final currentIndex = uiProvider.selectedMenuOpt;

    //Usar el ScanListProvider
    final scanListProvider = Provider.of<ScanListProvider>(context, listen: false);

    switch(currentIndex) {
      case 0:
        scanListProvider.cargarScansPorTipo('geo');
        return MapasPage();
      case 1:
        scanListProvider.cargarScansPorTipo('http');
        return DireccionesPage();
      default:
        return MapasPage();
    }
  }
}
