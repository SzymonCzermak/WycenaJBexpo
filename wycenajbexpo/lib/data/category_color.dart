import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';

final Map<String, Color> categoryColors = {
  'Ściany': Colors.orange,
  'Podłoga': Colors.brown,
  'Podwieszenie': Colors.indigo,
  'Meble': Colors.green,
  'Grafiki': Colors.blueGrey,
};

final Map<String, PdfColor> categoryPdfColors = {
  'Ściany': PdfColors.orange,
  'Podłoga': PdfColors.brown,
  'Podwieszenie': PdfColors.indigo,
  'Meble': PdfColors.green,
  'Grafiki': PdfColors.blueGrey,
};
