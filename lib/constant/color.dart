import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── Primary Colors ─────────────────────────────────────
const Color kBluePrimary = Color(0xFF2563EB);
const Color kBlueLightColor = Color(0xFFF5F9FF);
const Color kGreyColor = Color(0xFFE5E5E5);
const Color kGreyDarkColor = Color.fromARGB(255, 138, 138, 138);
const Color kRedColor = Color(0xFFB91C1C);
const Color kBlackColor = Color(0xFF0c0f14);
const Color kBlack2Color = Color.fromARGB(255, 21, 26, 35);
const Color kBlackDeep = Colors.black;
const Color kRedLight = Color.fromARGB(255, 184, 84, 84);
const Color kLightGreyColor = Color(0xFFF8F8F8);
const Color kGreenColor = Color(0xFF34C759);
const Color kWhiteColor = Color(0xFFFFFFFF);
const Color kWhite2Color = Color(0xFFFBFBFB);

// ─── Global Redesign Accent Colors ──────────────────────
const Color kAccentProduct = Color(0xFF3B82F6); // Blue
const Color kAccentTrx = Color(0xFF8B5CF6); // Violet
const Color kAccentRevenue = Color(0xFF10B981); // Emerald
const Color kAccentLowStock = Color(0xFFF59E0B); // Amber
const Color kAccentSettings = Color(0xFF64748B); // Slate

// ─── Header Gradient ────────────────────────────────────
const Color kHeaderStart = Color(0xFF1E1B4B); // Deep Indigo
const Color kHeaderEnd = Color(0xFF312E81); // Navy Indigo
const Color kHeaderAccent = Color(0xFF4F46E5); // Indigo Accent

// ─── Layout & Elevation ──────────────────────────────────
const double kCardRadius = 24.0;
const double kInputRadius = 16.0;
const double kButtonRadius = 14.0;

final String? fontPoppins = GoogleFonts.poppins().fontFamily;

// ─── Theme Helper ───────────────────────────────────────
class AppColors {
  static Color surface(BuildContext context) => Theme.of(context).colorScheme.surface;
  static Color onSurface(BuildContext context) => Theme.of(context).colorScheme.onSurface;
  static Color primary(BuildContext context) => Theme.of(context).colorScheme.primary;
  static Color card(BuildContext context) => Theme.of(context).cardColor;
  
  static bool isDark(BuildContext context) => Theme.of(context).brightness == Brightness.dark;

  static Color subtleText(BuildContext context) => 
      isDark(context) ? Colors.white60 : Colors.black54;

  static List<BoxShadow> softShadow(BuildContext context) => [
        BoxShadow(
          color: isDark(context) 
              ? Colors.black.withOpacity(0.4) 
              : Colors.black.withOpacity(0.08),
          blurRadius: 20,
          spreadRadius: 2,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> deepShadow(BuildContext context) => [
        BoxShadow(
          color: isDark(context) 
              ? Colors.black.withOpacity(0.5) 
              : Colors.black.withOpacity(0.12),
          blurRadius: 30,
          spreadRadius: 4,
          offset: const Offset(0, 12),
        ),
      ];
}

// ─── Typography Utils ──────────────────────────────────
class AppTypography {
  static TextStyle header(BuildContext context) => GoogleFonts.outfit(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.onSurface(context),
      );

  static TextStyle subHeader(BuildContext context) => GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface(context),
      );

  static TextStyle title(BuildContext context) => GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface(context),
      );

  static TextStyle body(BuildContext context) => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.onSurface(context),
      );

  static TextStyle caption(BuildContext context) => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.subtleText(context),
      );
}
