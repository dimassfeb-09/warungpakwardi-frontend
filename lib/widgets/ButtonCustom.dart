import 'package:flutter/material.dart';
import 'package:warungpakwardi/constant/color.dart';

class ButtonCustom extends StatelessWidget {
  final String name;
  final VoidCallback? onClick;
  final double? width;
  final double? height;
  final BoxDecoration? decoration;
  final bool disabled;
  final Color? color;
  final Color? colorLabel;
  final TextStyle? styleLabel;
  final List<Color>? gradient;
  final bool useShadow;

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
    this.gradient,
    this.useShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: width ?? MediaQuery.of(context).size.width,
      height: height ?? 56,
      decoration: decoration ??
          BoxDecoration(
            color: disabled ? kGreyColor : (gradient == null ? color : null),
            gradient: disabled
                ? null
                : (gradient != null
                    ? LinearGradient(
                        colors: gradient!,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null),
            borderRadius: BorderRadius.circular(kButtonRadius),
            boxShadow:
                (!disabled && useShadow) ? AppColors.softShadow(context) : null,
          ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: disabled ? null : onClick,
          borderRadius: BorderRadius.circular(kButtonRadius),
          child: Center(
            child: Text(
              name,
              style: styleLabel ??
                  AppTypography.title(context).copyWith(
                    color: disabled ? kGreyDarkColor : colorLabel,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
