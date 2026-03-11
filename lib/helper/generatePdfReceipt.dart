import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<void> generateReceiptPdf() async {
  final pdf = pw.Document();

  // Dummy data
  final data = {
    "transaction_id": "4f59ac90-c76e-41cf-8551-67c57afa81e6",
    "transaction_date": "2025-04-17T18:46:09.119894Z",
    "items": [
      {
        "name": "askjdasd 2",
        "quantity": 1,
        "unit_price": 5000,
        "total_price": 5000,
      },
    ],
    "subtotal": 5000,
    "total": 5000,
  };

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.roll80,
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Text(
                "Struk Pembelian",
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Text(
              "No Transaksi: ${data["transaction_id"]}",
              style: pw.TextStyle(fontSize: 10),
            ),
            pw.Text(
              "Tanggal     : ${data["transaction_date"]}",
              style: pw.TextStyle(fontSize: 10),
            ),
            pw.Divider(),
            pw.Text(
              "Detail Barang:",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 5),
            ...List<pw.Widget>.from(
              (data["items"] as List).map((item) {
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("${item["name"]}"),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          "Qty: ${item["quantity"]} x ${item["unit_price"]}",
                        ),
                        pw.Text("Rp ${item["total_price"]}"),
                      ],
                    ),
                    pw.SizedBox(height: 5),
                  ],
                );
              }),
            ),
            pw.Divider(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("Subtotal"),
                pw.Text("Rp ${data["subtotal"]}"),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  "Total",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  "Rp ${data["total"]}",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Center(
              child: pw.Text(
                "Terima Kasih!",
                style: pw.TextStyle(fontSize: 12),
              ),
            ),
          ],
        );
      },
    ),
  );

  // Simpan PDF ke file
  final output = await getApplicationDocumentsDirectory();
  final file = File("${output.path}/receipt.pdf");
  await file.writeAsBytes(await pdf.save());

  print("PDF disimpan di: ${file.path}");
}
