import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/map_home/presentation/widgets/map_clinic_card_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class NearbyClinicsSheetWidget extends StatefulWidget {
  final List<ClinicModel> clinics;
  final String? selectedClinicId;
  final ScrollController scrollController;
  final Function(ClinicModel) onClinicTap;
  final Function(ClinicModel)? onNavPressed;
  final VoidCallback? onDeselect;
  final bool hasMore;
  final bool isLoadingMore;
  final VoidCallback? onLoadMore;

  const NearbyClinicsSheetWidget({
    super.key,
    required this.clinics,
    required this.selectedClinicId,
    required this.scrollController,
    required this.onClinicTap,
    this.onNavPressed,
    this.onDeselect,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.onLoadMore,
  });

  @override
  State<NearbyClinicsSheetWidget> createState() =>
      _NearbyClinicsSheetWidgetState();
}

class _NearbyClinicsSheetWidgetState extends State<NearbyClinicsSheetWidget> {
  List<ClinicModel> get _sortedClinics {
    if (widget.selectedClinicId == null) return widget.clinics;
    final selected = widget.clinics.where(
      (c) => c.id == widget.selectedClinicId,
    );
    final rest = widget.clinics.where(
      (c) => c.id != widget.selectedClinicId,
    );
    return [...selected, ...rest];
  }

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(NearbyClinicsSheetWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedClinicId != null &&
        widget.selectedClinicId != oldWidget.selectedClinicId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.scrollController.hasClients) {
          widget.scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
    if (widget.scrollController != oldWidget.scrollController) {
      oldWidget.scrollController.removeListener(_onScroll);
      widget.scrollController.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (!widget.hasMore || widget.isLoadingMore || widget.onLoadMore == null) {
      return;
    }
    final controller = widget.scrollController;
    if (!controller.hasClients) return;
    final maxScroll = controller.position.maxScrollExtent;
    final currentScroll = controller.position.pixels;
    if (currentScroll >= maxScroll - 200) {
      widget.onLoadMore!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final clinics = _sortedClinics;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.stitchSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 16),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.stitchSurfaceLow,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'nearby_clinics'.tr(),
                  style: AppStyles.s18Bold.withColor(
                    AppColors.stitchPrimaryContainer,
                  ),
                ),
                const Spacer(),
                if (widget.selectedClinicId != null)
                  GestureDetector(
                    onTap: widget.onDeselect,
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.stitchSurfaceLow,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        size: 16,
                        color: AppColors.stitchSecondary,
                      ),
                    ),
                  ),
                Text(
                  '${clinics.length} ${'results'.tr()}',
                  style: AppStyles.s14Medium.withColor(
                    AppColors.stitchSecondary,
                  ),
                ),
              ],
            ),
          ),
          16.ph,
          Expanded(
            child: ListView.builder(
              controller: widget.scrollController,
              padding: EdgeInsets.fromLTRB(
                16, 8, 16, MediaQuery.of(context).padding.bottom + 8,
              ),
              itemCount: clinics.length + (widget.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == clinics.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  );
                }
                final clinic = clinics[index];
                final isSelected = clinic.id == widget.selectedClinicId;

                return MapClinicCardWidget(
                  clinic: clinic,
                  isSelected: isSelected,
                  onTap: () => widget.onClinicTap(clinic),
                  onNavPressed: widget.onNavPressed != null
                      ? () => widget.onNavPressed!(clinic)
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
