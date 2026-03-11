import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warungpakwardi/models/Product.dart';
import 'package:warungpakwardi/widgets/product/CardProduct.dart';
import '../../blocs/product/bloc/product_bloc.dart';

class ProductList extends StatelessWidget {
  const ProductList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        List<Product> products = [];

        if (state is FetchProductLoadedState) {
          products = state.products;
        }

        return ListView.separated(
          itemCount: products.length,
          itemBuilder:
              (context, index) => CardProduct(
                product: products[index],
                onEdit: () async {
                  final updatedProduct = await Navigator.pushNamed(
                    context,
                    '/product-edit-screen',
                    arguments: products[index],
                  );

                  if (updatedProduct != null) {
                    context.read<ProductBloc>().add(
                      UpdateProductEvent(updatedProduct as Product),
                    );
                  }
                },
                onDelete: () {
                  context.read<ProductBloc>().add(
                    DeleteProductEvent(productId: products[index].id!),
                  );
                },
              ),
          separatorBuilder:
              (BuildContext context, int index) => SizedBox(height: 12),
        );
      },
    );
  }
}
