import 'package:doctory/features/map_home/presentation/widgets/map_filter_bottom_sheet.dart';
import 'package:doctory/features/map_home/presentation/widgets/map_filter_chip_widget.dart';
import 'package:doctory/features/map_home/presentation/widgets/map_search_bar_widget.dart';
import 'package:doctory/features/map_home/presentation/widgets/map_search_widget.dart';
import 'package:flutter/material.dart';
import 'package:doctory/features/map_home/cubit/map_home_cubit.dart';
import 'package:doctory/features/map_home/cubit/map_home_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MapSearchSection extends StatefulWidget {
  const MapSearchSection({super.key});

  @override
  State<MapSearchSection> createState() => _MapSearchSectionState();
}

class _MapSearchSectionState extends State<MapSearchSection> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MapHomeCubit, MapHomeStates>(
      listener: (context, state) {
        if (state is MapHomeLoadedState && state.query != _searchController.text) {
          _searchController.text = state.query ?? '';
        }
      },
      builder: (context, state) {
        return MapSearchWidget(
          searchBar: MapSearchBarWidget(
            controller: _searchController,
            onSubmitted: (value) {
              context.read<MapHomeCubit>().searchClinics(searchText: value);
            },
            onFilterTap: () {
              if (state is MapHomeLoadedState) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => BlocProvider.value(
                    value: context.read<MapHomeCubit>(),
                    child: MapFilterBottomSheet(
                      initialState: state,
                    ),
                  ),
                );
              }
            },
          ),
          filterChips: Row(
            children: [
              MapFilterChipWidget(
                label: 'All',
                isSelected: state is MapHomeLoadedState && (state.query == null || state.query!.isEmpty),
                onTap: () {
                  context.read<MapHomeCubit>().searchClinics();
                },
              ),
              MapFilterChipWidget(
                label: 'Dental',
                isSelected: state is MapHomeLoadedState && state.query == 'Dental',
                onTap: () {
                  context.read<MapHomeCubit>().searchClinics(searchText: 'Dental');
                },
              ),
              MapFilterChipWidget(
                label: 'Cardiology',
                isSelected: state is MapHomeLoadedState && state.query == 'Cardiology',
                onTap: () {
                  context.read<MapHomeCubit>().searchClinics(searchText: 'Cardiology');
                },
              ),
              MapFilterChipWidget(
                label: 'Eye Care',
                isSelected: state is MapHomeLoadedState && state.query == 'Eye Care',
                onTap: () {
                  context.read<MapHomeCubit>().searchClinics(searchText: 'Eye Care');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

