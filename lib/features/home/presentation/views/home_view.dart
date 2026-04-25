import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/features/home/cubit/home_cubit.dart';
import 'package:doctory/features/home/cubit/home_states.dart';
import 'package:doctory/features/home/presentation/sections/home_featured_section.dart';
import 'package:doctory/features/home/presentation/sections/home_header_section.dart';
import 'package:doctory/features/home/presentation/sections/home_search_section.dart';
import 'package:doctory/features/home/presentation/sections/home_specialties_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.stitchSurface,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<HomeCubit>().getHomeData();
          },
          child: BlocBuilder<HomeCubit, HomeStates>(
            buildWhen: (previous, current) =>
                current is HomeSuccessState ||
                current is HomeLoadingState ||
                current is HomeErrorState,
            builder: (context, state) {
              if (state is HomeLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.stitchPrimary,
                  ),
                );
              }

              if (state is HomeErrorState) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: AppColors.errorColor),
                  ),
                );
              }

              if (state is HomeSuccessState) {
                return ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  children: [
                    const HomeHeaderSection(),
                    const SizedBox(height: 24),
                    const HomeSearchSection(),
                    const SizedBox(height: 24),
                    _buildSectionContainer(
                      child: HomeSpecialtiesSection(
                        specialties: state.specialties,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSectionContainer(
                      child: HomeFeaturedSection(
                        doctors: state.recommendedDoctors,
                        clinics: state.featuredClinics,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSectionContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: AppColors.cardBorder.withValues(alpha: 0.3)),
      ),
      child: child,
    );
  }
}
