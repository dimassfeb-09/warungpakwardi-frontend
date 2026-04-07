import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warungpakwardi/widgets/homescreen/DataCard.dart';
import 'package:warungpakwardi/constant/color.dart';
import 'package:warungpakwardi/widgets/homescreen/DashboardShimmer.dart'; // import Shimmer

import '../../blocs/home/bloc/home_bloc.dart';

class DashboardHero extends StatelessWidget {
  DashboardHero({super.key});

  final List<DataCardModel> _initialDataCards = const [
    DataCardModel(
      value: 0,
      type: TypeValue.normal,
      assetPath: "assets/product.svg",
      title: "Total Produk",
      accentColor: kAccentProduct,
    ),
    DataCardModel(
      value: 0,
      type: TypeValue.normal,
      assetPath: "assets/receipt.svg",
      title: "Trx Hari Ini",
      accentColor: kAccentTrx,
    ),
    DataCardModel(
      value: 0,
      type: TypeValue.rupiah,
      assetPath: "assets/balance.svg",
      title: "Omzet Hari Ini",
      accentColor: kAccentRevenue,
    ),
    DataCardModel(
      value: 0,
      type: TypeValue.normal,
      assetPath: "assets/alert.svg",
      title: "Stok Menipis",
      accentColor: kAccentLowStock,
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

        if (state is FetchDashboardLoadingState) {
          return const DashboardShimmer();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: dataCardModels.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.1,
            ),
            itemBuilder:
                (context, index) => DataCard(
                  key: ValueKey("data_card_$index"),
                  data: dataCardModels[index],
                ),
          ),
        );
      },
    );
  }
}
