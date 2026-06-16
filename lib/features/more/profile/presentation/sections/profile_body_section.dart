import 'dart:io';
import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/services/alerts.dart';
import 'package:doctory/core/services/media/my_media.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/more/profile/cubit/profile_cubit.dart';
import 'package:doctory/features/more/profile/cubit/profile_states.dart';
import 'package:doctory/features/more/profile/presentation/widgets/profile_form_widget.dart';
import 'package:doctory/features/more/profile/presentation/widgets/profile_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

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

  @override
  void dispose() {
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
    }
  }

  void _onSubmit() {
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileStates>(
      listener: (context, state) {
        if (state is ProfileUpdateLoading) {
          SmartDialog.showLoading();
        } else {
          SmartDialog.dismiss();
        }

        if (state is ProfileUpdateSuccess) {
          Alerts.snack(text: context.l10n(state.message), state: SnackState.success);
        } else if (state is ProfileUpdateError) {
          Alerts.snack(text: state.message, state: SnackState.failed);
        }

        if (state is ProfileLoadSuccess) {
          final user = state.user;
          _nameController.text = user.fullName;
          _phoneController.text = user.phoneNumber ?? '';
          _selectedGender = _getGenderString(user.gender);

          if (user.birthDate != null && user.birthDate!.contains('-')) {
            final parts = user.birthDate!.split('-');
            if (parts.length == 3) {
              _yearController.text = parts[0];
              _monthController.text = parts[1];
              _dayController.text = parts[2];
            }
          }
        }
      },
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ProfileLoadError) {
          return Center(child: Text(state.message));
        }

        final user = (state is ProfileLoadSuccess) ? state.user : null;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              ProfileImageWidget(
                imageUrl: user?.profilePictureUrl,
                localImage: _pickedImage,
                onPickImage: _onPickImage,
              ),
              32.ph,
              ProfileFormWidget(
                formKey: _formKey,
                nameController: _nameController,
                phoneController: _phoneController,
                dayController: _dayController,
                monthController: _monthController,
                yearController: _yearController,
                selectedGender: _selectedGender,
                onGenderChanged: (gender) => setState(() => _selectedGender = gender),
                onSubmit: _onSubmit,
              ),
            ],
          ),
        );
      },
    );
  }
}
