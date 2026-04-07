import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/TransactionReport.dart';

class ExcelHelper {
  static Future<String?> exportTransactionReport(
    TransactionReport report, {
    String? customPath,
  }) async {
    final excel = Excel.createExcel();

    // 1. Sheet Ringkasan
    final Sheet sheetSummary = excel['Ringkasan'];
    excel.delete('Sheet1'); // Remove default sheet

    // Header Title
    sheetSummary.appendRow([TextCellValue('Laporan Keuangan Warung Digital')]);
    sheetSummary.appendRow([
      TextCellValue('Dicetak pada:'),
      TextCellValue(DateTime.now().toString()),
    ]);
    sheetSummary.appendRow([TextCellValue('')]);

    // Summary Headers
    sheetSummary.appendRow([TextCellValue('METRIK UTAMA')]);
    sheetSummary.appendRow([
      TextCellValue('Pendapatan (Omzet)'),
      TextCellValue('Keuntungan (Laba)'),
      TextCellValue('Jumlah Transaksi'),
      TextCellValue('Produk Terjual'),
    ]);

    // Summary Data
    sheetSummary.appendRow([
      IntCellValue(report.totalRevenue),
      IntCellValue(report.totalProfit),
      IntCellValue(report.transactionCount),
      IntCellValue(report.itemsSoldTotal),
    ]);

    // 2. Sheet Detail Produk
    final Sheet sheetDetail = excel['Rincian Produk'];

    // Headers for Detail
    sheetDetail.appendRow([TextCellValue('RINCIAN PENJUALAN PER PRODUK')]);
    sheetDetail.appendRow([TextCellValue('')]);
    sheetDetail.appendRow([
      TextCellValue('ID Produk'),
      TextCellValue('Nama Produk'),
      TextCellValue('Jumlah Terjual'),
      TextCellValue('Omzet'),
      TextCellValue('Profit'),
    ]);

    // Data for Detail
    for (var p in report.totalSoldProduct) {
      sheetDetail.appendRow([
        TextCellValue(p.productId),
        TextCellValue(p.name),
        IntCellValue(p.quantity),
        IntCellValue(p.totalRevenue),
        IntCellValue(p.totalProfit),
      ]);
    }

    // Save File
    final directory =
        customPath != null
            ? Directory(customPath)
            : await getApplicationDocumentsDirectory();
    final fileName =
        'Laporan_Keuangan_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    final filePath = join(directory.path, fileName);

    final fileBytes = excel.save();
    if (fileBytes != null) {
      final file =
          File(filePath)
            ..createSync(recursive: true)
            ..writeAsBytesSync(fileBytes);
      return file.path;
    }
    return null;
  }
}
