import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart'; // Ganti package chart
import 'package:warungpakwardi/constant/color.dart';

import '../blocs/report/bloc/report_bloc.dart';
import '../models/TransactionReport.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        title: const Text(
          "Laporan",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<ReportBloc, ReportState>(
          builder: (context, state) {
            if (state is FetchReportTransactionLoaded) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  spacing: 30,
                  children: [
                    const SizedBox(height: 0),
                    SizedBox(
                      height: 300,
                      child: buildMonthlyLineChart(
                        state.transactionReport.transactionSummaryMonthly,
                      ),
                    ),
                    SizedBox(
                      height: 250,
                      child: buildWeeklyBarChart(
                        state.transactionReport.transactionSummaryThisWeek,
                      ),
                    ),
                    SizedBox(
                      height: 250,
                      child: buildTopSellingProductChart(
                        state.transactionReport.productTopSelling,
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget buildMonthlyLineChart(List<TransactionSummaryPerDay> data) {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      title: ChartTitle(
        text: 'Grafik Transaksi Bulanan',
        textStyle: TextStyle(fontWeight: FontWeight.bold),
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: [
        LineSeries<TransactionSummaryPerDay, String>(
          dataSource: data,
          xValueMapper: (tx, _) => tx.date,
          yValueMapper: (tx, _) => tx.totalPerDay,
          name: 'Total',
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }

  Widget buildWeeklyBarChart(List<TransactionSummaryPerDay> data) {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      title: ChartTitle(
        text: 'Grafik Transaksi Mingguan',
        textStyle: TextStyle(fontWeight: FontWeight.bold),
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: [
        ColumnSeries<TransactionSummaryPerDay, String>(
          dataSource: data,
          xValueMapper: (tx, _) => tx.date,
          yValueMapper: (tx, _) => tx.totalPerDay,
          name: 'Total',
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }

  Widget buildTopSellingProductChart(List<TopSellingProduct> data) {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      title: ChartTitle(
        text: 'Grafik Top Produk',
        textStyle: TextStyle(fontWeight: FontWeight.bold),
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: [
        ColumnSeries<TopSellingProduct, String>(
          dataSource: data,
          xValueMapper: (tx, _) => tx.name,
          yValueMapper: (tx, _) => tx.totalSold,
          name: 'Total',
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }
}
