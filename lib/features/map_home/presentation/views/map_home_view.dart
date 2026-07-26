import 'dart:async';

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
  Timer? _locationTimer;

  @override
  void initState() {
    super.initState();
    _locationTimer = Timer.periodic(const Duration(seconds: 20), (_) {
      context.read<MapHomeCubit>().checkLiveLocation();
    });
  }

  @override
  void didUpdateWidget(covariant MapHomeView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchQuery != oldWidget.searchQuery) {
      context.read<MapHomeCubit>().searchClinics(
        searchText: widget.searchQuery,
      );
    }
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MapHomeBodySection(),
    );
  }
}
