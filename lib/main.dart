import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warungpakwardi/screens/HomeScreen.dart';
import 'package:warungpakwardi/screens/ProductAddScreen.dart';
import 'package:warungpakwardi/screens/ProductEditScreen.dart';
import 'package:warungpakwardi/screens/ProductListScreen.dart';
import 'package:warungpakwardi/screens/TransactionAddScreen.dart';
import 'package:warungpakwardi/screens/TransactionDetailScreen.dart';
import 'package:warungpakwardi/screens/TransactionListScreen.dart';

import 'blocs/home/bloc/home_bloc.dart';
import 'blocs/product/bloc/product_bloc.dart';
import 'blocs/product_form/bloc/product_form_bloc.dart';
import 'blocs/product_form/bloc/product_form_event.dart';
import 'blocs/report/bloc/report_bloc.dart';
import 'blocs/theme/bloc/theme_bloc.dart';
import 'blocs/theme/bloc/theme_event.dart';
import 'blocs/theme/bloc/theme_state.dart';
import 'blocs/transaction/bloc/transaction_bloc.dart';
import 'blocs/transaction_add/bloc/transaction_add_bloc.dart';
import 'blocs/transaction_detail/bloc/transaction_detail_bloc.dart';
import 'constant/color.dart'; // import color constants
import 'package:intl/date_symbol_data_local.dart';
import 'package:warungpakwardi/db/local/database_helper.dart';
import 'package:warungpakwardi/models/Product.dart';
import 'package:warungpakwardi/screens/ReportScreen.dart';
import 'package:warungpakwardi/screens/SettingsScreen.dart';

/// RouteObserver global — digunakan oleh HomeScreen untuk mendeteksi pop-back
final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Locale Data
  await initializeDateFormatting('id_ID', null);

  // Initialize Database
  await DatabaseHelper().database;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // HomeBloc di-provide di level root agar persist lintas route
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc()..add(FetchDashboardEvent()),
        ),
        BlocProvider<ThemeBloc>(
          create: (context) => ThemeBloc()..add(LoadTheme()),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'Warung Digital',
            debugShowCheckedModeBanner: false,
            themeMode: themeState.themeMode,
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: kBluePrimary,
                brightness: Brightness.light,
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 0,
              ),
              scaffoldBackgroundColor: const Color(
                0xFFFAFAFC,
              ), // Light grey/white
              fontFamily: 'Poppins',
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: kBluePrimary,
                brightness: Brightness.dark,
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF0c0f14),
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              scaffoldBackgroundColor: const Color(
                0xFF0c0f14,
              ), // Dark navy black
              fontFamily: 'Poppins',
            ),
            navigatorObservers: [routeObserver],
            initialRoute: '/home-screen',
            routes: {
              '/home-screen': (context) => const HomeScreen(),
              '/product-list-screen': (context) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) =>
                        ProductBloc()..add(FetchProductEvent()),
                  ),
                  BlocProvider(create: (context) => ProductFormBloc()),
                ],
                child: ProductListScreen(),
              ),
              '/product-add-screen': (context) => BlocProvider(
                create: (_) => ProductFormBloc(),
                child: ProductAddScreen(),
              ),

              '/product-edit-screen': (context) {
                final product =
                    ModalRoute.of(context)!.settings.arguments as Product;

                return BlocProvider(
                  create: (_) =>
                      ProductFormBloc()..add(LoadProductForEditEvent(product)),
                  child: ProductEditScreen(),
                );
              },

              '/transaction-list-screen': (context) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) =>
                        TransactionBloc()..add(FetchTransactionEvent()),
                  ),
                ],
                child: TransactionListScreen(),
              ),
              '/transaction-add-screen': (context) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) =>
                        ProductBloc()..add(FetchProductEvent()),
                  ),
                  BlocProvider(create: (_) => TransactionAddBloc()),
                ],
                child: TransactionAddScreen(),
              ),
              '/transaction-detail-screen': (context) {
                final transactionId =
                    ModalRoute.of(context)!.settings.arguments as String;
                return BlocProvider(
                  create: (_) => TransactionDetailBloc()
                    ..add(
                      LoadTransactionDetailEvent(transactionId: transactionId),
                    ),
                  child: TransactionDetailScreen(),
                );
              },

              '/report-screen': (context) => BlocProvider(
                create: (_) => ReportBloc()..add(FetchReportTransaction()),
                child: ReportScreen(),
              ),
              '/settings-screen': (context) => const SettingsScreen(),
            },
          );
        },
      ),
    );
  }
}
