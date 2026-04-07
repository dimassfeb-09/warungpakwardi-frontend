import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warungpakwardi/constant/color.dart';
import 'package:warungpakwardi/helper/toIDR.dart';
import 'package:warungpakwardi/models/Product.dart';
import 'package:warungpakwardi/widgets/SelectItemCustom.dart';
import 'package:warungpakwardi/widgets/SnacbarCustom.dart';
import '../blocs/product/bloc/product_bloc.dart';
import '../blocs/transaction_add/bloc/transaction_add_bloc.dart';
import '../blocs/transaction_add/bloc/transaction_add_event.dart';
import '../blocs/transaction_add/bloc/transaction_add_state.dart';
import 'package:warungpakwardi/widgets/ButtonCustom.dart';

class TransactionAddScreen extends StatelessWidget {
  const TransactionAddScreen({super.key});

  double getTotalPrice(List<CheckoutItem> selectedProduct) {
    return selectedProduct.fold(
      0,
      (total, item) => total + (item.product.price * item.quantity),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return Scaffold(
      backgroundColor: isDark ? kBlackColor : kLightGreyColor,
      appBar: AppBar(
        title: Text(
          "Transaksi Baru",
          style: AppTypography.subHeader(context).copyWith(
            color: isDark ? kWhiteColor : kBlackColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: isDark ? kBlackColor : kLightGreyColor,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? kWhiteColor : kBlackColor),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/transaction-list-screen'),
            icon: const Icon(Icons.history_rounded),
          ),
        ],
      ),
      body: BlocConsumer<TransactionAddBloc, TransactionAddState>(
        listener: (context, state) {
          if (state is TransactionAddErrorState) {
            SnackbarCustom.show(
              context,
              message: state.message,
              status: SnackbarStatusType.error,
              type: SnackbarType.normal,
            );
            return;
          }

          if (state is TransactionAddLoadedState) {
            Navigator.pushNamed(
              context,
              '/transaction-detail-screen',
              arguments: state.transactionId,
            );
          }
        },
        builder: (context, state) {
          final selectedProduct = state.items;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProductSelector(context),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Icon(Icons.shopping_bag_outlined, size: 20, color: isDark ? kWhiteColor : kBlackColor),
                          const SizedBox(width: 8),
                          Text(
                            "Keranjang Belanja",
                            style: AppTypography.title(context),
                          ),
                          const Spacer(),
                          if (selectedProduct.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: kBluePrimary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${selectedProduct.length} Produk',
                                style: AppTypography.caption(context).copyWith(color: kBluePrimary, fontWeight: FontWeight.bold),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (selectedProduct.isEmpty)
                        _buildEmptyCart(context)
                      else
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: selectedProduct.length,
                          itemBuilder: (context, index) {
                            return _buildCartItem(context, selectedProduct[index]);
                          },
                        ),
                    ],
                  ),
                ),
              ),
              _buildBottomAction(context, state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProductSelector(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        List<Product> products = [];
        if (state is FetchProductLoadedState) {
          products = state.products;
        }

        return SelectItemCustom(
          items: products
              .map((product) => ItemSelected(
                    key: product.id.toString(),
                    value: product.name,
                    subtitle: 'Stok: ${product.stock}',
                    trailing: toIDR(product.price.toInt()),
                    disabled: product.stock <= 0,
                  ))
              .toList(),
          onSelect: (selectedItem) {
            final product = products.firstWhere((p) => '${p.id}' == selectedItem.key);
            context.read<TransactionAddBloc>().add(AddProductToCart(product));
          },
          hint: 'Cari produk...',
        );
      },
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Column(
          children: [
            Icon(Icons.add_shopping_cart_rounded, size: 60, color: kGreyDarkColor.withOpacity(0.3)),
            const SizedBox(height: 16),
            Text(
              "Keranjang masih kosong.\nSilakan pilih produk di atas.",
              textAlign: TextAlign.center,
              style: AppTypography.body(context).copyWith(color: kGreyDarkColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, CheckoutItem item) {
    final isDark = AppColors.isDark(context);
    final totalPrice = item.product.price * item.quantity;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? kBlack2Color : kWhiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.softShadow(context).map((s) => s.copyWith(blurRadius: 5)).toList(),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.name,
                      style: AppTypography.title(context),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      toIDR(item.product.price.toInt()),
                      style: AppTypography.caption(context).copyWith(color: kBluePrimary, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => context.read<TransactionAddBloc>().add(RemoveProductFromCart(item.product)),
                icon: const Icon(Icons.delete_outline_rounded, color: kRedColor, size: 22),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Total Harga", style: AppTypography.caption(context)),
                  Text(toIDR(totalPrice.toInt()), style: AppTypography.title(context).copyWith(fontSize: 15)),
                ],
              ),
              _buildQtyControls(context, item),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQtyControls(BuildContext context, CheckoutItem item) {
    return Row(
      children: [
        _buildQtyBtn(
          context,
          icon: Icons.remove,
          onTap: () => context.read<TransactionAddBloc>().add(DecreaseQuantity(item.product)),
        ),
        Container(
          width: 40,
          alignment: Alignment.center,
          child: Text(
            '${item.quantity}',
            style: AppTypography.title(context),
          ),
        ),
        _buildQtyBtn(
          context,
          icon: Icons.add,
          color: item.quantity >= item.product.stock ? kGreyDarkColor.withOpacity(0.3) : kBluePrimary,
          onTap: () {
            if (item.quantity < item.product.stock) {
              context.read<TransactionAddBloc>().add(IncreaseQuantity(item.product));
            }
          },
        ),
      ],
    );
  }

  Widget _buildQtyBtn(BuildContext context, {required IconData icon, required VoidCallback onTap, Color? color}) {
    final isDark = AppColors.isDark(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            border: Border.all(color: color ?? (isDark ? Colors.white24 : Colors.black12)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: color ?? (isDark ? kWhiteColor : kBlackColor)),
        ),
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context, TransactionAddState state) {
    final isDark = AppColors.isDark(context);
    final totalPrice = getTotalPrice(state.items);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? kBlack2Color : kWhiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -4),
            blurRadius: 10,
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total Pembayaran", style: AppTypography.body(context)),
                Text(
                  toIDR(totalPrice.toInt()),
                  style: AppTypography.header(context).copyWith(fontSize: 22, color: kBluePrimary),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ButtonCustom(
                    name: "Batal",
                    color: Colors.transparent,
                    colorLabel: kRedColor,
                    useShadow: false,
                    onClick: () => context.read<TransactionAddBloc>().add(TransactionClearField()),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ButtonCustom(
                    name: state is TransactionAddLoadingState ? "Proses..." : "Simpan Transaksi",
                    gradient: const [kBluePrimary, Color(0xFF1E40AF)],
                    disabled: state.items.isEmpty || state is TransactionAddLoadingState,
                    onClick: () {
                      context.read<TransactionAddBloc>().add(
                            SubmitTransactionEvent(checkoutItem: state.items),
                          );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
