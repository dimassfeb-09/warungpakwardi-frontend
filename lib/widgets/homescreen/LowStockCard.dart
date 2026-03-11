import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:warungpakwardi/constant/color.dart';

class LowStockCard extends StatelessWidget {
  final String name;
  final int stock;
  final VoidCallback? onTap;

  const LowStockCard({
    super.key,
    required this.name,
    required this.stock,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: kGreyDarkColor.withAlpha(90)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Sisa stok: $stock",
                  style: TextStyle(fontSize: 12, color: kRedLight),
                ),
              ],
            ),
            SvgPicture.asset("assets/alert.svg"),
          ],
        ),
      ),
    );
  }
}
