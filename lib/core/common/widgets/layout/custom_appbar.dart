import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> actions;
  final bool canNavigateUp;
  final Color? backgroundColor;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions = const [],
    this.canNavigateUp = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? AppColors.white,
      title: Text(
        title,
          style: AppStyles.s20SemiBold.withColor(AppColors.textPrimary),
      ),
      centerTitle: true,
      forceMaterialTransparency: true,
      leading: canNavigateUp
          ? GestureDetector(
              onTap: () {
                context.pop();
              },
              child: const Icon(Icons.arrow_back_outlined),
            )
          : 0.pw,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
