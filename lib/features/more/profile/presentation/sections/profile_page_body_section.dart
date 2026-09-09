import 'package:doctory/features/more/profile/presentation/sections/profile_app_bar_section.dart';
import 'package:doctory/features/more/profile/presentation/sections/profile_body_section.dart';
import 'package:flutter/material.dart';

class ProfilePageBodySection extends StatelessWidget {
  const ProfilePageBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ProfileAppBarSection(),
        Expanded(child: ProfileBodySection()),
      ],
    );
  }
}
