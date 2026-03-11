import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warungpakwardi/widgets/homescreen/DataCard.dart';

import '../../blocs/home/bloc/home_bloc.dart';

class DashboardHero extends StatelessWidget {
  DashboardHero({super.key});

  final List<DataCardModel> _initialDataCards = const [
    DataCardModel(
      value: 0,
      type: TypeValue.normal,
      assetPath: "assets/product.svg",
      title: "Total Produk",
    ),
    DataCardModel(
      value: 0,
      type: TypeValue.normal,
      assetPath: "assets/receipt.svg",
      title: "Transaksi Hari Ini",
    ),
    DataCardModel(
      value: 0,
      type: TypeValue.rupiah,
      assetPath: "assets/balance.svg",
      title: "Pendapatan Hari Ini",
    ),
    DataCardModel(
      value: 0,
      type: TypeValue.normal,
      assetPath: "assets/alert.svg",
      title: "Stok Menipis",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        List<DataCardModel> dataCardModels = _initialDataCards;

        if (state is FetchDashboardLoadedState) {
          final dashboard = state.dashboard;
          dataCardModels = [
            _initialDataCards[0].copyWith(value: dashboard.totalProduct),
            _initialDataCards[1].copyWith(value: dashboard.totalTransaction),
            _initialDataCards[2].copyWith(value: dashboard.revenue),
            _initialDataCards[3].copyWith(
              value: dashboard.productLowStock?.length ?? 0,
            ),
          ];
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.38,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: dataCardModels.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1 / 0.8,
              ),
              itemBuilder:
                  (context, index) => DataCard(
                    key: ValueKey(index),
                    data: dataCardModels[index],
                  ),
            ),
          ),
        );
      },
    );
  }
}
