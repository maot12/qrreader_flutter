import 'package:flutter/material.dart';
import 'package:qrreader/models/scan_model.dart';
import 'package:qrreader/providers/db_provider.dart';

class ScanListProvider extends ChangeNotifier {
  List<ScanModel> scans = [];
  String tipoSeleccionado = 'http';
  
  nuevoScan(String valor) async{
    final nuevoScan = new ScanModel(valor: valor);
    final id = await DBProvider.db.nuevoScan(nuevoScan);
    //Asignar el ID de la base de datos al modelo
    nuevoScan.id = id;

    if(tipoSeleccionado == nuevoScan.tipo) {
      scans.add(nuevoScan);
      notifyListeners();
    }
  }

  cargarScans() async{
    final scans = await DBProvider.db.getTodosLosScans();
    this.scans = [...?scans];
    notifyListeners();
  }

  cargarScansPorTipo(String tipo) async{
    final scans = await DBProvider.db.getScansPorTipo(tipo);
    this.scans = [...?scans];
    tipoSeleccionado = tipo;
    notifyListeners();
  }

  borrarTodos() async{
    await DBProvider.db.deleteAllScans();
    this.scans = [];
    notifyListeners();
  }

  borrarScansPorId (int id) async {
    await DBProvider.db.deleteScan(id);
    cargarScansPorTipo(tipoSeleccionado);
  }
}