import 'package:flutter/material.dart';
import 'package:warungpakwardi/constant/color.dart';

class EmptyProduct extends StatelessWidget {
  final String message;

  const EmptyProduct({
    super.key,
    this.message = "Belum ada produk terdaftar.",
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: kBluePrimary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: kBluePrimary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Produk Kosong",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface(context),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.subtleText(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
