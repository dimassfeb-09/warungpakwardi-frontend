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

  const DataCardModel({
    required this.value,
    required this.type,
    required this.assetPath,
    required this.title,
  });

  DataCardModel copyWith({
    String? assetPath,
    int? value,
    String? title,
    TypeValue? type,
  }) {
    return DataCardModel(
      assetPath: assetPath ?? this.assetPath,
      value: value ?? this.value,
      title: title ?? this.title,
      type: type ?? this.type,
    );
  }
}

class DataCard extends StatelessWidget {
  final DataCardModel data;

  const DataCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 2, color: kGreyDarkColor.withAlpha(80)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SvgPicture.asset(data.assetPath),
          Text(
            data.type == TypeValue.rupiah ? toIDR(data.value) : "${data.value}",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(data.title),
        ],
      ),
    );
  }
}
