import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warungpakwardi/constant/color.dart'; // import AppColors
import 'package:warungpakwardi/widgets/homescreen/LowStockCard.dart';

import '../../blocs/home/bloc/home_bloc.dart';
import '../../models/Product.dart';

class LowStock extends StatelessWidget {
  const LowStock({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        List<Product> products = [];

        if (state is FetchDashboardLoadingState) {
          return const SizedBox.shrink(); // Hide while loading, Hero handles shimmer
        }

        if (products.isEmpty && state is FetchDashboardLoadedState) {
          return const SizedBox.shrink(); // Hide if no low stock items
        }

        return Container(
          margin: const EdgeInsets.only(top: 24),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text(
                    "Peringatan Stok",
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface(context),
                      letterSpacing: 0.5,
                    ),
                  ),
                  if (products.length > 3)
                  Text(
                    "Semua (${products.length})",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: kAccentLowStock,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ListView.separated(
                itemCount: products.length > 5 ? 5 : products.length, // limit to 5 on home
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return LowStockCard(
                    name: product.name,
                    stock: product.stock,
                    onTap: () async {
                      await Navigator.pushNamed(
                        context,
                        '/product-edit-screen',
                        arguments: product,
                      );
                      // Auto-refresh via routeObserver in HomeScreen handles the BLoC trigger
                    },
                  );
                },
                separatorBuilder:
                    (BuildContext context, int index) => const SizedBox(height: 14),
              ),
            ],
          ),
        );
      },
    );
  }
}
