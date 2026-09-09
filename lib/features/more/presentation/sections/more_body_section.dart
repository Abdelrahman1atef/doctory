import 'package:doctory/features/more/presentation/sections/more_app_bar_section.dart';
import 'package:doctory/features/more/presentation/sections/more_options_section.dart';
import 'package:flutter/material.dart';

class MoreBodySection extends StatelessWidget {
  const MoreBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        MoreAppBarSection(),
        Expanded(child: MoreOptionsSection()),
      ],
    );
  }
}
