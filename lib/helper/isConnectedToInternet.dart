import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

Future<bool> isConnectedToInternet() async {
  final bool isConnected =
      await InternetConnectionChecker.instance.hasConnection;
  return isConnected;
}
