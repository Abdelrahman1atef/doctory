import 'package:doctory/core/common/functions/location_helper.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/features/home/presentation/widgets/home_search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeSearchSection extends StatefulWidget {
  const HomeSearchSection({super.key});

  @override
  State<HomeSearchSection> createState() => _HomeSearchSectionState();
}

class _HomeSearchSectionState extends State<HomeSearchSection> {
  final TextEditingController _controller = TextEditingController();

  void _onSearch() async {
    final query = _controller.text.trim();
    if (query.isNotEmpty) {
      // Ensure location permission is confirmed before navigating
      await LocationHelper.checkAndRequestPermission();

      if (mounted) {
        context.push(AppRoutes.mapHome, extra: query);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HomeSearchBarWidget(controller: _controller, onSearch: _onSearch);
  }
}
