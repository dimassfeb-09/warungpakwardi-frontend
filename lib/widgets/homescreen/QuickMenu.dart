import 'package:flutter/material.dart';
import 'package:warungpakwardi/widgets/homescreen/QuickMenuCard.dart';

class QuickMenu extends StatelessWidget {
  const QuickMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 14,
        children: [
          Text(
            "Menu Cepat",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Column(
            spacing: 14,
            children: [
              QuickMenuCard(
                iconPath: "assets/product.svg",
                name: "Produk",
                onClick:
                    () => Navigator.pushNamed(context, '/product-list-screen'),
              ),
              QuickMenuCard(
                iconPath: "assets/receipt.svg",
                name: "Transaksi",
                onClick:
                    () =>
                        Navigator.pushNamed(context, '/transaction-add-screen'),
              ),
              QuickMenuCard(
                iconPath: "assets/graph.svg",
                name: "Laporan",
                onClick: () => Navigator.pushNamed(context, '/report-screen'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
