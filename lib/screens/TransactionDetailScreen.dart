import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import 'package:warungpakwardi/constant/color.dart';
import 'package:warungpakwardi/helper/toIDR.dart';
import 'package:warungpakwardi/widgets/ButtonCustom.dart';

import '../blocs/transaction_detail/bloc/transaction_detail_bloc.dart';
import '../helper/formatDate.dart';

class TransactionDetailScreen extends StatelessWidget {
  const TransactionDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ScreenshotController screenshotController = ScreenshotController();
    final isDark = AppColors.isDark(context);

    Future<void> captureAndShare() async {
      final image = await screenshotController.capture();
      if (image != null) {
        final directory = await getTemporaryDirectory();
        final imagePath = await File('${directory.path}/receipt.png').create();
        await imagePath.writeAsBytes(image);

        await Share.shareXFiles([
          XFile(imagePath.path),
        ], subject: 'Struk Transaksi dari Warung Digital');
      }
    }

    return Scaffold(
      backgroundColor: isDark ? kBlackColor : kLightGreyColor,
      appBar: AppBar(
        title: Text(
          "Detail Transaksi",
          style: AppTypography.subHeader(
            context,
          ).copyWith(color: isDark ? kWhiteColor : kBlackColor),
        ),
        backgroundColor: isDark ? kBlackColor : kLightGreyColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: isDark ? kWhiteColor : kBlackColor),
      ),
      body: BlocBuilder<TransactionDetailBloc, TransactionDetailState>(
        builder: (context, state) {
          if (state is TransactionDetailLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TransactionDetailErrorState) {
            return Center(
              child: Text(
                "Gagal mengambil data transaksi",
                style: AppTypography.body(context),
              ),
            );
          }

          if (state is TransactionDetailLoadedState) {
            final detail = state.transactionDetail;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  Screenshot(
                    controller: screenshotController,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: isDark ? kBlack2Color : kWhiteColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: AppColors.softShadow(context),
                      ),
                      child: Column(
                        children: [
                          _buildReceiptHeader(context, detail.transactionId),
                          const SizedBox(height: 10),
                          Text(
                            formatDate(detail.transactionDate),
                            style: AppTypography.caption(context),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: _DashedDivider(),
                          ),
                          _buildItemList(context, detail.items),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: _DashedDivider(),
                          ),
                          _buildTotalSection(context, detail),
                          const SizedBox(height: 40),
                          _buildFooter(context),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ButtonCustom(
                    name: 'Bagikan Struk',
                    gradient: const [kBluePrimary, Color(0xFF1E40AF)],
                    onClick: captureAndShare,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildReceiptHeader(BuildContext context, String id) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: kGreenColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle_rounded,
            color: kGreenColor,
            size: 40,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Pembayaran Berhasil",
          style: AppTypography.title(context).copyWith(color: kGreenColor),
        ),
        const SizedBox(height: 8),
        Text(
          "ID Transaksi #$id",
          style: AppTypography.caption(
            context,
          ).copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildItemList(BuildContext context, List detailItems) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.shopping_cart_outlined,
              size: 16,
              color: kBluePrimary,
            ),
            const SizedBox(width: 8),
            Text(
              "Rincian Belanja",
              style: AppTypography.title(
                context,
              ).copyWith(color: kBluePrimary, fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...detailItems.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: AppTypography.body(
                          context,
                        ).copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "${item.quantity}x @ ${toIDR(item.unitPrice)}",
                        style: AppTypography.caption(context),
                      ),
                    ],
                  ),
                ),
                Text(
                  toIDR(item.totalPrice),
                  style: AppTypography.body(
                    context,
                  ).copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildTotalSection(BuildContext context, dynamic detail) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Subtotal", style: AppTypography.body(context)),
            Text(toIDR(detail.subtotal), style: AppTypography.body(context)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Total Pembayaran",
              style: AppTypography.title(context).copyWith(fontSize: 18),
            ),
            Text(
              toIDR(detail.total),
              style: AppTypography.header(
                context,
              ).copyWith(fontSize: 20, color: kBluePrimary),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        Text(
          "Warung Digital",
          style: AppTypography.title(context).copyWith(fontSize: 14),
        ),
        const SizedBox(height: 4),
        Text(
          "Terima kasih telah berbelanja!\nSimpan struk ini sebagai bukti pembayaran.",
          textAlign: TextAlign.center,
          style: AppTypography.caption(context),
        ),
      ],
    );
  }
}

class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        30,
        (index) => Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            height: 1,
            color: AppColors.isDark(context) ? Colors.white10 : Colors.black12,
          ),
        ),
      ),
    );
  }
}
