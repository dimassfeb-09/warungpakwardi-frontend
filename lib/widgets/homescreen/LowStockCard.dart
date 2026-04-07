import 'package:flutter/material.dart';
import '../../constant/color.dart';

class LowStockCard extends StatelessWidget {
  final String name;
  final num stock;
  final VoidCallback? onTap;

  const LowStockCard({
    super.key,
    required this.name,
    required this.stock,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = AppColors.isDark(context);
    final Color warningColor = stock <= 3 ? kRedColor : kAccentLowStock;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1c1c1e) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppColors.softShadow(context),
          border: Border(
            left: BorderSide(
              color: warningColor,
              width: 5,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface(context),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        size: 14,
                        color: warningColor.withOpacity(0.8),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        stock <= 3 ? "Kritis - Segera restok" : "Stok menipis",
                        style: TextStyle(
                          fontSize: 12,
                          color: warningColor.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: warningColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "$stock tersisa",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: warningColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
