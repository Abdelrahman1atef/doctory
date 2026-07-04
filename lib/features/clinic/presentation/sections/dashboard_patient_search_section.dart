import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctory/core/app_strings/locale_keys.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/features/clinic/cubit/clinic_dashboard_cubit.dart';
import 'package:doctory/features/clinic/cubit/clinic_dashboard_state.dart';
import 'package:doctory/features/clinic/presentation/widgets/dashboard_empty_widget.dart';
import 'package:doctory/features/clinic/presentation/widgets/patient_search_tile_widget.dart';
import 'package:easy_localization/easy_localization.dart';

class DashboardPatientSearchSection extends StatefulWidget {
  const DashboardPatientSearchSection({super.key});

  @override
  State<DashboardPatientSearchSection> createState() =>
      _DashboardPatientSearchSectionState();
}

class _DashboardPatientSearchSectionState
    extends State<DashboardPatientSearchSection> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            controller: _searchController,
            onChanged: (query) {
              context.read<ClinicDashboardCubit>().searchPatients(query);
            },
            decoration: InputDecoration(
              hintText: LocaleKeys.search_patients_hint.tr(),
              hintStyle: AppStyles.s14Medium.withColor(AppColors.textHint),
              prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.stitchSurfaceLow,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Expanded(
          child: BlocBuilder<ClinicDashboardCubit, ClinicDashboardState>(
            builder: (context, state) {
              if (state is! ClinicDashboardLoaded) {
                return const SizedBox.shrink();
              }
              final results = state.searchResults;
              if (results.isEmpty) {
                return DashboardEmptyWidget(
                  icon: Icons.person_search,
                  message: LocaleKeys.no_patients_found.tr(),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final patient = results[index];
                  return PatientSearchTileWidget(
                    patient: patient,
                    onTap: () {},
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
