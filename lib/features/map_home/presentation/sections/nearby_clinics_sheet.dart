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
    return BlocListener<MapHomeCubit, MapHomeStates>(
      listenWhen: (previous, current) {
        if (previous is MapHomeLoadedState && current is MapHomeLoadedState) {
          return previous.selectedClinic?.id != current.selectedClinic?.id;
        }
        return current is MapHomeLoadedState;
      },
      listener: (context, state) {
        if (state is MapHomeLoadedState && state.selectedClinic != null) {
          // If sheet is expanded, collapse it to initial size to show map
          if (widget.sheetController.isAttached &&
              widget.sheetController.size > 0.35) {
            widget.sheetController.animateTo(
              0.35,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        }
      },
      child: DraggableScrollableSheet(
        controller: widget.sheetController,
        initialChildSize: 0.35,
        minChildSize: 0.15,
        maxChildSize: 0.85,
        builder: (context, scrollController) {
          return BlocBuilder<MapHomeCubit, MapHomeStates>(
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
                    context.push(AppRoutes.clinicDetails, extra: clinic);
                  } else {
                    context.read<MapHomeCubit>().selectClinic(clinic);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
