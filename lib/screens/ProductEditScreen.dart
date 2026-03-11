import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warungpakwardi/constant/color.dart';
import 'package:warungpakwardi/widgets/ButtonCustom.dart';
import 'package:warungpakwardi/widgets/SnacbarCustom.dart';
import '../blocs/product_form/bloc/product_form_bloc.dart';
import '../blocs/product_form/bloc/product_form_event.dart';
import '../blocs/product_form/bloc/product_form_state.dart';
import '../models/Product.dart';
import '../widgets/TextFieldCustom.dart';

class ProductEditScreen extends StatefulWidget {
  const ProductEditScreen({super.key});

  @override
  State<ProductEditScreen> createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController amountPerUnitController;
  late TextEditingController unitController;
  late TextEditingController stockController;

  @override
  void initState() {
    super.initState();

    // Initialize controllers as empty strings
    nameController = TextEditingController();
    priceController = TextEditingController();
    amountPerUnitController = TextEditingController();
    unitController = TextEditingController();
    stockController = TextEditingController();
  }

  @override
  void dispose() {
    // Dispose controllers when no longer needed
    nameController.dispose();
    priceController.dispose();
    amountPerUnitController.dispose();
    unitController.dispose();
    stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        title: const Text(
          "Edit Produk",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: kWhiteColor,
      ),
      body: BlocConsumer<ProductFormBloc, ProductFormState>(
        listener: (context, state) {
          // Show error or success message when state changes
          if (!state.isSuccess && state.errorMessage != null) {
            SnackbarCustom.show(
              context,
              message: state.errorMessage!,
              status: SnackbarStatusType.error,
              type: SnackbarType.normal,
            );
            return;
          }

          if (state.isSuccess) {
            final updatedProduct = Product(
              id: state.id,
              name: state.name,
              price: state.price,
              amountPerUnit: state.amountPerUnit,
              unit: state.unit,
              stock: state.stock,
            );

            Navigator.pop(context, updatedProduct);
          }
        },
        builder: (context, state) {
          // Initialize controllers with state values only when editing
          if (state.isEdit && nameController.text.isEmpty) {
            nameController.text = state.name;
            priceController.text = state.price.toString();
            amountPerUnitController.text = state.amountPerUnit.toString();
            unitController.text = state.unit;
            stockController.text = state.stock.toString();
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              spacing: 15,
              children: [
                TextFieldCustom(
                  controller: nameController,
                  title: 'Nama Produk',
                  hintText: 'Nama Produk',
                  onChange: (value) {
                    context.read<ProductFormBloc>().add(
                      UpdateProductName(value),
                    );
                  },
                ),
                TextFieldCustom(
                  controller: priceController,
                  title: 'Harga Produk',
                  hintText: 'Harga Produk',
                  textInputType: TextFieldType.number,
                  onChange: (value) {
                    context.read<ProductFormBloc>().add(
                      UpdateProductPrice(double.tryParse(value) ?? 0),
                    );
                  },
                ),
                TextFieldCustom(
                  controller: amountPerUnitController,
                  title: 'Jumlah Persatuan',
                  hintText: '1, 10, 20, 50, 100',
                  textInputType: TextFieldType.number,
                  onChange: (value) {
                    context.read<ProductFormBloc>().add(
                      UpdateProductAmountPerUnit(int.tryParse(value) ?? 0),
                    );
                  },
                ),
                TextFieldCustom(
                  controller: unitController,
                  title: 'Satuan',
                  hintText: '(kg, liter, pcs, dll.)',
                  onChange: (value) {
                    context.read<ProductFormBloc>().add(
                      UpdateProductUnit(value),
                    );
                  },
                ),
                TextFieldCustom(
                  controller: stockController,
                  title: 'Jumlah Stok',
                  hintText: 'Jumlah Stok',
                  textInputType: TextFieldType.number,
                  onChange: (value) {
                    context.read<ProductFormBloc>().add(
                      UpdateProductStock(int.tryParse(value) ?? 0),
                    );
                  },
                ),
                const SizedBox(height: 15),
                ButtonCustom(
                  name:
                      state.isLoading
                          ? 'Loading...'
                          : 'Simpan', // Show loading state if in progress
                  onClick: () {
                    context.read<ProductFormBloc>().add(
                      SubmitProductForm(productId: state.id),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
