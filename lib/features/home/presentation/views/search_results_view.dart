import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/features/home/cubit/home_cubit.dart';
import 'package:doctory/features/home/cubit/home_states.dart';
import 'package:doctory/features/home/presentation/widgets/featured_card_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchResultsView extends StatelessWidget {
  const SearchResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.stitchSurface,
      appBar: AppBar(
        backgroundColor: AppColors.stitchSurface,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 24), // Add padding to balance the back button
          child: Hero(
            tag: 'search_bar_hero',
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  readOnly: true, // It's just for display/transition or we can let them search again
                  decoration: InputDecoration(
                    hintText: context.tr('search_hint'),
                    hintStyle: AppStyles.s14Medium.copyWith(color: AppColors.textHint),
                    prefixIcon: const Icon(Icons.search, color: AppColors.stitchPrimary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: AppColors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 0, // Adjusted for height 48
                    ),
                  ),
                  onTap: () {
                    // Navigate back to home search or focus to search again
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<HomeCubit, HomeStates>(
        buildWhen: (previous, current) =>
            current is SearchSuccessState ||
            current is SearchLoadingState ||
            current is SearchErrorState,
        builder: (context, state) {
          if (state is SearchLoadingState) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.stitchPrimary),
            );
          }

          if (state is SearchErrorState) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: AppColors.errorColor),
              ),
            );
          }

          if (state is SearchSuccessState) {
            if (state.doctors.isEmpty && state.clinics.isEmpty) {
              return Center(child: Text(context.tr('no_results_found')));
            }

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              children: [
                if (state.doctors.isNotEmpty) ...[
                  Text(
                    context.tr('doctors_near_you'),
                    style: AppStyles.s16Bold.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...state.doctors.map(
                    (doctor) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: DoctorCardWidget(doctor: doctor),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                if (state.clinics.isNotEmpty) ...[
                  Text(
                    context.tr('clinics_near_you'),
                    style: AppStyles.s16Bold.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...state.clinics.map(
                    (clinic) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ClinicCardWidget(clinic: clinic),
                    ),
                  ),
                ],
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
