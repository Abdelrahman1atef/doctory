import 'package:doctory/features/home/cubit/home_cubit.dart';
import 'package:doctory/features/home/cubit/home_states.dart';
import 'package:doctory/features/home/presentation/widgets/home_content_widget.dart';
import 'package:doctory/features/home/presentation/widgets/states/home_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Home body. Owns the cubit interaction; all styling lives in the widgets.
class HomeBodySection extends StatelessWidget {
  const HomeBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => context.read<HomeCubit>().getHomeData(),
      child: BlocBuilder<HomeCubit, HomeStates>(
        // Search states belong to the search section, not to the body.
        buildWhen: (previous, current) =>
            current is HomeInitialState ||
            current is HomeSuccessState ||
            current is HomeErrorState,
        builder: (context, state) => switch (state) {
          HomeErrorState(:final message) => HomeErrorWidget(message: message),
          HomeSuccessState(
            :final specialties,
            :final recommendedDoctors,
            :final featuredClinics,
            :final ads,
          ) =>
            HomeContentWidget(
              specialties: specialties,
              recommendedDoctors: recommendedDoctors,
              featuredClinics: featuredClinics,
              ads: ads,
            ),
          // Search states are handled by HomeSearchSection; the body keeps
          // rendering its (empty) skeleton content for them.
          HomeInitialState() ||
          HomeLoadingState() ||
          SearchLoadingState() ||
          SearchSuccessState() ||
          SearchErrorState() =>
            const HomeContentWidget(),
        },
      ),
    );
  }
}
