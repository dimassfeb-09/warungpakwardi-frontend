import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warungpakwardi/blocs/login/bloc/login_bloc.dart';
import 'package:warungpakwardi/screens/HomeScreen.dart';
import 'package:warungpakwardi/screens/LoginScreen.dart';
import 'package:warungpakwardi/screens/ProductAddScreen.dart';
import 'package:warungpakwardi/screens/ProductEditScreen.dart';
import 'package:warungpakwardi/screens/ProductListScreen.dart';
import 'package:warungpakwardi/screens/RegisterScreen.dart';
import 'package:warungpakwardi/screens/SplashScreen.dart';
import 'package:warungpakwardi/screens/TransactionAddScreen.dart';
import 'package:warungpakwardi/screens/TransactionDetailScreen.dart';
import 'package:warungpakwardi/screens/TransactionListScreen.dart';

import 'blocs/auth/bloc/auth_bloc.dart';
import 'blocs/home/bloc/home_bloc.dart';
import 'blocs/product/bloc/product_bloc.dart';
import 'blocs/product_form/bloc/product_form_bloc.dart';
import 'blocs/product_form/bloc/product_form_event.dart';
import 'blocs/register/register_bloc.dart';
import 'blocs/report/bloc/report_bloc.dart';
import 'blocs/transaction/bloc/transaction_bloc.dart';
import 'blocs/transaction_add/bloc/transaction_add_bloc.dart';
import 'blocs/transaction_detail/bloc/transaction_detail_bloc.dart';
import 'models/Product.dart';
import 'screens/ReportScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/splash-screen',
      routes: {
        '/splash-screen':
            (context) => BlocProvider(
              create: (context) => AuthBloc()..add(FetchUserDetailEvent()),
              child: SplashScreen(),
            ),
        '/login-screen':
            (context) => BlocProvider(
              create: (context) => LoginBloc(),
              child: LoginScreen(),
            ),
        '/register-screen':
            (context) => BlocProvider(
              create: (context) => RegisterBloc(),
              child: RegisterScreen(),
            ),
        '/home-screen':
            (context) => BlocProvider(
              create: (context) => HomeBloc()..add(FetchDashboardEvent()),
              child: HomeScreen(),
            ),
        '/product-list-screen':
            (context) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => ProductBloc()..add(FetchProductEvent()),
                ),
                BlocProvider(create: (context) => ProductFormBloc()),
              ],
              child: ProductListScreen(),
            ),
        '/product-add-screen':
            (context) => BlocProvider(
              create: (_) => ProductFormBloc(),
              child: ProductAddScreen(),
            ),

        '/product-edit-screen': (context) {
          final product = ModalRoute.of(context)!.settings.arguments as Product;

          return BlocProvider(
            create:
                (_) => ProductFormBloc()..add(LoadProductForEditEvent(product)),
            child: ProductEditScreen(),
          );
        },

        '/transaction-list-screen':
            (context) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create:
                      (context) =>
                          TransactionBloc()..add(FetchTransactionEvent()),
                ),
                BlocProvider(
                  create: (context) => HomeBloc()..add(FetchDashboardEvent()),
                ),
              ],
              child: TransactionListScreen(),
            ),
        '/transaction-add-screen':
            (context) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => ProductBloc()..add(FetchProductEvent()),
                ),
                BlocProvider(create: (_) => TransactionAddBloc()),
              ],
              child: TransactionAddScreen(),
            ),
        '/transaction-detail-screen': (context) {
          final transactionId =
              ModalRoute.of(context)!.settings.arguments as String;
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create:
                    (_) =>
                        TransactionDetailBloc()..add(
                          LoadTransactionDetailEvent(
                            transactionId: transactionId,
                          ),
                        ),
              ),
              BlocProvider(
                create: (context) => AuthBloc()..add(FetchUserDetailEvent()),
              ),
            ],
            child: TransactionDetailScreen(),
          );
        },

        '/report-screen':
            (context) => BlocProvider(
              create: (_) => ReportBloc()..add(FetchReportTransaction()),
              child: ReportScreen(),
            ),
      },
    );
  }
}
