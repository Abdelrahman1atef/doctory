import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/features/ads/presentation/sections/ads_section.dart';
import 'package:doctory/features/home/cubit/home_cubit.dart';
import 'package:doctory/features/home/cubit/home_states.dart';
import 'package:doctory/features/home/presentation/sections/home_featured_section.dart';
import 'package:doctory/features/home/presentation/sections/home_header_section.dart';
import 'package:doctory/features/home/presentation/sections/home_search_section.dart';
import 'package:doctory/features/home/presentation/sections/home_specialties_section.dart';
import 'package:doctory/features/home/presentation/widgets/home_error_widget.dart';
import 'package:doctory/features/home/presentation/widgets/section_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/extensions.dart';

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
            current is HomeInitialState || current is HomeSuccessState || current is HomeErrorState,
        builder: (context, state) {
          if (state is HomeErrorState) {
            return HomeErrorWidget(message: state.message);
          }

          final HomeSuccessState? successState = state is HomeSuccessState ? state : null;
          final specialties = successState?.specialties ?? const <SpecialtyModel>[];
          final hasFeatured =
              successState != null &&
              (successState.recommendedDoctors.isNotEmpty ||
                  successState.featuredClinics.isNotEmpty);

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              mainAxisAlignment: hasFeatured ? MainAxisAlignment.start : MainAxisAlignment.center,
              children: [
                const HomeHeaderSection(),
                if (!hasFeatured) ...{250.ph} else ...{100.ph},
                if (successState?.ads.isNotEmpty ?? false) ...[
                  AdsSection(ads: successState!.ads),
                  const SizedBox(height: 24),
                ],
                const HomeSearchSection(),
                const SizedBox(height: 24),
                HomeSpecialtiesSection(specialties: specialties),
                if (hasFeatured) ...[
                  const SizedBox(height: 16),
                  SectionContainerWidget(
                    child: HomeFeaturedSection(
                      doctors: successState.recommendedDoctors,
                      clinics: successState.featuredClinics,
                    ),
                  ),
                ],
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}
