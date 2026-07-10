import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import '../../../../core/router/router_names.dart';
import '../../../../core/services/alerts.dart';
import '../../../../core/utils/extensions.dart';
import '../../cubit/auth_cubit.dart';
import '../../cubit/auth_states.dart';
import '../../data/model/signup_request.dart';
import '../widgets/register_form_widget.dart';

class RegisterFormSection extends StatefulWidget {
  final String role;
  final String? doctorType;

  const RegisterFormSection({super.key, required this.role, this.doctorType});

  @override
  State<RegisterFormSection> createState() => _RegisterFormSectionState();
}

class _RegisterFormSectionState extends State<RegisterFormSection> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _dayController = TextEditingController();
  final _monthController = TextEditingController();
  final _yearController = TextEditingController();

  String? _selectedGender;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  File? _professionalPracticeCard;
  File? _syndicateIdImage;
  File? _commercialRegister;
  File? _profileImage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  String _getFormattedPhone() {
    final phone = _phoneController.text.trim();
    return phone.startsWith('0') ? phone.substring(1) : phone;
  }

  int? _getGenderValue() {
    if (_selectedGender == null) return null;
    switch (_selectedGender) {
      case 'male':
        return 1;
      case 'female':
        return 2;
      default:
        return null;
    }
  }

  String? _buildBirthDate() {
    if (_dayController.text.isNotEmpty &&
        _monthController.text.isNotEmpty &&
        _yearController.text.isNotEmpty) {
      final day = _dayController.text.padLeft(2, '0');
      final month = _monthController.text.padLeft(2, '0');
      final year = _yearController.text;
      return '$year-$month-$day';
    }
    return null;
  }

  Future<void> _pickFile({bool isSyndicate = false, bool isPracticeCard = false, bool isCommercialRegister = false, bool isProfile = false}) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        if (isSyndicate) {
          _syndicateIdImage = File(result.files.single.path!);
        } else if (isPracticeCard) {
          _professionalPracticeCard = File(result.files.single.path!);
        } else if (isCommercialRegister) {
          _commercialRegister = File(result.files.single.path!);
        } else if (isProfile) {
          _profileImage = File(result.files.single.path!);
        }
      });
    }
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      final isDoctor = widget.role == 'doctor';

      if (isDoctor && _selectedGender == null) {
        Alerts.showSnackBar(
          context,
          message: context.l10n('field_required'),
          state: SnackState.failed,
        );
        return;
      }
      if (isDoctor && _profileImage == null) {
        Alerts.showSnackBar(
          context,
          message: context.l10n('profile_image_required'),
          state: SnackState.failed,
        );
        return;
      }

      final signupRequest = SignupRequest(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        phoneNumber: _getFormattedPhone(),
        birthDate: _buildBirthDate(),
        gender: _getGenderValue(),
        role: widget.role,
        doctorType: widget.doctorType,
      );

      context.read<AuthCubit>().signup(
        signupRequest,
        professionalPracticeCardImagePath: isDoctor ? _professionalPracticeCard?.path : null,
        syndicateIdImagePath: isDoctor ? _syndicateIdImage?.path : null,
        commercialRegisterImagePath: isDoctor ? _commercialRegister?.path : null,
      );
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

        if (state is SignupSuccessState) {
          if (widget.doctorType == 'ownClinic') {
            context.push(AppRoutes.clinicCompleteProfile);
          } else {
            context.push(AppRoutes.home);
          }
        } else if (state is AuthSuccessState) {
          context.go(AppRoutes.completeProfile);
        } else if (state is AuthErrorState) {
          Alerts.showSnackBar(
            context,
            message: state.message,
            state: SnackState.failed,
          );
        }
      },
      child: RegisterFormWidget(
        formKey: _formKey,
        nameController: _nameController,
        emailController: _emailController,
        phoneController: _phoneController,
        dayController: _dayController,
        monthController: _monthController,
        yearController: _yearController,
        passwordController: _passwordController,
        confirmPasswordController: _confirmPasswordController,
        selectedGender: _selectedGender,
        obscurePassword: _obscurePassword,
        obscureConfirmPassword: _obscureConfirmPassword,
        onGenderChanged: (gender) => setState(() => _selectedGender = gender),
        onTogglePassword: () =>
            setState(() => _obscurePassword = !_obscurePassword),
        onToggleConfirmPassword: () =>
            setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
        onSubmit: _onSubmit,
        doctorType: widget.doctorType,
        requireBioFields: widget.role == 'doctor',
        practiceCardFileName: widget.role == 'doctor'
            ? _professionalPracticeCard?.path.split('/').last ?? _professionalPracticeCard?.path.split('\\').last
            : null,
        syndicateFileName: widget.role == 'doctor'
            ? _syndicateIdImage?.path.split('/').last ?? _syndicateIdImage?.path.split('\\').last
            : null,
        commercialRegisterFileName: widget.role == 'doctor' && widget.doctorType == 'ownClinic'
            ? _commercialRegister?.path.split('/').last ?? _commercialRegister?.path.split('\\').last
            : null,
        profileImage: widget.role == 'doctor' ? _profileImage : null,
        onPickPracticeCard: widget.role == 'doctor'
            ? () => _pickFile(isPracticeCard: true)
            : null,
        onPickSyndicate: widget.role == 'doctor'
            ? () => _pickFile(isSyndicate: true)
            : null,
        onPickCommercialRegister: widget.role == 'doctor' && widget.doctorType == 'ownClinic'
            ? () => _pickFile(isCommercialRegister: true)
            : null,
        onPickProfileImage: widget.role == 'doctor'
            ? (File? file) {
                setState(() {
                  if (file != null) _profileImage = file;
                });
              }
            : null,
        onGoogleSignIn: () => context.read<AuthCubit>().signInWithGoogle(),
        onFacebookSignIn: () => context.read<AuthCubit>().signInWithFacebook(),
        onLogin: () => context.pop(),
      ),
    );
  }
}
