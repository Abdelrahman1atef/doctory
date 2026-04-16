import 'package:doctory/core/common/widgets/buttons/custom_button.dart';
import 'package:doctory/core/common/widgets/map/map_picker_widget.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// A reusable bottom sheet that wraps [MapPickerWidget].
///
/// Shows a header, the map, a confirm button, and an optional skip link.
/// Use [LocationPickerBottomSheet.show] as a convenience static method.
///
/// Example:
/// ```dart
/// LocationPickerBottomSheet.show(
///   context,
///   onConfirm: (lat, lng, address) { ... },
///   onSkip: () { ... },
/// );
/// ```
class LocationPickerBottomSheet extends StatefulWidget {
  /// Callback when the user confirms their address.
  final void Function(double lat, double lng, String address) onConfirm;

  /// Optional callback to skip address picking.
  final VoidCallback? onSkip;

  /// Sheet title.
  final String title;

  /// Subtitle shown below the title.
  final String subtitle;

  /// Confirm button label.
  final String confirmLabel;

  /// Skip link label. Hidden when [onSkip] is null.
  final String skipLabel;

  /// Optional list of markers to show on the map.
  final Set<Marker>? markers;

  const LocationPickerBottomSheet({
    super.key,
    required this.onConfirm,
    this.onSkip,
    this.title = 'تحديد العنوان',
    this.subtitle = 'قم بتحديد اللوكيشن الخاص بك على الخريطة',
    this.confirmLabel = 'تأكيد العنوان',
    this.skipLabel = 'التحديد لاحقاً',
    this.markers,
  });

  /// Convenience method – shows the sheet as a modal bottom sheet.
  static Future<T?> show<T>(
    BuildContext context, {
    required void Function(double lat, double lng, String address) onConfirm,
    VoidCallback? onSkip,
    String title = 'تحديد العنوان',
    String subtitle = 'قم بتحديد اللوكيشن الخاص بك على الخريطة',
    String confirmLabel = 'تأكيد العنوان',
    String skipLabel = 'التحديد لاحقاً',
    Set<Marker>? markers,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LocationPickerBottomSheet(
        onConfirm: onConfirm,
        onSkip: onSkip,
        title: title,
        subtitle: subtitle,
        confirmLabel: confirmLabel,
        skipLabel: skipLabel,
        markers: markers,
      ),
    );
  }

  @override
  State<LocationPickerBottomSheet> createState() =>
      _LocationPickerBottomSheetState();
}

class _LocationPickerBottomSheetState extends State<LocationPickerBottomSheet> {
  double? _lat;
  double? _lng;
  String _address = '';

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      maxChildSize: 0.95,
      minChildSize: 0.6,
      builder: (_, __) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // ── Drag handle ──────────────────────────────────────────────────
              8.ph,
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              16.ph,

              // ── Header ───────────────────────────────────────────────────────
              const Icon(
                Icons.location_on_sharp,
                size: 48,
                color: AppColors.grey5,
              ),
              12.ph,
              Text(
                widget.title,
                style: AppStyles.s16Bold.withColor(AppColors.primaryNavy),
              ),
              12.ph,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  widget.subtitle,
                  style: AppStyles.s14Medium.withColor(AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
              ),
              16.ph,

              // ── Map (pure widget from core) ───────────────────────────────────
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: MapPickerWidget(
                    onLocationPicked: (lat, lng, address) {
                      _lat = lat;
                      _lng = lng;
                      _address = address;
                    },
                    markers: widget.markers,
                  ),
                ),
              ),
              20.ph,

              // ── Confirm button ────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomButton(
                  text: widget.confirmLabel,
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onConfirm(_lat ?? 0, _lng ?? 0, _address);
                  },
                  backgroundColor: AppColors.primaryTeal,
                  textColor: AppColors.white,
                  borderRadius: BorderRadius.circular(30),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: AppStyles.s16Bold.copyWith(color: AppColors.white),
                ),
              ),
              18.ph,

              // ── Skip link ─────────────────────────────────────────────────────
              if (widget.onSkip != null)
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    widget.onSkip!();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.skipLabel,
                          style: AppStyles.s14Bold.withColor(
                            AppColors.textSecondary,
                          ),
                        ),
                        4.pw,
                        const Icon(
                          Icons.arrow_forward,
                          color: AppColors.textSecondary,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                )
              else
                30.ph,
            ],
          ),
        );
      },
    );
  }
}
