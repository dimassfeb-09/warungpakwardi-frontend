import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warungpakwardi/models/Product.dart';
import 'package:warungpakwardi/widgets/product/CardProduct.dart';
import 'package:warungpakwardi/widgets/product/EmptyProduct.dart';
import '../../blocs/product/bloc/product_bloc.dart';

class ProductList extends StatelessWidget {
  const ProductList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is FetchProductLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        List<Product> products = [];
        if (state is FetchProductLoadedState) {
          products = state.products;
        }

        if (products.isEmpty && state is FetchProductLoadedState) {
          return const EmptyProduct();
        }

        return ListView.separated(
          padding: const EdgeInsets.only(top: 4, bottom: 20),
          itemCount: products.length,
          itemBuilder:
              (context, index) => CardProduct(
                key: ValueKey("product_card_${products[index].id}"),
                product: products[index],
                onEdit: () async {
                  await Navigator.pushNamed(
                    context,
                    '/product-edit-screen',
                    arguments: products[index],
                  );

                  if (context.mounted) {
                    context.read<ProductBloc>().add(FetchProductEvent());
                  }
                },
                onDelete: () {
                  context.read<ProductBloc>().add(
                    DeleteProductEvent(productId: products[index].id),
                  );
                },
              ),
          separatorBuilder:
              (BuildContext context, int index) => const SizedBox(height: 16),
        );
      },
    );
  }
}
