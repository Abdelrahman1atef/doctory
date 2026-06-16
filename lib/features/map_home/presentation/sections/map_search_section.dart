import 'package:doctory/features/map_home/presentation/widgets/map_filter_bottom_sheet.dart';
import 'package:doctory/features/map_home/presentation/widgets/map_filter_chip_widget.dart';
import 'package:doctory/features/map_home/presentation/widgets/map_search_bar_widget.dart';
import 'package:doctory/features/map_home/presentation/widgets/map_search_widget.dart';
import 'package:easy_localization/easy_localization.dart';
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
      listenWhen: (prev, curr) {
        if (prev is MapHomeLoadedState && curr is MapHomeLoadedState) {
          return prev.query != curr.query;
        }
        return curr is MapHomeLoadedState;
      },
      buildWhen: (prev, curr) {
        if (prev.runtimeType != curr.runtimeType) return true;
        if (prev is MapHomeLoadedState && curr is MapHomeLoadedState) {
          return prev.query != curr.query;
        }
        return true;
      },
      listener: (context, state) {
        if (state is MapHomeLoadedState &&
            state.query != _searchController.text) {
          _searchController.text = state.query ?? '';
        }
      },
      builder: (context, state) {
        final specializations = (state is MapHomeLoadedState) ? state.specializations : [];
        final selectedSpecId = (state is MapHomeLoadedState) ? state.specializationId : null;
        final hasQuery = state is MapHomeLoadedState && state.query != null && state.query!.isNotEmpty;

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
                    child: MapFilterBottomSheet(initialState: state),
                  ),
                );
              }
            },
          ),
          filterChips: Row(
            children: [
              MapFilterChipWidget(
                label: 'all'.tr(),
                isSelected: selectedSpecId == null && !hasQuery,
                onTap: () {
                  _searchController.clear();
                  context.read<MapHomeCubit>().searchClinics(
                    searchText: '',
                    clearSpecialization: true,
                  );
                },
              ),
              ...specializations.map((spec) {
                return MapFilterChipWidget(
                  label: spec.name,
                  isSelected: selectedSpecId == spec.id,
                  onTap: () {
                    context.read<MapHomeCubit>().searchClinics(
                      specializationId: spec.id,
                    );
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
