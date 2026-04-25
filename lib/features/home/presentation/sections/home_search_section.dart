import 'package:doctory/core/common/functions/location_helper.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:easy_localization/easy_localization.dart';
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
        context.push(AppRoutes.searchResults, extra: query);
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
    return Hero(
      tag: 'search_bar_hero',
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: _controller,
            onSubmitted: (_) => _onSearch(),
            decoration: InputDecoration(
              hintText: context.tr('search_hint'),
              hintStyle: AppStyles.s14Medium.copyWith(color: AppColors.textHint),
              prefixIcon: const Icon(Icons.search, color: AppColors.stitchPrimary),
              suffixIcon: IconButton(
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.stitchPrimary,
                ),
                onPressed: _onSearch,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: AppColors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
