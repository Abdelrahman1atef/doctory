import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import '../../../../core/common/models/type_of_user_for_register_flow.dart';
import '../../../../core/router/router_names.dart';
import '../../../../core/services/alerts.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/locator/service_locator.dart';
import '../../../../shared/cubit/specializations_cubit.dart';
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
  final _bioController = TextEditingController();
  final _yearsOfExperienceController = TextEditingController();

  String? _selectedGender;
  String? _selectedSpecializationId;
  bool _showImageErrors = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  File? _professionalPracticeCard;
  String? _professionalPracticeCardUrl;
  File? _unionIdImage;
  String? _unionIdImageUrl;
  File? _taxCardImage;
  String? _taxCardImageUrl;
  File? _profileImage;
  String? _profileImageUrl;

  TypeOfUserForRegisterFlow get _typeOfUser {
    if (widget.role == 'patient') return TypeOfUserForRegisterFlow.user;
    if (widget.doctorType == 'freelance') return TypeOfUserForRegisterFlow.freelanceDoctor;
    return TypeOfUserForRegisterFlow.clinic;
  }

  bool get _isDoctor => widget.role == 'doctor';

  @override
  void initState() {
    super.initState();
    if (_isDoctor) {
      sl<SharedSpecializationsCubit>().getAllSpecializations();
    }
  }

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
    _bioController.dispose();
    _yearsOfExperienceController.dispose();
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

  Future<void> _pickFile({
    bool isUnion = false,
    bool isPracticeCard = false,
    bool isTaxCard = false,
    bool isProfile = false,
  }) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      setState(() {
        if (isUnion) {
          _unionIdImage = file;
        } else if (isPracticeCard) {
          _professionalPracticeCard = file;
        } else if (isTaxCard) {
          _taxCardImage = file;
        } else if (isProfile) {
          _profileImage = file;
        }
      });
      
      final cubit = context.read<AuthCubit>();
      if (isUnion) {
        _unionIdImageUrl = await cubit.uploadImageSilently(file, 0, 6);
      } else if (isPracticeCard) {
        _professionalPracticeCardUrl = await cubit.uploadImageSilently(file, 0, 5);
      } else if (isTaxCard) {
        _taxCardImageUrl = await cubit.uploadImageSilently(file, 0, 7);
      } else if (isProfile) {
        _profileImageUrl = await cubit.uploadImageSilently(file, 0, 1);
      }
    }
  }

  void _onSubmit() {
    setState(() => _showImageErrors = false);

    bool hasImageErrors = false;
    if (_isDoctor) {
      final missingImages = <String>[];
      if (_profileImage == null) missingImages.add('profile');
      if (_professionalPracticeCard == null) missingImages.add('practice_card');
      if (_unionIdImage == null) missingImages.add('union_id');
      if (widget.doctorType == 'ownClinic' && _taxCardImage == null) {
        missingImages.add('tax_card');
      }
      if (missingImages.isNotEmpty) {
        hasImageErrors = true;
      }
    }

    final isValid = _formKey.currentState!.validate();

    if (hasImageErrors) {
      setState(() => _showImageErrors = true);
    }

    if (!isValid || hasImageErrors) {
      if ((_isDoctor && _selectedGender == null) || hasImageErrors) {
        Alerts.showSnackBar(
          context,
          message: context.l10n('field_required'),
          state: SnackState.failed,
        );
      }
      return;
    }

    final signupRequest = SignupRequest(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
      phoneNumber: _getFormattedPhone(),
      typeOfUser: _typeOfUser,
      birthDate: _buildBirthDate(),
      gender: _getGenderValue(),
      specializationId: _selectedSpecializationId,
      bio: _bioController.text.trim().isEmpty ? null : _bioController.text.trim(),
      yearsOfExperience: _yearsOfExperienceController.text.trim().isEmpty
          ? null
          : int.tryParse(_yearsOfExperienceController.text.trim()),
      doctorImage: _profileImageUrl,
      professionalPracticeCardImage: _professionalPracticeCardUrl,
      unionIdImage: _unionIdImageUrl,
      taxCardImage: _taxCardImageUrl,
    );

    context.read<AuthCubit>().signup(
      request: signupRequest,
      doctorImageFile: (_isDoctor && _profileImageUrl == null) ? _profileImage : null,
      professionalPracticeCardFile: (_isDoctor && _professionalPracticeCardUrl == null) ? _professionalPracticeCard : null,
      unionIdFile: (_isDoctor && _unionIdImageUrl == null) ? _unionIdImage : null,
      taxCardFile: (_isDoctor && widget.doctorType == 'ownClinic' && _taxCardImageUrl == null) ? _taxCardImage : null,
    );
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
        } else if (state is SignupPendingState) {
          Alerts.showSnackBar(
            context,
            message: context.l10n('signup_pending_approval'),
            state: SnackState.info,
          );
          context.go(AppRoutes.login);
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
      child: _isDoctor
          ? BlocBuilder<SharedSpecializationsCubit, SharedSpecializationsState>(
              bloc: sl<SharedSpecializationsCubit>(),
              builder: (context, specState) {
                if (specState is SharedSpecializationsLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(50.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                final specializations = specState is SharedSpecializationsLoaded
                    ? specState.specializations
                    : null;
                return _buildForm(specializations);
              },
            )
          : _buildForm(null),
    );
  }

  Widget _buildForm(dynamic specializations) {
    return RegisterFormWidget(
      formKey: _formKey,
      nameController: _nameController,
        emailController: _emailController,
        phoneController: _phoneController,
        dayController: _dayController,
        monthController: _monthController,
        yearController: _yearController,
        passwordController: _passwordController,
        confirmPasswordController: _confirmPasswordController,
        bioController: _bioController,
        yearsOfExperienceController: _yearsOfExperienceController,
        selectedGender: _selectedGender,
        obscurePassword: _obscurePassword,
        obscureConfirmPassword: _obscureConfirmPassword,
        onGenderChanged: (gender) => setState(() => _selectedGender = gender),
        onTogglePassword: () =>
            setState(() => _obscurePassword = !_obscurePassword),
        onToggleConfirmPassword: () =>
            setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
        onSubmit: _onSubmit,
        isDoctor: _isDoctor,
        requireBioFields: _isDoctor,
        practiceCardFileName: _isDoctor
            ? _professionalPracticeCard?.path.split('/').last ?? _professionalPracticeCard?.path.split('\\').last
            : null,
        unionFileName: _isDoctor
            ? _unionIdImage?.path.split('/').last ?? _unionIdImage?.path.split('\\').last
            : null,
        taxCardFileName: _isDoctor
            ? _taxCardImage?.path.split('/').last ?? _taxCardImage?.path.split('\\').last
            : null,
        profileImage: _isDoctor ? _profileImage : null,
        onPickPracticeCard: _isDoctor
            ? () => _pickFile(isPracticeCard: true)
            : null,
        onPickUnion: _isDoctor
            ? () => _pickFile(isUnion: true)
            : null,
        onPickTaxCard: _isDoctor && widget.doctorType == 'ownClinic'
            ? () => _pickFile(isTaxCard: true)
            : null,
        onPickProfileImage: _isDoctor
            ? (File? file) async {
                if (file != null) {
                  setState(() {
                    _profileImage = file;
                    _profileImageUrl = null;
                  });
                  final cubit = context.read<AuthCubit>();
                  _profileImageUrl = await cubit.uploadImageSilently(file, 0, 1);
                }
              }
            : null,
        showImageErrors: _showImageErrors,
        specializations: specializations,
        selectedSpecializationId: _selectedSpecializationId,
        onSpecializationChanged: _isDoctor
            ? (value) => setState(() => _selectedSpecializationId = value)
            : null,
        onGoogleSignIn: () => context.read<AuthCubit>().signInWithGoogle(),
        onFacebookSignIn: () => context.read<AuthCubit>().signInWithFacebook(),
        onLogin: () => context.pop(),

    );
  }
}