import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:doctory/core/common/models/specialty_model.dart';
import 'package:doctory/core/common/widgets/sheets/specialization_picker_sheet.dart';
import 'package:doctory/core/locator/service_locator.dart';
import '../../../../core/common/functions/location_helper.dart';
import '../../../../core/common/widgets/inputs/day_hours_widget.dart';
import '../../../../core/common/widgets/map/location_picker_bottom_sheet.dart';
import '../../../../core/router/router_names.dart';
import '../../../../core/services/alerts.dart';
import '../../../../core/session/user_session.dart';
import '../../../../shared/cubit/specializations_cubit.dart';
import '../../cubit/auth_cubit.dart';
import '../../cubit/auth_states.dart';
import '../../data/model/admin_clinic_setup_request.dart';
import '../../data/model/clinic_setup_request.dart';
import '../widgets/clinic_complete_profile_widget.dart';

class ClinicCompleteProfileSection extends StatefulWidget {
  final bool isSetupMode;

  const ClinicCompleteProfileSection({super.key, this.isSetupMode = false});

  @override
  State<ClinicCompleteProfileSection> createState() => _ClinicCompleteProfileSectionState();
}

class _ClinicCompleteProfileSectionState extends State<ClinicCompleteProfileSection> {
  final _formKey = GlobalKey<FormState>();
  final _clinicNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _emailController = TextEditingController();
  final _websiteController = TextEditingController();
  File? _clinicImage;
  double? _clinicLat;
  double? _clinicLng;
  String _clinicAddress = '';
  String? _selectedSpecializationId;
  List<SpecialtyModel> _specializations = [];

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

    if (widget.isSetupMode) {
      final userModel = UserSession.userModel;
      if (userModel is Map) {
        _emailController.text = userModel['email']?.toString() ?? '';
      }
      _loadSpecializations();
    }
  }

  void _loadSpecializations() {
    final cubit = sl<SharedSpecializationsCubit>();
    final state = cubit.state;
    if (state is SharedSpecializationsLoaded) {
      setState(() => _specializations = state.specializations);
    }
    cubit.getAllSpecializations(forceRefresh: true).then((_) {
      if (!mounted) return;
      final current = cubit.state;
      if (current is SharedSpecializationsLoaded) {
        setState(() => _specializations = current.specializations);
      }
    });
  }

  Future<void> _pickSpecialization() async {
    if (_specializations.isEmpty) {
      _loadSpecializations();
      Alerts.showSnackBar(
        context,
        message: 'loading'.tr(),
        state: SnackState.info,
      );
      return;
    }
    final selected = await SpecializationPickerSheet.show(
      context,
      specializations: _specializations,
      selectedId: _selectedSpecializationId,
    );
    if (selected != null) {
      setState(() => _selectedSpecializationId = selected.id);
    }
  }

  @override
  void dispose() {
    _clinicNameController.dispose();
    _descriptionController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  String _getPhone() {
    return UserSession.userModel?['phoneNumber'] ?? '';
  }

  String? get _selectedSpecializationName {
    final id = _selectedSpecializationId;
    if (id == null) return null;
    for (final s in _specializations) {
      if (s.id == id) return s.displayName;
    }
    return null;
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
    final picked = await showTimePicker(
      context: context,
      initialTime: current,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
        child: child!,
      ),
    );
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

  List<String> _buildWorkingDays() {
    return _dayHours
        .where((d) => !d.isClosed)
        .map((d) => d.dayName)
        .toList();
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      if (widget.isSetupMode) {
        _submitSetup();
      } else {
        _submitRegister();
      }
    }
  }

  void _submitRegister() {
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

  Future<void> _submitSetup() async {
    final cubit = context.read<AuthCubit>();

    String? logoName;
    final image = _clinicImage;
    if (image != null) {
      logoName = await cubit.uploadClinicImage(image);
      if (logoName == null) return;
    }

    final openDays = _dayHours.where((d) => !d.isClosed).toList();
    final workingHoursStart = openDays.isNotEmpty
        ? '${openDays.first.from.hour.toString().padLeft(2, '0')}:${openDays.first.from.minute.toString().padLeft(2, '0')}'
        : '09:00';
    final workingHoursEnd = openDays.isNotEmpty
        ? '${openDays.first.to.hour.toString().padLeft(2, '0')}:${openDays.first.to.minute.toString().padLeft(2, '0')}'
        : '17:00';

    cubit.setupClinic(
      AdminClinicSetupRequest(
        name: _clinicNameController.text.trim(),
        description: _descriptionController.text.trim(),
        address: _clinicAddress,
        phone: _getPhone(),
        email: _emailController.text.trim(),
        website: _websiteController.text.trim().isEmpty ? null : _websiteController.text.trim(),
        logo: logoName,
        workingHours: '$workingHoursStart-$workingHoursEnd',
        workingHoursStart: workingHoursStart,
        workingHoursEnd: workingHoursEnd,
        workingDays: _buildWorkingDays(),
        specializationId: _selectedSpecializationId ?? '',
        lat: _clinicLat ?? 0.0,
        lng: _clinicLng ?? 0.0,
      ),
    );
  }

  void _goHome() {
    LocationHelper.isPermissionGranted().then((isGranted) {
      if (!mounted) return;
      if (isGranted) {
        context.go(AppRoutes.home);
      } else {
        context.push(AppRoutes.locationPermission);
      }
    });
  }

  void _goDashboard() {
    LocationHelper.isPermissionGranted().then((isGranted) {
      if (!mounted) return;
      if (isGranted) {
        context.go(AppRoutes.clinicDashboard);
      } else {
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
        } else if (state is ClinicSetupCompleteState) {
          _goDashboard();
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
        isSetupMode: widget.isSetupMode,
        clinicNameController: _clinicNameController,
        descriptionController: _descriptionController,
        emailController: _emailController,
        websiteController: _websiteController,
        clinicAddress: _clinicAddress,
        clinicLat: _clinicLat,
        clinicImageFileName: _clinicImage?.path.split('\\').last ?? _clinicImage?.path.split('/').last,
        onPickClinicImage: _pickClinicImage,
        onPickLocation: _pickLocation,
        dayHours: _dayHours,
        onPickTime: _pickTime,
        onToggleClosed: _toggleClosed,
        selectedSpecializationName: _selectedSpecializationName,
        onPickSpecialization: _pickSpecialization,
        onSubmit: _onSubmit,
      ),
    );
  }
}
