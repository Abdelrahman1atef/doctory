import 'package:doctory/features/home/cubit/home_cubit.dart';
import 'package:doctory/features/home/cubit/home_states.dart';
import 'package:doctory/features/home/presentation/sections/home_featured_section.dart';
import 'package:doctory/features/home/presentation/sections/home_header_section.dart';
import 'package:doctory/features/home/presentation/sections/home_search_section.dart';
import 'package:doctory/features/home/presentation/sections/home_specialties_section.dart';
import 'package:doctory/features/home/presentation/widgets/home_loading_widget.dart';
import 'package:doctory/features/home/presentation/widgets/home_error_widget.dart';
import 'package:doctory/features/home/presentation/widgets/section_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Section that manages the Home BlocBuilder state and delegates
/// rendering to the appropriate widgets/sections.
class HomeContentSection extends StatelessWidget {
  const HomeContentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
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
            return const HomeLoadingWidget();
          }

          if (state is HomeErrorState) {
            return HomeErrorWidget(message: state.message);
          }

          if (state is HomeSuccessState) {
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              children: [
                const HomeHeaderSection(),
                const SizedBox(height: 24),
                const HomeSearchSection(),
                const SizedBox(height: 24),
                SectionContainerWidget(
                  child: HomeSpecialtiesSection(specialties: state.specialties),
                ),
                const SizedBox(height: 16),
                SectionContainerWidget(
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
    );
  }
}
