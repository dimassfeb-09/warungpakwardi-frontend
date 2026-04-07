import 'package:flutter/material.dart';
import 'package:warungpakwardi/constant/color.dart';
import 'package:warungpakwardi/widgets/homescreen/QuickMenuCard.dart';

class QuickMenu extends StatelessWidget {
  const QuickMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Menu Cepat",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface(context),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: QuickMenuCard(
                  iconPath: "assets/product.svg",
                  name: "Produk",
                  accentColor: kAccentProduct,
                  onClick:
                      () =>
                          Navigator.pushNamed(context, '/product-list-screen'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: QuickMenuCard(
                  iconPath: "assets/receipt.svg",
                  name: "Transaksi",
                  accentColor: kAccentTrx,
                  onClick:
                      () => Navigator.pushNamed(
                        context,
                        '/transaction-add-screen',
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: QuickMenuCard(
                  iconPath: "assets/graph.svg",
                  name: "Laporan",
                  accentColor: kAccentRevenue,
                  onClick: () => Navigator.pushNamed(context, '/report-screen'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: QuickMenuCard(
                  iconData: Icons.settings_rounded,
                  name: "Pengaturan",
                  accentColor: kAccentSettings,
                  onClick:
                      () => Navigator.pushNamed(context, '/settings-screen'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
