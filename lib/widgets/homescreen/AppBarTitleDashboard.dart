import 'package:flutter/material.dart';
import 'package:warungpakwardi/constant/color.dart';

class AppBarTitleDashboard extends StatelessWidget {
  const AppBarTitleDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      children: [
        SizedBox(height: 30),
        Text(
          "Dashboard",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          "Warung Pak Wardi",
          style: TextStyle(
            fontSize: 18,
            color: kGreyDarkColor.withAlpha(99),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
