import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/features/map_home/presentation/widgets/nearby_clinics_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:doctory/features/map_home/cubit/map_home_cubit.dart';
import 'package:doctory/features/map_home/cubit/map_home_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class NearbyClinicsSheet extends StatefulWidget {
  final List<ClinicModel> clinics;
  final DraggableScrollableController sheetController;

  const NearbyClinicsSheet({
    super.key,
    required this.clinics,
    required this.sheetController,
  });

  @override
  State<NearbyClinicsSheet> createState() => _NearbyClinicsSheetState();
}

class _NearbyClinicsSheetState extends State<NearbyClinicsSheet> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: widget.sheetController,
      initialChildSize: 0.35,
      minChildSize: 0.15,
      maxChildSize: 0.85,
      builder: (context, scrollController) {
        return BlocBuilder<MapHomeCubit, MapHomeStates>(
          buildWhen: (prev, curr) {
            if (prev is MapHomeLoadedState && curr is MapHomeLoadedState) {
              return prev.selectedClinic?.id != curr.selectedClinic?.id;
            }
            return prev.runtimeType != curr.runtimeType;
          },
          builder: (context, state) {
            final selectedClinicId = (state is MapHomeLoadedState)
                ? state.selectedClinic?.id
                : null;

            return NearbyClinicsSheetWidget(
              clinics: widget.clinics,
              selectedClinicId: selectedClinicId,
              scrollController: scrollController,
              onClinicTap: (clinic) {
                if (clinic.id == selectedClinicId) {
                  if (clinic.isRegistered) {
                    context.push(AppRoutes.clinicDetails, extra: clinic);
                  }
                } else {
                  context.read<MapHomeCubit>().selectClinic(clinic);
                }
              },
              onNavPressed: (clinic) {
                context.read<MapHomeCubit>().selectClinic(clinic);
                context.read<MapHomeCubit>().startNavigation();
              },
            );
          },
        );
      },
    );
  }
}
