import 'package:flutter/material.dart';
import '../sections/admin_ads_body_section.dart';

class AdminAdsView extends StatelessWidget {
  const AdminAdsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: AdminAdsBodySection());
  }
}
