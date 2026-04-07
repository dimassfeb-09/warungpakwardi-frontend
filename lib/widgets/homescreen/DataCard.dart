import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:warungpakwardi/constant/color.dart';
import 'package:warungpakwardi/helper/toIDR.dart';

enum TypeValue { normal, rupiah }

class DataCardModel {
  final String assetPath;
  final int value;
  final String title;
  final TypeValue type;
  final Color accentColor; // New attribute

  const DataCardModel({
    required this.value,
    required this.type,
    required this.assetPath,
    required this.title,
    this.accentColor = kBluePrimary,
  });

  DataCardModel copyWith({
    String? assetPath,
    int? value,
    String? title,
    TypeValue? type,
    Color? accentColor,
  }) {
    return DataCardModel(
      assetPath: assetPath ?? this.assetPath,
      value: value ?? this.value,
      title: title ?? this.title,
      type: type ?? this.type,
      accentColor: accentColor ?? this.accentColor,
    );
  }
}

class DataCard extends StatelessWidget {
  final DataCardModel data;

  const DataCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final bool isDark = AppColors.isDark(context);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1c1c1e) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.softShadow(context),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Accent Color Top Indicator
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 4,
                color: data.accentColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: data.accentColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SvgPicture.asset(
                      data.assetPath,
                      color: data.accentColor,
                      height: 22,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.type == TypeValue.rupiah
                            ? toIDR(data.value)
                            : "${data.value}",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface(context),
                          letterSpacing: -0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data.title,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.subtleText(context),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
