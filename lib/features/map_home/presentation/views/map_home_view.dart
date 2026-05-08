import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/features/map_home/cubit/map_home_cubit.dart';
import 'package:doctory/features/map_home/presentation/sections/map_home_body_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MapHomeView extends StatefulWidget {
  final String? searchQuery;
  const MapHomeView({super.key, this.searchQuery});

  @override
  State<MapHomeView> createState() => _MapHomeViewState();
}

class _MapHomeViewState extends State<MapHomeView>
    with SingleTickerProviderStateMixin {
  late final MapHomeCubit _cubit;
  late final Ticker _ticker;
  Duration _lastTick = Duration.zero;

  @override
  void initState() {
    super.initState();
    _cubit = sl<MapHomeCubit>()..searchClinics(searchText: widget.searchQuery);

    // Ticker pauses automatically when the widget is offstage (e.g. user is on another tab)
    _ticker = createTicker((elapsed) {
      if (elapsed - _lastTick > const Duration(seconds: 5)) {
        _lastTick = elapsed;
        _cubit.checkLiveLocation();
      }
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: const Scaffold(body: MapHomeBodySection()),
    );
  }
}
