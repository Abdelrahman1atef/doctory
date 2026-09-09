import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import '../../../../core/common/functions/location_helper.dart';
import '../../../../core/common/models/role.dart';
import '../../../../core/common/widgets/inputs/day_hours_widget.dart';
import '../../../../core/common/widgets/map/location_picker_bottom_sheet.dart';
import '../../../../core/router/router_names.dart';
import '../../../../core/services/alerts.dart';
import '../../../../core/session/user_session.dart';
import '../../cubit/auth_cubit.dart';
import '../../cubit/auth_states.dart';
import '../../data/model/clinic_setup_request.dart';
import '../widgets/profile_form_widget.dart';

class ProfileFormSection extends StatefulWidget {
  const ProfileFormSection({super.key});

  @override
  State<ProfileFormSection> createState() => _ProfileFormSectionState();
}

class _ProfileFormSectionState extends State<ProfileFormSection> {
  final _formKey = GlobalKey<FormState>();
  late String _selectedGender;
  final _clinicNameController = TextEditingController();

  double? _clinicLat;
  double? _clinicLng;
  String _clinicAddress = '';
  File? _clinicImage;

  static const _dayNames = [
    'Sunday', 'Monday', 'Tuesday', 'Wednesday',
    'Thursday', 'Friday', 'Saturday',
  ];

  late List<DayHours> _dayHours;

  @override
  void initState() {
    super.initState();
    _selectedGender = 'male';
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

  bool get _isOwnClinic =>
      UserSession.currentDoctorType == DoctorEmploymentType.ownClinic;

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
    if (_isOwnClinic) {
      final cubit = context.read<AuthCubit>();
      cubit.registerClinic(
        ClinicSetupRequest(
          name: _clinicNameController.text.trim(),
          phone: UserSession.userModel?['phoneNumber'] ?? '',
          lat: _clinicLat ?? 0.0,
          lng: _clinicLng ?? 0.0,
          address: _clinicAddress,
          operatingHours: _buildOperatingHours(),
        ),
      );
    } else {
      _goHome();
    }
  }

  Future<void> _goHome() async {
    final bool isGranted = await LocationHelper.isPermissionGranted();
    if (!mounted) return;
    if (isGranted) {
      context.go(AppRoutes.home);
    } else {
      context.push(AppRoutes.locationPermission);
    }
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
      child: ProfileFormWidget(
        formKey: _formKey,
        selectedGender: _selectedGender,
        onGenderChanged: (gender) => setState(() => _selectedGender = gender),
        onSubmit: _onSubmit,
        isOwnClinic: _isOwnClinic,
        clinicNameController: _clinicNameController,
        clinicAddress: _clinicAddress,
        clinicLat: _clinicLat,
        onPickLocation: _pickLocation,
        clinicImageFileName: _clinicImage?.path.split('\\').last ?? _clinicImage?.path.split('/').last,
        onPickClinicImage: _pickClinicImage,
        dayHours: _dayHours,
        onPickTime: _pickTime,
        onToggleClosed: _toggleClosed,
      ),
    );
  }
}


