import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:warungpakwardi/blocs/auth/bloc/auth_bloc.dart';
import 'package:warungpakwardi/constant/color.dart';
import 'package:warungpakwardi/helper/generatePdfReceipt.dart';
import 'package:warungpakwardi/helper/toIDR.dart';
import 'package:warungpakwardi/models/User.dart';
import 'package:warungpakwardi/screens/ReceiptGeneratorPage.dart';
import 'package:warungpakwardi/widgets/ButtonCustom.dart';

import '../blocs/transaction_detail/bloc/transaction_detail_bloc.dart';
import '../helper/formatDate.dart';

class TransactionDetailScreen extends StatelessWidget {
  const TransactionDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ScreenshotController _screenshotController = ScreenshotController();

    Future<void> _captureAndShare() async {
      final image = await _screenshotController.capture();
      if (image != null) {
        final directory = await getTemporaryDirectory();
        final imagePath = await File('${directory.path}/receipt.png').create();
        await imagePath.writeAsBytes(image);

        await Share.shareXFiles([
          XFile(imagePath.path),
        ], text: 'Struk Transaksi dari Warung Pak Wardi');
      }
    }

    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        title: const Text(
          "Detail Transaksi",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(preferredSize: Size(1, 1), child: Divider()),
        backgroundColor: kWhiteColor,
        centerTitle: true,
      ),
      body: BlocBuilder<TransactionDetailBloc, TransactionDetailState>(
        builder: (context, state) {
          if (state is TransactionDetailLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TransactionDetailErrorState) {
            return const Center(child: Text("Gagal ambil data transaksi"));
          }

          if (state is TransactionDetailLoadedState) {
            final detail = state.transactionDetail;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Screenshot(
                    controller: _screenshotController,
                    child: Container(
                      color: kWhiteColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              String name = '';
                              if (state is UserAuthenticated) {
                                name = state.user.name;
                              }
                              return Center(
                                child: Text(
                                  "Struk $name",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 5,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("ID Transaksi #${detail.transactionId}"),
                                Text(formatDate(detail.transactionDate)),
                              ],
                            ),
                          ),
                          const Divider(),

                          // Judul daftar produk
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 5,
                            ),
                            child: Text(
                              "Daftar Produk",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          // List item transaksi
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: detail.items.length,
                            separatorBuilder:
                                (context, index) => const Divider(),
                            itemBuilder: (context, index) {
                              final item = detail.items[index];
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 5,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "${item.quantity}x @ ${toIDR(item.unitPrice)}",
                                        ),
                                      ],
                                    ),
                                    Text(toIDR(item.totalPrice)),
                                  ],
                                ),
                              );
                            },
                          ),

                          const Divider(),

                          // Subtotal dan Total
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 5,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Subtotal",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      toIDR(detail.subtotal),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 5,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      toIDR(detail.total),
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: kBluePrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 30),

                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              if (state is UserAuthenticated) {
                                final user = state.user;

                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 30,
                                    ),
                                    child: Text(
                                      "Terima kasih telah berbelanja di ${user.name}, "
                                      "apabila ada kendala dapat menghubungi ke email ${user.email}",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                );
                              }

                              return const SizedBox();
                            },
                          ),
                          SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ButtonCustom(
                      name: 'Bagikan Struk',
                      onClick: _captureAndShare,
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink(); // Fallback kosong
        },
      ),
    );
  }
}
