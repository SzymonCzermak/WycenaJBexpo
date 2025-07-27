import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:wycenajbexpo/data/category_color.dart';
import '../models/item_model.dart';

class PdfGenerator {
  static Future<void> generateQuote(List<ItemModel> items,
      {required bool isEnglish}) async {
    final pdf = pw.Document();

    // Ładowanie fontów Roboto z assets
    final regularFont =
        pw.Font.ttf(await rootBundle.load('assets/fonts/Roboto-Regular.ttf'));
    final boldFont =
        pw.Font.ttf(await rootBundle.load('assets/fonts/Roboto-Bold.ttf'));

    final total = items.fold(0.0, (sum, item) => sum + item.total);

    final grouped = <String, List<ItemModel>>{};
    for (var item in items) {
      grouped.putIfAbsent(item.category, () => []).add(item);
    }

    pdf.addPage(
      pw.MultiPage(
        theme: pw.ThemeData.withFont(
          base: regularFont,
          bold: boldFont,
        ),
        build: (context) => [
          pw.Text(
            isEnglish ? 'Quotation' : 'Wycena',
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 16),
          for (var entry in grouped.entries) ...[
            pw.Text(
              entry.key,
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                color: categoryPdfColors[entry.key] ?? PdfColors.black,
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Table.fromTextArray(
              headers: isEnglish
                  ? ['Name', 'Qty', 'Unit', 'Price (PLN)', 'Total (PLN)']
                  : ['Nazwa', 'Ilość', 'Jedn.', 'Cena (PLN)', 'Suma (PLN)'],
              data: entry.value.map((item) {
                return [
                  isEnglish ? item.nameEn : item.name,
                  item.quantity.toString(),
                  item.unit,
                  item.priceBrutto.toStringAsFixed(2),
                  item.total.toStringAsFixed(2),
                ];
              }).toList(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              cellStyle: const pw.TextStyle(),
              border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey),
            ),
            pw.SizedBox(height: 12),
          ],
          pw.Divider(),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              isEnglish
                  ? 'Total: ${total.toStringAsFixed(2)} PLN'
                  : 'Razem: ${total.toStringAsFixed(2)} PLN',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }
}
