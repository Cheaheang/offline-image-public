import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkMonitor {
  static final Connectivity _connectivity = Connectivity();

  static Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;
  static Future<List<ConnectivityResult>> checkConnectivity() =>
      _connectivity.checkConnectivity();
}
