import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warungpakwardi/blocs/home/bloc/home_bloc.dart';
import 'package:warungpakwardi/constant/color.dart'; // import AppColors
import 'package:warungpakwardi/main.dart'; // untuk routeObserver

import 'package:warungpakwardi/widgets/homescreen/DashboardHero.dart';
import 'package:warungpakwardi/widgets/homescreen/LowStock.dart';
import 'package:warungpakwardi/widgets/homescreen/QuickMenu.dart';

import '../widgets/homescreen/AppBarTitleDashboard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  /// Dipanggil setiap kali user kembali ke HomeScreen (pop dari halaman lain)
  @override
  void didPopNext() {
    context.read<HomeBloc>().add(RefreshDashboardEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Redesign: Hapus Scaffold.appBar agar header bisa full-bleed gradient
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<HomeBloc>().add(FetchDashboardEvent());
          // Wait for state to change from loading
          await context.read<HomeBloc>().stream.firstWhere(
            (state) => state is! FetchDashboardLoadingState,
          );
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const AppBarTitleDashboard(), // Header Gradient
              const SizedBox(height: 10),
              DashboardHero(),              // Metric Cards
              const QuickMenu(),            // Grid Quick Menu
              const LowStock(),             // Low Stock Section
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
