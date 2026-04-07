import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warungpakwardi/constant/color.dart';
import 'package:warungpakwardi/widgets/TextFieldCustom.dart';
import 'package:warungpakwardi/widgets/product/ProductList.dart';

import '../blocs/product/bloc/product_bloc.dart';
import '../blocs/product_form/bloc/product_form_bloc.dart';
import '../blocs/product_form/bloc/product_form_state.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface(context),
      appBar: AppBar(
        backgroundColor: AppColors.surface(context),
        scrolledUnderElevation: 0,
        title: Text(
          "Katalog Produk",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface(context),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.pushNamed(context, '/product-add-screen');
              if (context.mounted) {
                context.read<ProductBloc>().add(FetchProductEvent());
              }
            },
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: kBluePrimary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add_rounded, color: kBluePrimary),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 8),
            // Modern Search Bar
            Container(
              decoration: BoxDecoration(
                color: AppColors.card(context),
                borderRadius: BorderRadius.circular(28),
                boxShadow: AppColors.softShadow(context),
              ),
              child: TextFieldCustom(
                controller: _searchController,
                hintText: 'Cari produk...',
                prefix: const Icon(Icons.search_rounded, color: kBluePrimary),
                suffix: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          context.read<ProductBloc>().add(SearchProductEvent(''));
                          setState(() {});
                        },
                      )
                    : null,
                colorField: Colors.transparent,
                onChange: (value) {
                  context.read<ProductBloc>().add(SearchProductEvent(value));
                  setState(() {});
                },
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<ProductFormBloc, ProductFormState>(
                builder: (context, state) {
                  return const ProductList();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
