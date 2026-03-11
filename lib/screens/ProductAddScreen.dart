import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warungpakwardi/constant/color.dart';
import 'package:warungpakwardi/models/Product.dart';
import 'package:warungpakwardi/widgets/ButtonCustom.dart';
import 'package:warungpakwardi/widgets/SnacbarCustom.dart';
import '../blocs/product_form/bloc/product_form_bloc.dart';
import '../blocs/product_form/bloc/product_form_event.dart';
import '../blocs/product_form/bloc/product_form_state.dart';
import '../widgets/TextFieldCustom.dart';

class ProductAddScreen extends StatefulWidget {
  const ProductAddScreen({super.key});

  @override
  State<ProductAddScreen> createState() => _ProductAddScreenState();
}

class _ProductAddScreenState extends State<ProductAddScreen> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController amountPerUnitController;
  late TextEditingController unitController;
  late TextEditingController stockController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    priceController = TextEditingController();
    amountPerUnitController = TextEditingController();
    unitController = TextEditingController();
    stockController = TextEditingController();
  }

  @override
  void dispose() {
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
          "Tambah Produk",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: kWhiteColor,
      ),
      body: BlocConsumer<ProductFormBloc, ProductFormState>(
        listener: (context, state) {
          if (state.errorMessage != null && !state.isSuccess) {
            SnackbarCustom.show(
              context,
              message: state.errorMessage!,
              status: SnackbarStatusType.error,
              type: SnackbarType.normal,
            );
            return;
          }

          if (state.isSuccess) {
            final newProduct = Product(
              id: state.id,
              name: state.name,
              price: state.price,
              amountPerUnit: state.amountPerUnit,
              unit: state.unit,
              stock: state.stock,
            );

            Navigator.pop(context, newProduct);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: SingleChildScrollView(
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
                  const SizedBox(height: 20),
                  ButtonCustom(
                    name: state.isLoading ? 'Loading...' : 'Simpan',
                    onClick: () {
                      context.read<ProductFormBloc>().add(
                        SubmitProductForm(productId: state.id),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
