import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../constant/color.dart';

class QuickMenuCard extends StatelessWidget {
  final Function()? onClick;
  final String? iconPath;
  final IconData? iconData;
  final String name;
  final Color accentColor;

  const QuickMenuCard({
    super.key,
    this.iconPath,
    this.iconData,
    required this.name,
    this.onClick,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = AppColors.isDark(context);

    return InkWell(
      onTap: onClick,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        decoration: BoxDecoration(
          color: accentColor.withOpacity(isDark ? 0.12 : 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: accentColor.withOpacity(isDark ? 0.2 : 0.1),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: iconPath != null
                  ? SvgPicture.asset(
                      iconPath!,
                      height: 28,
                      color: accentColor,
                    )
                  : Icon(
                      iconData,
                      size: 28,
                      color: accentColor,
                    ),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
