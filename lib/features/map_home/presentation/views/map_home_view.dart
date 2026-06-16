import 'dart:async';

import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/features/map_home/cubit/map_home_cubit.dart';
import 'package:doctory/features/map_home/presentation/sections/map_home_body_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MapHomeView extends StatefulWidget {
  final String? searchQuery;

  const MapHomeView({super.key, this.searchQuery});

  @override
  State<MapHomeView> createState() => _MapHomeViewState();
}

class _MapHomeViewState extends State<MapHomeView> {
  late final MapHomeCubit _cubit;
  Timer? _locationTimer;

  @override
  void initState() {
    super.initState();
    _cubit = sl<MapHomeCubit>()..searchClinics(searchText: widget.searchQuery);

    // Use a periodic Timer instead of a Ticker.
    // A Ticker fires every single frame (60fps), which forces Flutter to constantly
    // render new frames. When combined with a PlatformView like GoogleMap, this
    // continuous rendering can cause severe lag and jank even if no widgets are rebuilding.
    _locationTimer = Timer.periodic(const Duration(seconds: 20), (_) {
      _cubit.checkLiveLocation();
    });
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.searchQuery);
    return BlocProvider.value(
      value: _cubit,
      child: const Scaffold(body: MapHomeBodySection()),
    );
  }
}
