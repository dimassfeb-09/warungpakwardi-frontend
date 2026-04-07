import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:warungpakwardi/constant/color.dart';
import 'package:warungpakwardi/helper/toIDR.dart';

import '../blocs/report/bloc/report_bloc.dart';
import '../models/TransactionReport.dart';
import '../widgets/SnacbarCustom.dart';
import '../helper/excel_helper.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return Scaffold(
      backgroundColor: isDark ? kBlackColor : kLightGreyColor,
      appBar: AppBar(
        title: Text(
          "Laporan Statistik",
          style: AppTypography.subHeader(
            context,
          ).copyWith(color: isDark ? kWhiteColor : kBlackColor),
        ),
        centerTitle: true,
        backgroundColor: isDark ? kBlackColor : kLightGreyColor,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? kWhiteColor : kBlackColor),
        actions: [
          BlocBuilder<ReportBloc, ReportState>(
            builder: (context, state) {
              return IconButton(
                onPressed:
                    () => _exportToExcel(
                      context,
                      state is FetchReportTransactionLoaded
                          ? state.transactionReport
                          : null,
                    ),
                icon: const Icon(Icons.file_download_outlined),
                tooltip: 'Export Excel',
              );
            },
          ),
          IconButton(
            onPressed: () => _showDatePicker(context),
            icon: const Icon(Icons.date_range_rounded),
            tooltip: 'Filter Tanggal',
          ),
        ],
      ),
      body: BlocBuilder<ReportBloc, ReportState>(
        builder: (context, state) {
          if (state is FetchReportTransactionLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FetchReportTransactionLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateHeader(context, state.startDate, state.endDate),
                  const SizedBox(height: 24),
                  _buildStatCards(context, state.transactionReport),
                  const SizedBox(height: 32),
                  _buildChartsAndTables(context, state.transactionReport),
                  const SizedBox(height: 40),
                ],
              ),
            );
          }

          if (state is FetchReportTransactionError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }

  void _showDatePicker(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: kBluePrimary,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      context.read<ReportBloc>().add(
        FetchReportTransactionRange(
          startDate: picked.start,
          endDate: picked.end,
        ),
      );
    }
  }

  void _exportToExcel(BuildContext context, TransactionReport? report) async {
    if (report == null) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Menyiapkan file Excel...')));

    try {
      // Use external storage (Downloads-like folder) instead of directory picker
      final directory = await getExternalStorageDirectory();
      final selectedDirectory = directory?.path;

      if (selectedDirectory == null) {
        SnackbarCustom.show(
          context,
          message: 'Tidak dapat mengakses penyimpanan',
          status: SnackbarStatusType.error,
          type: SnackbarType.normal,
        );
        return;
      }

      final path = await ExcelHelper.exportTransactionReport(
        report,
        customPath: selectedDirectory,
      );

      if (path != null) {
        SnackbarCustom.show(
          context,
          message: 'Laporan berhasil diekspor ke: $path',
          status: SnackbarStatusType.success,
          type: SnackbarType.normal,
        );
      }
    } catch (e) {
      SnackbarCustom.show(
        context,
        message: 'Gagal mengekspor: $e',
        status: SnackbarStatusType.error,
        type: SnackbarType.normal,
      );
    }
  }

  Widget _buildDateHeader(BuildContext context, DateTime start, DateTime end) {
    final rangeStr =
        "${DateFormat('d MMM yyyy').format(start)} - ${DateFormat('d MMM yyyy').format(end)}";
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: kBluePrimary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.history_rounded, size: 16, color: kBluePrimary),
          const SizedBox(width: 8),
          Text(
            rangeStr,
            style: AppTypography.caption(
              context,
            ).copyWith(color: kBluePrimary, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCards(BuildContext context, TransactionReport report) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: isWide ? 4 : 1,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: isWide ? 2.5 : 4,
          children: [
            _buildStatCard(
              context,
              "Pendapatan (Omzet)",
              toIDR(report.totalRevenue),
              Icons.account_balance_wallet_rounded,
              kBluePrimary,
            ),
            _buildStatCard(
              context,
              "Keuntungan (Laba)",
              toIDR(report.totalProfit),
              Icons.trending_up_rounded,
              const Color(0xFF8B5CF6),
            ),
            _buildStatCard(
              context,
              "Transaksi",
              "${report.transactionCount}",
              Icons.receipt_long_rounded,
              const Color(0xFF10B981),
            ),
            _buildStatCard(
              context,
              "Terjual",
              "${report.itemsSoldTotal}",
              Icons.inventory_2_rounded,
              const Color(0xFFF59E0B),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    final isDark = AppColors.isDark(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? kBlack2Color : kWhiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.softShadow(context),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: AppTypography.caption(context)),
                Text(
                  value,
                  style: AppTypography.subHeader(
                    context,
                  ).copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartsAndTables(BuildContext context, TransactionReport report) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 800;
        return Column(
          children: [
            if (isWide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: _buildRevenueChart(context, report)),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 1,
                    child: _buildTopSellingChart(context, report),
                  ),
                ],
              )
            else ...[
              _buildRevenueChart(context, report),
              const SizedBox(height: 24),
              _buildTopSellingChart(context, report),
            ],
            const SizedBox(height: 32),
            _buildDetailTable(context, report),
          ],
        );
      },
    );
  }

  Widget _buildRevenueChart(BuildContext context, TransactionReport report) {
    return _buildContainer(
      context,
      "Tren Pendapatan",
      SizedBox(
        height: 300,
        child: SfCartesianChart(
          margin: EdgeInsets.zero,
          plotAreaBorderWidth: 0,
          primaryXAxis: CategoryAxis(
            labelStyle: AppTypography.caption(
              context,
            ).copyWith(color: kGreyDarkColor),
            majorGridLines: const MajorGridLines(width: 0),
          ),
          primaryYAxis: NumericAxis(isVisible: false),
          tooltipBehavior: TooltipBehavior(enable: true, header: ''),
          series: <CartesianSeries>[
            AreaSeries<TransactionSummaryPerDay, String>(
              dataSource: report.transactionSummaryMonthly,
              xValueMapper: (TransactionSummaryPerDay data, _) => data.dayName,
              yValueMapper:
                  (TransactionSummaryPerDay data, _) => data.totalPerDay,
              color: kBluePrimary.withOpacity(0.3),
              borderColor: kBluePrimary,
              borderWidth: 2,
              enableTooltip: true,
              markerSettings: const MarkerSettings(
                isVisible: true,
                color: kBluePrimary,
              ),
              gradient: LinearGradient(
                colors: [
                  kBluePrimary.withOpacity(0.5),
                  kBluePrimary.withOpacity(0.01),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSellingChart(BuildContext context, TransactionReport report) {
    return _buildContainer(
      context,
      "Top 5 Produk (Unit)",
      SizedBox(
        height: 300,
        child: SfCartesianChart(
          margin: EdgeInsets.zero,
          plotAreaBorderWidth: 0,
          primaryXAxis: CategoryAxis(
            labelStyle: AppTypography.caption(context).copyWith(fontSize: 10),
            majorGridLines: const MajorGridLines(width: 0),
          ),
          primaryYAxis: NumericAxis(isVisible: false),
          tooltipBehavior: TooltipBehavior(enable: true, header: ''),
          series: <CartesianSeries>[
            ColumnSeries<TopSellingProduct, String>(
              dataSource: report.productTopSelling,
              xValueMapper: (TopSellingProduct data, _) => data.name,
              yValueMapper: (TopSellingProduct data, _) => data.totalSold,
              color: kBluePrimary,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(6),
              ),
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                textStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailTable(BuildContext context, TransactionReport report) {
    return _buildContainer(
      context,
      "Rincian Penjualan Produk",
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowHeight: 48,
          dataRowMinHeight: 48,
          dataRowMaxHeight: 56,
          horizontalMargin: 0,
          columnSpacing: 40,
          columns: [
            DataColumn(label: Text("Produk", style: _columnStyle(context))),
            DataColumn(
              label: Text("Terjual", style: _columnStyle(context)),
              numeric: true,
            ),
            DataColumn(
              label: Text("Omzet", style: _columnStyle(context)),
              numeric: true,
            ),
            DataColumn(
              label: Text("Profit", style: _columnStyle(context)),
              numeric: true,
            ),
          ],
          rows:
              report.totalSoldProduct.map((p) {
                return DataRow(
                  cells: [
                    DataCell(
                      Text(
                        p.name,
                        style: AppTypography.body(
                          context,
                        ).copyWith(fontWeight: FontWeight.w500),
                      ),
                    ),
                    DataCell(
                      Text("${p.quantity}", style: AppTypography.body(context)),
                    ),
                    DataCell(
                      Text(
                        toIDR(p.totalRevenue),
                        style: AppTypography.body(context).copyWith(
                          color: kBluePrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        toIDR(p.totalProfit),
                        style: AppTypography.body(context).copyWith(
                          color: const Color(0xFF8B5CF6),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
        ),
      ),
    );
  }

  TextStyle _columnStyle(BuildContext context) => AppTypography.caption(
    context,
  ).copyWith(fontWeight: FontWeight.bold, color: kGreyDarkColor);

  Widget _buildContainer(BuildContext context, String title, Widget child) {
    final isDark = AppColors.isDark(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? kBlack2Color : kWhiteColor,
        borderRadius: BorderRadius.circular(kCardRadius),
        boxShadow: AppColors.softShadow(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.subHeader(
              context,
            ).copyWith(fontWeight: FontWeight.bold),
          ),
          const Divider(height: 32),
          child,
        ],
      ),
    );
  }
}
