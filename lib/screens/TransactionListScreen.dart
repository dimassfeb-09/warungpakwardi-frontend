import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warungpakwardi/blocs/transaction/bloc/transaction_bloc.dart';
import 'package:warungpakwardi/constant/color.dart';
import 'package:warungpakwardi/helper/toIDR.dart';
import 'package:warungpakwardi/models/Dashboard.dart';

import '../blocs/home/bloc/home_bloc.dart';
import '../helper/groupTransactionHistory.dart';

class TransactionListScreen extends StatelessWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        title: Text("Riwayat Transaksi"),
        backgroundColor: kWhiteColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                late Dashboard dashboard = Dashboard(
                  revenue: 0,
                  totalTransaction: 0,
                  totalProduct: 0,
                );

                if (state is FetchDashboardLoadedState) {
                  dashboard = state.dashboard;
                }

                return Container(
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: kGreyDarkColor.withAlpha(90),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 5,
                    children: [
                      Text(
                        "Ringkasan Hari Ini",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Total Transaksi"),
                              Text(
                                "${dashboard.totalTransaction} Transaksi",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Total Pendapatan"),
                              Text(
                                toIDR(dashboard.revenue),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            BlocBuilder<TransactionBloc, TransactionState>(
              builder: (context, state) {
                if (state is FetchTransactionLoadingState) {
                  return Center(child: CircularProgressIndicator());
                }

                if (state is FetchTransactionErrorState) {
                  return Center(child: Text('Gagal memuat data transaksi.'));
                }

                if (state is FetchTransactionLoadedState) {
                  final transactions = state.transactions;

                  if (transactions.isEmpty) {
                    return Center(child: Text('Belum ada transaksi.'));
                  }

                  final groupedTransactions = groupTransactionsByDate(
                    transactions,
                  );

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: groupedTransactions.length,
                    itemBuilder: (context, index) {
                      final groupKey = groupedTransactions.keys.elementAt(
                        index,
                      );
                      final groupList = groupedTransactions[groupKey]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Judul tanggal
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Text(
                              groupKey,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          ...groupList.map((transaction) {
                            final time = TimeOfDay.fromDateTime(
                              transaction.transactionDate,
                            );
                            final timeFormatted =
                                "${time.hour.toString().padLeft(2, '0')}.${time.minute.toString().padLeft(2, '0')}";

                            return Column(
                              children: [
                                InkWell(
                                  onTap:
                                      () => Navigator.pushNamed(
                                        context,
                                        '/transaction-detail-screen',
                                        arguments: transaction.transactionId,
                                      ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(timeFormatted),
                                                const SizedBox(width: 5),
                                                const Text("-"),
                                                const SizedBox(width: 5),
                                                Text(
                                                  "${transaction.totalItems} item",
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(toIDR(transaction.totalPrice)),
                                          ],
                                        ),
                                        const Icon(
                                          Icons.keyboard_arrow_right_rounded,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(),
                              ],
                            );
                          }).toList(),
                        ],
                      );
                    },
                  );
                }

                // Default fallback (misal state awal)
                return SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}
