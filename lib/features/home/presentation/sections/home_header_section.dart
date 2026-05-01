import 'package:doctory/features/home/presentation/widgets/home_header_widget.dart';
import 'package:flutter/material.dart';

class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Get actual user name from session or cubit
    const userName = 'أحمد';
    return const HomeHeaderWidget(userName: userName);
  }
}
