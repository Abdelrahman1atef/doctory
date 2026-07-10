import 'package:flutter/material.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/features/admin/presentation/layout/widgets/admin_drawer_widget.dart';

class AdminLayoutView extends StatelessWidget {
  final Widget child;

  const AdminLayoutView({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.stitchSurfaceLowest,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text('Admin Panel', style: AppStyles.s20SemiBold.withColor(AppColors.textPrimary)),
        centerTitle: true,
        forceMaterialTransparency: true,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
      ),
      drawer: const AdminDrawerWidget(),
      body: child,
    );
  }
}
