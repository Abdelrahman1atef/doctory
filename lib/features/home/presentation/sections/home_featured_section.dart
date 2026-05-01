import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/features/home/presentation/widgets/home_featured_list_widget.dart';
import 'package:flutter/material.dart';

class HomeFeaturedSection extends StatelessWidget {
  final List<DoctorModel> doctors;
  final List<ClinicModel> clinics;

  const HomeFeaturedSection({
    super.key,
    required this.doctors,
    required this.clinics,
  });

  @override
  Widget build(BuildContext context) {
    if (doctors.isEmpty && clinics.isEmpty) return const SizedBox.shrink();

    return HomeFeaturedListWidget(
      doctors: doctors,
      clinics: clinics,
      onSeeAllClinics: () {
        // TODO: Navigate to all clinics
      },
      onSeeAllDoctors: () {
        // TODO: Navigate to all doctors
      },
    );
  }
}
