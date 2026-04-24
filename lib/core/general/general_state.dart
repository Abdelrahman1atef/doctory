part of 'general_cubit.dart';

abstract class GeneralState {}

class GeneralInitial extends GeneralState {}

class GeneralChangeAppTheme extends GeneralState {}

class ConnectivityChanged extends GeneralState {
  final bool isConnected;
  ConnectivityChanged(this.isConnected);
}
