import 'package:flutter/material.dart';
import '../constant/color.dart';

class TextButtonCustom extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onClick;

  const TextButtonCustom({
    this.color = kBluePrimary,
    super.key,
    required this.text,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w500, // Opsional: Memberikan ketebalan teks
        ),
      ),
    );
  }
}
