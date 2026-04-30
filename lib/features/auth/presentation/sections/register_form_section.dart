import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import '../../../../core/router/router_names.dart';
import '../../../../core/services/alerts.dart';
import '../../cubit/auth_cubit.dart';
import '../../cubit/auth_states.dart';
import '../../data/model/signup_request.dart';
import '../widgets/register_form_widget.dart';

class RegisterFormSection extends StatefulWidget {
  const RegisterFormSection({super.key});

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
  final _birthDateController = TextEditingController();

  String _selectedGender = 'male';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  String _getFormattedPhone() {
    final phone = _phoneController.text.trim();
    return phone.startsWith('0') ? phone.substring(1) : phone;
  }

  int _getGenderValue() {
    switch (_selectedGender) {
      case 'male':
        return 1;
      case 'female':
        return 2;
      default:
        return 3;
    }
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().signup(
        SignupRequest(
          fullName: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
          phoneNumber: _getFormattedPhone(),
          birthDate: _birthDateController.text,
          gender: _getGenderValue(),
        ),
      );
    }
  }

  Future<void> _onPickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 20)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthDateController.text = picked.toIso8601String().split('T')[0];
      });
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
          context.push(AppRoutes.otpVerification, extra: state.email);
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
        birthDateController: _birthDateController,
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
        onPickDate: _onPickDate,
        onSubmit: _onSubmit,
        onGoogleSignIn: () => context.read<AuthCubit>().signInWithGoogle(),
        onFacebookSignIn: () => context.read<AuthCubit>().signInWithFacebook(),
        onLogin: () => context.pop(),
      ),
    );
  }
}
