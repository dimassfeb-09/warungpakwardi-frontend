import 'package:flutter/material.dart';
import 'package:warungpakwardi/constant/color.dart';
import 'package:warungpakwardi/models/Product.dart';
import 'package:warungpakwardi/helper/toIDR.dart';

class CardProduct extends StatelessWidget {
  final Product product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CardProduct({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = AppColors.isDark(context);

    // Dynamic color for stock status
    Color stockColor = kAccentRevenue; // Safe - Green
    String stockStatus = "Stok Aman";
    if (product.stock <= 3) {
      stockColor = kRedColor; // Critical - Red
      stockStatus = "Stok Kritis";
    } else if (product.stock <= 10) {
      stockColor = kAccentLowStock; // Warning - Amber
      stockStatus = "Stok Menipis";
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.softShadow(context),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Left: Product Icon Placeholder
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    stockColor.withOpacity(0.2),
                    stockColor.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.inventory_2_rounded,
                color: stockColor,
                size: 32,
              ),
            ),
            const SizedBox(width: 14),

            // Center: Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface(context),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    toIDR(product.price.toInt()),
                    style: const TextStyle(
                      color: kBluePrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "per ${product.unit}",
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.subtleText(context),
                    ),
                  ),
                ],
              ),
            ),

            // Right: Actions & Stock Status
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Stock Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: stockColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "${product.stock} ${product.unit}",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: stockColor,
                    ),
                  ),
                ),

                // Compact Action Buttons
                Row(
                  children: [
                    IconButton(
                      onPressed: onEdit,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(
                        Icons.edit_note_rounded,
                        color: kBluePrimary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      onPressed: onDelete,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: kRedColor,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
