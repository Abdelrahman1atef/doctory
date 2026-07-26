import 'package:doctory/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctory/features/map_home/cubit/map_home_cubit.dart';
import 'package:doctory/features/map_home/cubit/map_home_states.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:doctory/core/services/remote_config_service.dart';

import '../widgets/map_location_fab_widget.dart';

class MapFabsSection extends StatelessWidget {
  final ValueNotifier<double> sheetSizeNotifier;
  final VoidCallback onMyLocationPressed;

  const MapFabsSection({
    super.key,
    required this.sheetSizeNotifier,
    required this.onMyLocationPressed,
  });

  Future<void> _openGoogleMaps(double lat, double lng) async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: sheetSizeNotifier,
      builder: (context, size, child) {
        final bottomInset = MediaQuery.of(context).padding.bottom;
        final bottomPadding = MediaQuery.of(context).size.height * size + 16 + bottomInset;

        return Positioned(
          bottom: bottomPadding,
          right: 16,
          child: BlocBuilder<MapHomeCubit, MapHomeStates>(
            buildWhen: (prev, curr) {
              if (prev is MapHomeLoadedState && curr is MapHomeLoadedState) {
                return prev.selectedClinic?.id != curr.selectedClinic?.id;
              }
              return prev.runtimeType != curr.runtimeType;
            },
            builder: (context, state) {
              final selectedClinic = (state is MapHomeLoadedState)
                  ? state.selectedClinic
                  : null;

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (RemoteConfigService.showMapDirectionsFab &&
                      selectedClinic != null &&
                      selectedClinic.lat != null &&
                      selectedClinic.lng != null) ...[
                    FloatingActionButton(
                      heroTag: 'map_directions_fab',
                      onPressed: () => _openGoogleMaps(
                        selectedClinic.lat!,
                        selectedClinic.lng!,
                      ),
                      backgroundColor: AppColors.stitchPrimary,
                      child: const Icon(Icons.directions, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                  ],
                  MapLocationFabWidget(onPressed: onMyLocationPressed),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
