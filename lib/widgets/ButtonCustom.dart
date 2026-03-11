import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:warungpakwardi/constant/color.dart';

class ButtonCustom extends StatelessWidget {
  final String name;

  final VoidCallback? onClick;
  final double? width;
  final double? height;
  final BoxDecoration? decoration;

  final bool? disabled;

  final Color? color;
  final Color? colorLabel;
  final TextStyle? styleLabel;

  const ButtonCustom({
    super.key,
    required this.name,
    required this.onClick,
    this.color = kBluePrimary,
    this.colorLabel = Colors.white,
    this.disabled = false,
    this.width,
    this.height,
    this.decoration,
    this.styleLabel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled == true ? null : onClick,
      child: Container(
        width: width ?? MediaQuery.of(context).size.width,
        height: height ?? 56,
        alignment: Alignment.center,
        decoration:
            decoration ??
            BoxDecoration(
              color: disabled == true ? kGreyColor : color,
              borderRadius: BorderRadius.circular(12),
            ),
        child: Text(
          name,
          style:
              styleLabel ??
              GoogleFonts.poppins(
                fontSize: 16,
                color: disabled == true ? kGreyDarkColor : colorLabel,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}
