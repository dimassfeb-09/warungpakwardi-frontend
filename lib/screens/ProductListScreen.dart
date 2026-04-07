import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warungpakwardi/constant/color.dart';
import 'package:warungpakwardi/models/Product.dart';
import 'package:warungpakwardi/widgets/TextFieldCustom.dart';
import 'package:warungpakwardi/widgets/product/ProductList.dart';

import '../blocs/product/bloc/product_bloc.dart';
import '../blocs/product_form/bloc/product_form_bloc.dart';
import '../blocs/product_form/bloc/product_form_state.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        title: Text(
          "Daftar Produk",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              final newProduct = await Navigator.pushNamed(
                context,
                '/product-add-screen',
              );

              if (newProduct != null) {
                context.read<ProductBloc>().add(
                  UpdateProductEvent(newProduct as Product),
                );
              }
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 15,
          children: [
            TextFieldCustom(hintText: 'Cari produk....'),
            Expanded(
              child: BlocBuilder<ProductFormBloc, ProductFormState>(
                builder: (context, state) {
                  return ProductList();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
