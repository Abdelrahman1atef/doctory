import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../theme/theme_manager.dart';

part 'general_state.dart';

class GeneralCubit extends Cubit<GeneralState> {
  GeneralCubit() : super(GeneralInitial()) {
    _monitorConnectivity();
  }

  static GeneralCubit get(context) => BlocProvider.of(context);

  StreamSubscription<InternetStatus>? _connectivitySubscription;
  bool _isConnected = true;
  bool get isConnected => _isConnected;

  void _monitorConnectivity() {
    _connectivitySubscription = InternetConnection().onStatusChange.listen((
      status,
    ) {
      _isConnected = status == InternetStatus.connected;
      emit(ConnectivityChanged(_isConnected));
    });
  }

  // change app theme
  bool isLightMode = true;
  void changeAppTheme() {
    isLightMode = !isLightMode;
    if (isLightMode) {
      AppThemeManager.instance.setLightTheme();
    } else {
      AppThemeManager.instance.setDarkTheme();
    }
    emit(GeneralChangeAppTheme());
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
