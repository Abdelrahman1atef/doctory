import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/features/community/presentation/widgets/community_floating_action_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CommunityFloatingActionSection extends StatelessWidget {
  const CommunityFloatingActionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return CommunityFloatingActionWidget(
      onPressed: () {
        context.push(AppRoutes.createPost);
      },
    );
  }
}
