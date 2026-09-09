import 'dart:io';
import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/services/alerts.dart';
import 'package:doctory/core/services/media/my_media.dart';
import 'package:doctory/features/auth/data/model/user_model.dart';
import 'package:doctory/features/more/profile/cubit/profile_cubit.dart';
import 'package:doctory/features/more/profile/cubit/profile_states.dart';
import 'package:doctory/core/common/widgets/error/app_error_widget.dart';
import 'package:doctory/features/more/profile/presentation/widgets/profile_form_layout_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileBodySection extends StatefulWidget {
  const ProfileBodySection({super.key});

  @override
  State<ProfileBodySection> createState() => _ProfileBodySectionState();
}

class _ProfileBodySectionState extends State<ProfileBodySection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dayController = TextEditingController();
  final _monthController = TextEditingController();
  final _yearController = TextEditingController();
  String _selectedGender = 'male';
  File? _pickedImage;
  UserModel? _loadedUser;
  bool _isSaveEnabled = true;

  void _onFieldChanged() {
    final hasChanges = _computeHasChanges();
    if (hasChanges != _isSaveEnabled) {
      setState(() => _isSaveEnabled = hasChanges);
    }
  }

  bool _computeHasChanges() {
    final user = _loadedUser;
    if (user == null) return true;
    if (_pickedImage != null) return true;

    final day = _dayController.text.padLeft(2, '0');
    final month = _monthController.text.padLeft(2, '0');
    final year = _yearController.text;
    String? birthDate;
    if (day.isNotEmpty && month.isNotEmpty && year.isNotEmpty) {
      birthDate = '$year-$month-$day';
    }

    return _nameController.text.trim() != user.fullName ||
        _phoneController.text.trim() != (user.phoneNumber ?? '') ||
        birthDate != user.birthDate ||
        _getGenderValue() != user.gender;
  }

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onFieldChanged);
    _phoneController.addListener(_onFieldChanged);
    _dayController.addListener(_onFieldChanged);
    _monthController.addListener(_onFieldChanged);
    _yearController.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    _nameController.removeListener(_onFieldChanged);
    _phoneController.removeListener(_onFieldChanged);
    _dayController.removeListener(_onFieldChanged);
    _monthController.removeListener(_onFieldChanged);
    _yearController.removeListener(_onFieldChanged);
    _nameController.dispose();
    _phoneController.dispose();
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  void _onPickImage() async {
    final mediaService = sl<MediaService>();
    final image = await mediaService.pickImageFromGallery();
    if (image != null) {
      setState(() => _pickedImage = image);
      _onFieldChanged();
    }
  }

  void _onSubmit() {
    if (!_isSaveEnabled) return;
    if (_formKey.currentState!.validate()) {
      final day = _dayController.text.padLeft(2, '0');
      final month = _monthController.text.padLeft(2, '0');
      final year = _yearController.text;

      String? birthDate;
      if (day.isNotEmpty && month.isNotEmpty && year.isNotEmpty) {
        birthDate = '$year-$month-$day';
      }

      context.read<ProfileCubit>().updateProfile(
        fullName: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        birthDate: birthDate,
        gender: _getGenderValue(),
        profileImage: _pickedImage,
      );
    }
  }

  int _getGenderValue() {
    switch (_selectedGender) {
      case 'male':
        return 1;
      case 'female':
        return 2;
      default:
        return 1;
    }
  }

  String _getGenderString(int? value) {
    switch (value) {
      case 1:
        return 'male';
      case 2:
        return 'female';
      default:
        return 'male';
    }
  }

  void _onGenderChanged(String gender) {
    setState(() => _selectedGender = gender);
    _onFieldChanged();
  }

  void _prefillFrom(UserModel user) {
    _loadedUser = user;
    _nameController.text = user.fullName;
    _phoneController.text = user.phoneNumber ?? '';
    _selectedGender = _getGenderString(user.gender);

    final String? birthDate = user.birthDate;
    if (birthDate != null && birthDate.contains('-')) {
      final List<String> parts = birthDate.split('-');
      if (parts.length == 3) {
        _yearController.text = parts[0];
        _monthController.text = parts[1];
        _dayController.text = parts[2];
      }
    }
    _isSaveEnabled = false;
  }

  Widget _form(UserModel? user) => ProfileFormLayoutWidget(
    imageUrl: user?.profilePictureUrl,
    pickedImage: _pickedImage,
    onPickImage: _onPickImage,
    formKey: _formKey,
    nameController: _nameController,
    phoneController: _phoneController,
    dayController: _dayController,
    monthController: _monthController,
    yearController: _yearController,
    selectedGender: _selectedGender,
    onGenderChanged: _onGenderChanged,
    onSubmit: _onSubmit,
    isSaveEnabled: _isSaveEnabled,
  );

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileStates>(
      listener: (context, state) {
        switch (state) {
          case ProfileUpdateLoading():
            SmartDialog.showLoading();
          case ProfileUpdateSuccess(:final message):
            SmartDialog.dismiss();
            Alerts.snack(text: message.tr(), state: SnackState.success);
          case ProfileUpdateError(:final message):
            SmartDialog.dismiss();
            Alerts.snack(text: message, state: SnackState.failed);
          case ProfileLoadSuccess(:final user):
            SmartDialog.dismiss();
            _prefillFrom(user);
          case ProfileInitial() || ProfileLoading() || ProfileLoadError():
            SmartDialog.dismiss();
        }
      },
      builder: (context, state) => switch (state) {
        ProfileLoading() => const Center(child: CircularProgressIndicator()),
        ProfileLoadError(:final message) => AppErrorWidget(
          message: message,
          onRetry: context.read<ProfileCubit>().getProfile,
        ),
        ProfileLoadSuccess(:final user) => _form(user),
        ProfileInitial() ||
        ProfileUpdateLoading() ||
        ProfileUpdateSuccess() ||
        ProfileUpdateError() =>
          _form(_loadedUser),
      },
    );
  }
}
