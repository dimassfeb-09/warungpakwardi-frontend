import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warungpakwardi/blocs/theme/bloc/theme_bloc.dart';
import 'package:warungpakwardi/blocs/theme/bloc/theme_event.dart';
import 'package:warungpakwardi/blocs/theme/bloc/theme_state.dart';
import 'package:warungpakwardi/constant/color.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return Scaffold(
      backgroundColor: isDark ? kBlackColor : kWhiteColor,
      appBar: AppBar(
        title: Text(
          "Pengaturan",
          style: AppTypography.subHeader(context).copyWith(
            color: isDark ? kWhiteColor : kBlackColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: isDark ? kBlackColor : kWhiteColor,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? kWhiteColor : kBlackColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Tampilan",
              style: AppTypography.title(context).copyWith(
                color: kBluePrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: isDark ? kBlack2Color : kWhiteColor,
                borderRadius: BorderRadius.circular(kCardRadius),
                boxShadow: AppColors.softShadow(context),
              ),
              child: BlocBuilder<ThemeBloc, ThemeState>(
                builder: (context, state) {
                  final isDarkMode = state.themeMode == ThemeMode.dark;

                  return SwitchListTile(
                    title: Text(
                      "Mode Gelap",
                      style: AppTypography.body(context).copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      "Ubah tampilan aplikasi menjadi gelap",
                      style: AppTypography.caption(context),
                    ),
                    secondary: Icon(
                      isDarkMode ? Icons.dark_mode : Icons.light_mode,
                      color: kBluePrimary,
                    ),
                    value: isDarkMode,
                    activeColor: kBluePrimary,
                    onChanged: (value) {
                      context.read<ThemeBloc>().add(ToggleTheme(value));
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                "Versi 1.0.0",
                style: AppTypography.caption(context).copyWith(
                  color: kGreyDarkColor.withOpacity(0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
