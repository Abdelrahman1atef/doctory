import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/specializations/cubit/specializations_cubit.dart';
import 'package:doctory/features/specializations/cubit/specializations_states.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/models/specialty_model.dart';

class SpecializationsView extends StatefulWidget {
  const SpecializationsView({super.key});

  @override
  State<SpecializationsView> createState() => _SpecializationsViewState();
}

class _SpecializationsViewState extends State<SpecializationsView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<SpecializationsCubit>().getSpecializations();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<SpecializationsCubit>().getSpecializations();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('specialties'.tr(), style: AppStyles.s20SemiBold.withColor(AppColors.textPrimary),),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        ),
      ),
      body: BlocBuilder<SpecializationsCubit, SpecializationsStates>(
        builder: (context, state) {
          if (state is SpecializationsLoadingState && state.isFirstFetch) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SpecializationsErrorState && state.message.isNotEmpty) {
            return Center(child: Text(state.message));
          }

          final List<SpecialtyModel> items = (state is SpecializationsSuccessState)
              ? state.items
              : (state is SpecializationsLoadingState ? state.oldItems : []);

          if (items.isEmpty) {
            return Center(child: Text('no_data_available'.tr()));
          }

          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: items.length +
                ((state is SpecializationsLoadingState && !state.isFirstFetch)
                    ? 1
                    : 0),
            itemBuilder: (context, index) {
              if (index < items.length) {
                final SpecialtyModel specialty = items[index];
                return _SpecialtyItemWidget(specialty: specialty);
              } else {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}

class _SpecialtyItemWidget extends StatelessWidget {
  final SpecialtyModel specialty;

  const _SpecialtyItemWidget({required this.specialty});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.stitchSurfaceLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          padding: const EdgeInsetsDirectional.all(5),
          decoration: BoxDecoration(
            color: AppColors.stitchPrimaryContainer.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: CachedNetworkImage(imageUrl: specialty.iconUrl??"",errorWidget: (context, url, error) => const Icon(Icons.medical_services_outlined),),
        ),
        title: Text(
         (context.locale.languageCode=="ar"?specialty.nameAr: specialty.name)??"",
          style: AppStyles.s16Bold.withColor(AppColors.stitchPrimaryContainer),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColors.stitchSecondary,
        ),
        onTap: () {
          context.go(AppRoutes.mapHome, extra: (context.locale.languageCode=="ar"?specialty.nameAr: specialty.name));
        },
      ),
    );
  }
}
