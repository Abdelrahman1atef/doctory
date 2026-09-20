import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/clinic/data/model/availability_dto.dart';
import 'package:doctory/features/clinic/presentation/widgets/availability_window_card.dart';
import 'package:flutter/material.dart';

class AvailabilityListWidget extends StatelessWidget {
  final List<AvailabilityDto> windows;
  final bool isSubmitting;
  final void Function(AvailabilityDto window) onDelete;

  const AvailabilityListWidget({
    super.key,
    required this.windows,
    required this.onDelete,
    this.isSubmitting = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Thin progress bar keeps the list readable while a write is in flight.
        SizedBox(
          height: 2,
          child: isSubmitting
              ? const LinearProgressIndicator(
                  color: AppColors.stitchPrimary,
                  backgroundColor: Colors.transparent,
                )
              : null,
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            itemCount: windows.length,
            separatorBuilder: (_, _) => 12.ph,
            itemBuilder: (context, index) => AvailabilityWindowCard(
              window: windows[index],
              onDelete: isSubmitting || !windows[index].canDelete
                  ? null
                  : () => onDelete(windows[index]),
            ),
          ),
        ),
      ],
    );
  }
}
