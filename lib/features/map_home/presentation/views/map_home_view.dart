import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/features/map_home/cubit/map_home_cubit.dart';
import 'package:doctory/features/map_home/presentation/sections/map_home_body_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MapHomeView extends StatelessWidget {
  final String? searchQuery;
  const MapHomeView({super.key, this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<MapHomeCubit>()..searchClinics(searchText: searchQuery),
      child: const Scaffold(body: MapHomeBodySection()),
    );
  }
}
