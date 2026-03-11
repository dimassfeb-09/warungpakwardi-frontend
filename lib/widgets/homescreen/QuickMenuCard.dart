import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constant/color.dart';

class QuickMenuCard extends StatelessWidget {
  const QuickMenuCard({
    super.key,
    required this.iconPath,
    required this.name,
    this.onClick,
  });

  final Function()? onClick;
  final String iconPath;
  final String name;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: kGreyDarkColor.withAlpha(90)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 10,
              children: [
                SvgPicture.asset(iconPath, height: 30),
                Text(
                  name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 14),
          ],
        ),
      ),
    );
  }
}
