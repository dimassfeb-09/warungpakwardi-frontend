import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warungpakwardi/blocs/home/bloc/home_bloc.dart';
import 'package:warungpakwardi/utils/secureStorage.dart';
import 'package:warungpakwardi/widgets/homescreen/DashboardHero.dart';
import 'package:warungpakwardi/widgets/homescreen/LowStock.dart';
import 'package:warungpakwardi/widgets/homescreen/QuickMenu.dart';

import '../widgets/homescreen/AppBarTitleDashboard.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 90,
        title: AppBarTitleDashboard(),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await secureStorage.delete(key: "token");
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/login-screen', (route) => false);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 2));
          context.read<HomeBloc>().add(FetchDashboardEvent());
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              DashboardHero(),
              QuickMenu(),
              LowStock(),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
