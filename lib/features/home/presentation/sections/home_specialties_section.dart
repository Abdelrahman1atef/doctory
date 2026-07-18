import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/common/functions/location_helper.dart';
import 'package:doctory/features/home/presentation/widgets/home_specialties_list_widget.dart';
import 'package:doctory/features/home/presentation/widgets/home_specialties_shimmer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeSpecialtiesSection extends StatelessWidget {
  final List<SpecialtyModel> specialties;

  const HomeSpecialtiesSection({super.key, required this.specialties});

  @override
  Widget build(BuildContext context) {
    if (specialties.isEmpty) return const HomeSpecialtiesShimmer();

    return HomeSpecialtiesListWidget(
      specialties: specialties,
      onSeeAll: () {
        context.push(AppRoutes.specializations);
      },
      onSpecialtyTap: (specialty) async {
        await LocationHelper.checkAndRequestPermission();
        if (context.mounted) {
          context.go(AppRoutes.mapHome, extra: (context.locale.languageCode=="ar"?specialty.nameAr: specialty.name));
        }
      },
    );
  }
}
