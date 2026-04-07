import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warungpakwardi/constant/color.dart';
import 'package:warungpakwardi/widgets/ButtonCustom.dart';
import 'package:warungpakwardi/widgets/SnacbarCustom.dart';
import '../blocs/product_form/bloc/product_form_bloc.dart';
import '../blocs/product_form/bloc/product_form_event.dart';
import '../blocs/product_form/bloc/product_form_state.dart';
import '../widgets/TextFieldCustom.dart';
import '../helper/toIDR.dart';

class ProductEditScreen extends StatefulWidget {
  const ProductEditScreen({super.key});

  @override
  State<ProductEditScreen> createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController purchasePriceController;
  late TextEditingController amountPerUnitController;
  late TextEditingController unitController;
  late TextEditingController stockController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    priceController = TextEditingController();
    purchasePriceController = TextEditingController();
    amountPerUnitController = TextEditingController();
    unitController = TextEditingController();
    stockController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    purchasePriceController.dispose();
    amountPerUnitController.dispose();
    unitController.dispose();
    stockController.dispose();
    super.dispose();
  }

  // Helper to sync controllers with state (once)
  bool _initialized = false;
  void _syncControllers(ProductFormState state) {
    if (!_initialized && state.isEdit && state.name.isNotEmpty) {
      nameController.text = state.name;
      priceController.text = state.price.toString();
      purchasePriceController.text = state.purchasePrice.toString();
      amountPerUnitController.text = state.amountPerUnit.toString();
      unitController.text = state.unit;
      stockController.text = state.stock.toString();
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return Scaffold(
      backgroundColor: isDark ? kBlackColor : kWhiteColor,
      appBar: AppBar(
        title: Text(
          "Edit Detail Produk",
          style: AppTypography.subHeader(context).copyWith(
            color: isDark ? kWhiteColor : kBlackColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: isDark ? kBlackColor : kWhiteColor,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? kWhiteColor : kBlackColor),
      ),
      body: BlocConsumer<ProductFormBloc, ProductFormState>(
        listener: (context, state) {
          _syncControllers(state);
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
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSection(
                  context,
                  title: "Informasi Dasar",
                  icon: Icons.info_outline_rounded,
                  children: [
                    TextFieldCustom(
                      controller: nameController,
                      title: 'Nama Produk',
                      hintText: 'Nama Produk',
                      prefix: const Icon(Icons.shopping_bag_outlined),
                      errorText: state.fieldErrors['name'],
                      onChange: (value) {
                        context.read<ProductFormBloc>().add(
                          UpdateProductName(value),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSection(
                  context,
                  title: "Harga & Keuntungan",
                  icon: Icons.payments_outlined,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextFieldCustom(
                            controller: purchasePriceController,
                            title: 'Harga Modal',
                            hintText: '0',
                            textInputType: TextFieldType.number,
                            prefix: const Icon(Icons.shopping_cart_outlined),
                            errorText: state.fieldErrors['purchasePrice'],
                            onChange: (value) {
                              context.read<ProductFormBloc>().add(
                                UpdateProductPurchasePrice(double.tryParse(value) ?? 0),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFieldCustom(
                            controller: priceController,
                            title: 'Harga Jual',
                            hintText: '0',
                            textInputType: TextFieldType.number,
                            prefix: const Icon(Icons.sell_outlined),
                            errorText: state.fieldErrors['price'],
                            onChange: (value) {
                              context.read<ProductFormBloc>().add(
                                UpdateProductPrice(double.tryParse(value) ?? 0),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    if (state.price > 0 && state.purchasePrice > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 16, left: 4),
                        child: Text(
                          "Estimasi Laba: ${toIDR(state.price - state.purchasePrice)} per barang",
                          style: AppTypography.caption(context).copyWith(
                            color: (state.price - state.purchasePrice) >= 0 ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSection(
                  context,
                  title: "Inventori & Satuan",
                  icon: Icons.inventory_2_outlined,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextFieldCustom(
                            controller: amountPerUnitController,
                            title: 'Isi per Kemasan',
                            hintText: 'Misal: 10',
                            textInputType: TextFieldType.number,
                            errorText: state.fieldErrors['amountPerUnit'],
                            onChange: (value) {
                              context.read<ProductFormBloc>().add(
                                UpdateProductAmountPerUnit(
                                  int.tryParse(value) ?? 0,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFieldCustom(
                            controller: unitController,
                            title: 'Satuan Jual',
                            hintText: 'kg, pcs, dll.',
                            errorText: state.fieldErrors['unit'],
                            onChange: (value) {
                              context.read<ProductFormBloc>().add(
                                UpdateProductUnit(value),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextFieldCustom(
                      controller: stockController,
                      title: 'Stok Tersedia',
                      hintText: '0.0',
                      textInputType: TextFieldType.number,
                      prefix: const Icon(Icons.layers_outlined),
                      errorText: state.fieldErrors['stock'],
                      onChange: (value) {
                        context.read<ProductFormBloc>().add(
                          UpdateProductStock(num.tryParse(value) ?? 0),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 4),
                      child: Text(
                        "Gunakan titik (.) untuk angka desimal (cth: 0.5)",
                        style: AppTypography.caption(context).copyWith(color: kGreyDarkColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                ButtonCustom(
                  name: state.isLoading ? 'Menyimpan...' : 'Simpan Perubahan',
                  gradient: const [kBluePrimary, Color(0xFF1E40AF)],
                  onClick: () {
                    if (state.isLoading) return;
                    context.read<ProductFormBloc>().add(
                      SubmitProductForm(productId: state.id),
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    final isDark = AppColors.isDark(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? kBlack2Color : kWhiteColor,
        borderRadius: BorderRadius.circular(kCardRadius),
        boxShadow: AppColors.softShadow(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: kBluePrimary, size: 22),
              const SizedBox(width: 10),
              Text(
                title,
                style: AppTypography.title(context).copyWith(
                  color: isDark ? kWhiteColor : kBluePrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }
}
