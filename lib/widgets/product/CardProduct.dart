import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:warungpakwardi/constant/color.dart';
import 'package:warungpakwardi/models/Product.dart';

class CardProduct extends StatelessWidget {
  final Product product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CardProduct({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 118,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 2, color: kGreyDarkColor.withAlpha(90)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            "Rp ${product.price} / ${product.unit}",
            style: TextStyle(
              color: kBluePrimary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Stok: ${product.stock} ${product.unit}"),
              Row(
                spacing: 8,
                children: [
                  GestureDetector(
                    onTap: onEdit,
                    child: Row(
                      children: [
                        Icon(Icons.edit, color: kBluePrimary),
                        Text("Ubah", style: TextStyle(color: kBluePrimary)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: onDelete,
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: kRedColor),
                        Text("Hapus", style: TextStyle(color: kRedColor)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
