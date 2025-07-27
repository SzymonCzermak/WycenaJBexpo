import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/item_model.dart';

class PdfGenerator {
  static Future<void> generateInvoice(List<ItemModel> items) async {
    final pdf = pw.Document();

    final total = items.fold(0.0, (sum, item) => sum + item.total);

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text('Faktura / Invoice', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 16),
          pw.Table.fromTextArray(
            headers: ['Nazwa / Name', 'Ilość / Qty', 'Jedn. / Unit', 'Cena / Price (PLN)', 'Suma / Total (PLN)'],
            data: items.map((item) => [
              item.name,
              item.quantity.toString(),
              item.unit,
              item.priceBrutto.toStringAsFixed(2),
              item.total.toStringAsFixed(2),
            ]).toList(),
          ),
          pw.Divider(),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              'Razem / Total: ${total.toStringAsFixed(2)} PLN',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
          )
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }
}
