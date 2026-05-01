import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/features/home/presentation/widgets/home_specialties_list_widget.dart';
import 'package:flutter/material.dart';

class HomeSpecialtiesSection extends StatelessWidget {
  final List<SpecialtyModel> specialties;

  const HomeSpecialtiesSection({super.key, required this.specialties});

  @override
  Widget build(BuildContext context) {
    if (specialties.isEmpty) return const SizedBox.shrink();

    return HomeSpecialtiesListWidget(
      specialties: specialties,
      onSeeAll: () {
        // TODO: Navigate to all specialties
      },
    );
  }
}
