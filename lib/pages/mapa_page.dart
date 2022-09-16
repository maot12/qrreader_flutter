import 'dart:async';

import 'package:flutter/material.dart';
import '../models/scan_model.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {

  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  Completer<GoogleMapController> _controller = Completer();
  MapType mapType = MapType.normal;

    @override
    Widget build(BuildContext context) {

      final ScanModel scan = ModalRoute.of(context)?.settings.arguments as ScanModel;

      final CameraPosition puntoInicial = CameraPosition(
        target: scan.getLatLng(),
        zoom: 17,
      );

      //Marcadores
      Set<Marker> markers = new Set<Marker>();
      markers.add(Marker(
          markerId: const MarkerId('geo-location'),
          position: scan.getLatLng(),
      ));


        return Scaffold(
          appBar: AppBar(
            title: const Text('Mapa'),
            actions: [
              IconButton(
                icon: Icon(Icons.location_on),
                onPressed: () async {
                  final GoogleMapController controller = await _controller.future;
                  controller.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                            target: scan.getLatLng(),
                            zoom: 17
                        )
                      )
                  );
                },
              )
            ],
          ),
          body: GoogleMap(
            mapType:  mapType,
            markers: markers,
            initialCameraPosition: puntoInicial,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.layers_outlined),
            onPressed: () {
              if(mapType == MapType.normal) {
                mapType = MapType.hybrid;
              } else {
                mapType = MapType.normal;
              }

              setState(() {

              });
            },
          ),
        );//Center
    }
}