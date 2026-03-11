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

class TransactionAddScreen extends StatelessWidget {
  const TransactionAddScreen({super.key});

  double getTotalPrice(List<CheckoutItem> selectedProduct) {
    return selectedProduct.fold(
      0,
      (total, item) => total + ((item.product.price ?? 0) * item.quantity),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        title: const Text(
          "Tambah Transaksi",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: kWhiteColor,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/transaction-list-screen');
            },
            icon: const Icon(Icons.history),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  List<Product> products = [];

                  if (state is FetchProductLoadedState) {
                    products = state.products;
                  } else if (state is FetchProductLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is FetchProductErrorState) {
                    return const Text("Gagal memuat produk");
                  }

                  return SelectItemCustom(
                    items:
                        products
                            .map(
                              (product) => ItemSelected(
                                key: product.id.toString(),
                                value: product.name,
                              ),
                            )
                            .toList(),
                    onSelect: (selectedItem) {
                      final product = products.firstWhere(
                        (p) => '${p.id}' == selectedItem.key,
                      );
                      context.read<TransactionAddBloc>().add(
                        AddProductToCart(product),
                      );
                    },
                    hint: 'Pilih Produk',
                  );
                },
              ),
              const SizedBox(height: 16),

              BlocConsumer<TransactionAddBloc, TransactionAddState>(
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
                  return BlocBuilder<TransactionAddBloc, TransactionAddState>(
                    builder: (context, state) {
                      final selectedProduct = state.items;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                "Keranjang",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: kBluePrimary,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '${selectedProduct.length}',
                                  style: const TextStyle(color: kWhiteColor),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: selectedProduct.length,
                            separatorBuilder:
                                (_, __) => const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              final item = selectedProduct[index];
                              final totalPrice =
                                  (item.product.price ?? 0) * item.quantity;

                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: kGreyDarkColor.withAlpha(90),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          item.product.name ?? '',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            context
                                                .read<TransactionAddBloc>()
                                                .add(
                                                  RemoveProductFromCart(
                                                    item.product,
                                                  ),
                                                );
                                          },
                                          child: const Icon(
                                            Icons.delete,
                                            size: 22,
                                            color: kRedColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${item.quantity} x ${toIDR((item.product.price ?? 0).toInt())}",
                                        ),
                                        Text(
                                          toIDR(totalPrice.toInt()),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${item.product.stock} stok tersisa",
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                context
                                                    .read<TransactionAddBloc>()
                                                    .add(
                                                      DecreaseQuantity(
                                                        item.product,
                                                      ),
                                                    );
                                              },
                                              child: Container(
                                                height: 30,
                                                width: 30,
                                                decoration: BoxDecoration(
                                                  border: Border.all(),
                                                ),
                                                child: const Icon(Icons.remove),
                                              ),
                                            ),
                                            Container(
                                              height: 30,
                                              width: 30,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                border: Border.all(),
                                              ),
                                              child: Text('${item.quantity}'),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                context
                                                    .read<TransactionAddBloc>()
                                                    .add(
                                                      IncreaseQuantity(
                                                        item.product,
                                                      ),
                                                    );
                                              },
                                              child: Container(
                                                height: 30,
                                                width: 30,
                                                decoration: BoxDecoration(
                                                  border: Border.all(),
                                                ),
                                                child: const Icon(Icons.add),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),

                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: kGreyDarkColor.withAlpha(90),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Total",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  toIDR(getTotalPrice(selectedProduct).toInt()),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 20),

                          Row(
                            spacing: 15,
                            children: [
                              GestureDetector(
                                onTap:
                                    () => context
                                        .read<TransactionAddBloc>()
                                        .add(TransactionClearField()),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 2,
                                      color: kGreyDarkColor.withAlpha(90),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  height: 60,
                                  width: 100,
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Batal",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap:
                                      state is! TransactionAddLoadingState
                                          ? () {
                                            context
                                                .read<TransactionAddBloc>()
                                                .add(
                                                  SubmitTransactionEvent(
                                                    checkoutItem: state.items,
                                                  ),
                                                );
                                          }
                                          : null,
                                  child: Container(
                                    height: 60,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color:
                                          state is TransactionAddLoadingState
                                              ? kGreyDarkColor
                                              : kBluePrimary,
                                      border: Border.all(
                                        width: 2,
                                        color: kGreyDarkColor.withAlpha(90),
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      state is TransactionAddLoadingState
                                          ? "Loading..."
                                          : "Simpan Transaksi",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: kWhiteColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
