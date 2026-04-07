import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

        if (state is FetchDashboardLoadedState) {
          final dashboard = state.dashboard;
          products = dashboard.productLowStock ?? [];
        }

        return Container(
          margin: const EdgeInsets.only(top: 16),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Produk Stok Menipis",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListView.separated(
                itemCount: products.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return LowStockCard(
                    name: product.name,
                    stock: product.stock,
                    onTap: () async {
                      final newUpdated = await Navigator.pushNamed(
                        context,
                        '/product-edit-screen',
                        arguments: product,
                      );

                      if (newUpdated != null) {
                        context.read<HomeBloc>().add(FetchDashboardEvent());
                      }
                    },
                  );
                },
                separatorBuilder:
                    (BuildContext context, int index) => SizedBox(height: 12),
              ),
            ],
          ),
        );
      },
    );
  }
}
