import 'package:flutter/material.dart';
import 'package:qrreader/models/scan_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

Future<void>launchURL(ScanModel scan, BuildContext context) async {
  final url = Uri.parse(scan.valor);

  if(scan.tipo == 'http') {
    if(!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  } else {
    Navigator.pushNamed(context, 'mapa', arguments: scan);
  }

}