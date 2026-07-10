import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import '../../../../core/common/functions/location_helper.dart';
import '../../../../core/common/widgets/inputs/day_hours_widget.dart';
import '../../../../core/common/widgets/map/location_picker_bottom_sheet.dart';
import '../../../../core/router/router_names.dart';
import '../../../../core/services/alerts.dart';
import '../../../../core/session/user_session.dart';
import '../../cubit/auth_cubit.dart';
import '../../cubit/auth_states.dart';
import '../../data/model/clinic_setup_request.dart';
import '../widgets/clinic_complete_profile_widget.dart';

class ClinicCompleteProfileSection extends StatefulWidget {
  const ClinicCompleteProfileSection({super.key});

  @override
  State<ClinicCompleteProfileSection> createState() => _ClinicCompleteProfileSectionState();
}

class _ClinicCompleteProfileSectionState extends State<ClinicCompleteProfileSection> {
  final _formKey = GlobalKey<FormState>();
  final _clinicNameController = TextEditingController();
  File? _clinicImage;
  double? _clinicLat;
  double? _clinicLng;
  String _clinicAddress = '';

  static const _dayNames = [
    'Sunday', 'Monday', 'Tuesday', 'Wednesday',
    'Thursday', 'Friday', 'Saturday',
  ];

  late List<DayHours> _dayHours;

  @override
  void initState() {
    super.initState();
    _dayHours = List.generate(7, (i) {
      return DayHours(
        dayIndex: i,
        dayName: _dayNames[i],
        from: const TimeOfDay(hour: 9, minute: 0),
        to: const TimeOfDay(hour: 17, minute: 0),
        isClosed: false,
      );
    });
  }

  @override
  void dispose() {
    _clinicNameController.dispose();
    super.dispose();
  }

  String _getPhone() {
    return UserSession.userModel?['phoneNumber'] ?? '';
  }

  Future<void> _pickClinicImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _clinicImage = File(result.files.single.path!);
      });
    }
  }

  Future<void> _pickLocation() async {
    await LocationPickerBottomSheet.show(
      context,
      onConfirm: (lat, lng, address) {
        setState(() {
          _clinicLat = lat;
          _clinicLng = lng;
          _clinicAddress = address;
        });
      },
    );
  }

  Future<void> _pickTime(int dayIndex, bool isFrom) async {
    final current = isFrom ? _dayHours[dayIndex].from : _dayHours[dayIndex].to;
    final picked = await showTimePicker(context: context, initialTime: current);
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _dayHours[dayIndex] = _dayHours[dayIndex].copyWith(from: picked);
        } else {
          _dayHours[dayIndex] = _dayHours[dayIndex].copyWith(to: picked);
        }
      });
    }
  }

  void _toggleClosed(int dayIndex) {
    setState(() {
      _dayHours[dayIndex] = _dayHours[dayIndex].copyWith(
        isClosed: !_dayHours[dayIndex].isClosed,
      );
    });
  }

  Map<String, String> _buildOperatingHours() {
    final map = <String, String>{};
    for (final d in _dayHours) {
      if (d.isClosed) {
        map[d.dayName] = 'closed';
      } else {
        final from = '${d.from.hour.toString().padLeft(2, '0')}:${d.from.minute.toString().padLeft(2, '0')}';
        final to = '${d.to.hour.toString().padLeft(2, '0')}:${d.to.minute.toString().padLeft(2, '0')}';
        map[d.dayName] = '$from-$to';
      }
    }
    return map;
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      final cubit = context.read<AuthCubit>();
      cubit.registerClinic(
        ClinicSetupRequest(
          name: _clinicNameController.text.trim(),
          phone: _getPhone(),
          lat: _clinicLat ?? 0.0,
          lng: _clinicLng ?? 0.0,
          address: _clinicAddress,
          operatingHours: _buildOperatingHours(),
        ),
      );
    }
  }

  void _goHome() {
    LocationHelper.isPermissionGranted().then((isGranted) {
      if (isGranted && context.mounted) {
        context.go(AppRoutes.home);
      } else if (context.mounted) {
        context.push(AppRoutes.locationPermission);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is AuthLoadingState) {
          SmartDialog.showLoading();
        } else {
          SmartDialog.dismiss();
        }

        if (state is ClinicRegisteredState) {
          _goHome();
        } else if (state is AuthErrorState) {
          Alerts.showSnackBar(
            context,
            message: state.message,
            state: SnackState.failed,
          );
        }
      },
      child: ClinicCompleteProfileWidget(
        formKey: _formKey,
        clinicNameController: _clinicNameController,
        clinicAddress: _clinicAddress,
        clinicLat: _clinicLat,
        clinicImageFileName: _clinicImage?.path.split('\\').last ?? _clinicImage?.path.split('/').last,
        onPickClinicImage: _pickClinicImage,
        onPickLocation: _pickLocation,
        dayHours: _dayHours,
        onPickTime: _pickTime,
        onToggleClosed: _toggleClosed,
        onSubmit: _onSubmit,
      ),
    );
  }
}
