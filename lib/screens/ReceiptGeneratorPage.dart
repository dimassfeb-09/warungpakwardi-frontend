import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:warungpakwardi/models/TransactionDetail.dart';

class ReceiptGeneratorWidget extends StatefulWidget {
  final TransactionDetail transaction;

  const ReceiptGeneratorWidget({super.key, required this.transaction});

  @override
  State<ReceiptGeneratorWidget> createState() => _ReceiptGeneratorWidgetState();
}

class _ReceiptGeneratorWidgetState extends State<ReceiptGeneratorWidget> {
  final ScreenshotController _screenshotController = ScreenshotController();

  Future<void> _captureAndShare() async {
    final image = await _screenshotController.capture();
    if (image != null) {
      final directory = await getTemporaryDirectory();
      final imagePath = await File('${directory.path}/receipt.png').create();
      await imagePath.writeAsBytes(image);

      await Share.shareXFiles([
        XFile(imagePath.path),
      ], subject: 'Struk Transaksi dari Warung Pak Wardi');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Screenshot(
          controller: _screenshotController,
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Struk Pembelian",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10),
                Text("No Transaksi: ${widget.transaction.transactionId}"),
                Text("Tanggal: ${widget.transaction.transactionDate}"),
                Divider(),
                Text(
                  "Detail Barang:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ...widget.transaction.items.map(
                  (item) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Qty: ${item.quantity} x ${item.unitPrice}"),
                          Text("Rp ${item.totalPrice}"),
                        ],
                      ),
                      SizedBox(height: 4),
                    ],
                  ),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Subtotal"),
                    Text("Rp ${widget.transaction.subtotal}"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Rp ${widget.transaction.total}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Center(child: Text("Terima Kasih!")),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: _captureAndShare,
          child: Text("Bagikan Struk"),
        ),
      ],
    );
  }
}
