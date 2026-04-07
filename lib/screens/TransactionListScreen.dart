import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warungpakwardi/blocs/transaction/bloc/transaction_bloc.dart';
import 'package:warungpakwardi/constant/color.dart';
import 'package:warungpakwardi/helper/toIDR.dart';
import 'package:warungpakwardi/models/Dashboard.dart';

import '../blocs/home/bloc/home_bloc.dart';
import '../helper/groupTransactionHistory.dart';
import '../widgets/SnacbarCustom.dart';

class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({super.key});

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  DateTime? startDate;
  DateTime? endDate;

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
      initialDateRange:
          startDate != null && endDate != null
              ? DateTimeRange(start: startDate!, end: endDate!)
              : null,
      builder: (context, child) {
        return Theme(
          data:
              AppColors.isDark(context)
                  ? ThemeData.dark().copyWith(
                    colorScheme: const ColorScheme.dark(
                      primary: kBluePrimary,
                      onPrimary: Colors.white,
                      surface: kBlack2Color,
                      onSurface: Colors.white,
                    ),
                  )
                  : ThemeData.light().copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: kBluePrimary,
                      onPrimary: Colors.white,
                      surface: Colors.white,
                      onSurface: Colors.black,
                    ),
                  ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });
      context.read<TransactionBloc>().add(
        FetchTransactionByDateEvent(
          start: picked.start,
          end: picked.end.add(const Duration(days: 1)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return Scaffold(
      backgroundColor: isDark ? kBlackColor : kWhiteColor,
      appBar: AppBar(
        title: Text(
          "Riwayat Transaksi",
          style: AppTypography.subHeader(
            context,
          ).copyWith(color: isDark ? kWhiteColor : kBlackColor),
        ),
        backgroundColor: isDark ? kBlackColor : kWhiteColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: isDark ? kWhiteColor : kBlackColor),
        actions: [
          IconButton(
            onPressed: () => _selectDateRange(context),
            icon: Icon(
              Icons.calendar_month_outlined,
              color:
                  startDate != null
                      ? kBluePrimary
                      : (isDark ? kWhiteColor : kBlackColor),
            ),
          ),
          if (startDate != null)
            IconButton(
              onPressed: () {
                setState(() {
                  startDate = null;
                  endDate = null;
                });
                context.read<TransactionBloc>().add(FetchTransactionEvent());
              },
              icon: const Icon(Icons.refresh, color: kRedColor),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSummaryCard(context),
            BlocBuilder<TransactionBloc, TransactionState>(
              builder: (context, state) {
                if (state is FetchTransactionLoadingState) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (state is FetchTransactionErrorState) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Center(
                      child: Text(
                        'Gagal memuat data transaksi.',
                        style: AppTypography.body(context),
                      ),
                    ),
                  );
                }

                if (state is FetchTransactionLoadedState) {
                  final transactions = state.transactions;

                  if (transactions.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Column(
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 64,
                            color: kGreyDarkColor.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Belum ada transaksi.',
                            style: AppTypography.body(
                              context,
                            ).copyWith(color: kGreyDarkColor),
                          ),
                        ],
                      ),
                    );
                  }

                  final groupedTransactions = groupTransactionsByDate(
                    transactions,
                  );

                  return ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: groupedTransactions.length,
                    itemBuilder: (context, index) {
                      final groupKey = groupedTransactions.keys.elementAt(
                        index,
                      );
                      final groupList = groupedTransactions[groupKey]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 12),
                            child: Text(
                              groupKey.toUpperCase(),
                              style: AppTypography.caption(context).copyWith(
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.bold,
                                color: kBluePrimary,
                              ),
                            ),
                          ),
                          ...groupList
                              .map(
                                (transaction) =>
                                    _buildTransactionItem(context, transaction),
                              )
                              .toList(),
                        ],
                      );
                    },
                  );
                }
                return const SizedBox();
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
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
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [kHeaderStart, kHeaderAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(kCardRadius),
            boxShadow: AppColors.softShadow(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ringkasan Transaksi",
                style: AppTypography.title(
                  context,
                ).copyWith(color: Colors.white70),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSummaryItem(
                    context,
                    label: "Total Unit",
                    value: "${dashboard.totalTransaction}",
                    icon: Icons.confirmation_number_outlined,
                  ),
                  _buildSummaryItem(
                    context,
                    label: "Total Pendapatan",
                    value: toIDR(dashboard.revenue),
                    icon: Icons.account_balance_wallet_outlined,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryItem(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: Colors.white70),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTypography.caption(
                  context,
                ).copyWith(color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTypography.subHeader(
              context,
            ).copyWith(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(BuildContext context, dynamic transaction) {
    final isDark = AppColors.isDark(context);
    final time = TimeOfDay.fromDateTime(transaction.transactionDate);
    final timeFormatted =
        "${time.hour.toString().padLeft(2, '0')}.${time.minute.toString().padLeft(2, '0')}";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? kBlack2Color : kWhiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow:
            AppColors.softShadow(
              context,
            ).map((s) => s.copyWith(blurRadius: 5)).toList(),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap:
              () => Navigator.pushNamed(
                context,
                '/transaction-detail-screen',
                arguments: transaction.transactionId,
              ),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: kBluePrimary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.receipt_outlined,
                    color: kBluePrimary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            timeFormatted,
                            style: AppTypography.caption(context),
                          ),
                          Text(
                            "${transaction.totalItems} Items",
                            style: AppTypography.caption(
                              context,
                            ).copyWith(color: kBluePrimary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        toIDR(transaction.totalPrice),
                        style: AppTypography.title(
                          context,
                        ).copyWith(color: isDark ? kWhiteColor : kBlackColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _showDeleteConfirmation(context, transaction.transactionId),
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: kRedColor,
                    size: 20,
                  ),
                  tooltip: 'Hapus Transaksi',
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: kGreyDarkColor.withOpacity(0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String transactionId) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Transaksi?'),
          content: const Text(
            'Apakah Anda yakin ingin menghapus transaksi ini? Data yang dihapus tidak dapat dikembalikan.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                context.read<TransactionBloc>().add(
                  DeleteTransactionEvent(transactionId: transactionId),
                );
                Navigator.pop(dialogContext);
                SnackbarCustom.show(
                  context,
                  message: 'Transaksi berhasil dihapus',
                  status: SnackbarStatusType.success,
                  type: SnackbarType.normal,
                );
              },
              child: const Text(
                'Hapus',
                style: TextStyle(color: kRedColor),
              ),
            ),
          ],
        );
      },
    );
  }
}
