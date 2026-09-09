import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnection connectionChecker;

  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected async {
    // Rely on Dio's built-in timeout and SocketExceptions rather than 
    // pinging endpoints which can block or fail on some networks in release mode.
    return true;
  }
}
