import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/features/intro/cubit/intro_cubit.dart';
import 'package:doctory/features/intro/cubit/intro_states.dart';
import 'package:doctory/features/intro/presentation/sections/intro_slider_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class IntroView extends StatelessWidget {
  const IntroView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<IntroCubit, IntroStates>(
      listener: (context, state) {
        if (state is NavigateToLoginState) {
          context.go(AppRoutes.welcome);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: const IntroSliderSection(),
      ),
    );
  }
}
