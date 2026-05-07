import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CommunityFloatingActionSection extends StatelessWidget {
  const CommunityFloatingActionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        context.push(AppRoutes.createPost).then((value) {
          // Note: Ideally, we should refresh the list if a post was created.
        });
      },
      backgroundColor: AppColors.stitchPrimary,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
