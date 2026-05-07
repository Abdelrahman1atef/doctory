import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CommunityAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool canNavigateUp;

  const CommunityAppBar({
    super.key,
    required this.title,
    this.actions,
    this.canNavigateUp = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: AppStyles.s20SemiBold.withColor(AppColors.textPrimary),
      ),
      actions: actions != null ? [...actions!, 16.pw] : null,
      scrolledUnderElevation: 0,
      elevation: 0,
      centerTitle: true,
      backgroundColor: AppColors.white,
      leading: canNavigateUp
          ? GestureDetector(
              onTap: () {
                context.pop();
              },
              child: const Icon(Icons.arrow_back_outlined),
            )
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CommunitySliverAppBar extends StatelessWidget {
  final String title;
  final List<Widget>? actions;

  const CommunitySliverAppBar({
    super.key,
    required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(
        title,
        style: AppStyles.s20SemiBold.withColor(AppColors.textPrimary),
      ),
      actions: actions != null ? [...actions!, 16.pw] : null,
      backgroundColor: AppColors.white,
      floating: true,
      snap: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
    );
  }
}
