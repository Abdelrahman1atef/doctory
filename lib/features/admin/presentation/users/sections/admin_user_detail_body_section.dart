import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubit/users/admin_users_cubit.dart';
import '../../../cubit/users/admin_users_states.dart';

class AdminUserDetailBodySection extends StatelessWidget {
  const AdminUserDetailBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminUsersCubit, AdminUsersState>(
      builder: (context, state) {
        if (state is AdminUsersLoading) return const Center(child: CircularProgressIndicator());
        if (state is AdminUsersError) return Center(child: Text(state.message));
        if (state is AdminUsersLoaded) {
          return const Center(child: Text('Select a user from the list'));
        }
        return const SizedBox.shrink();
      },
    );
  }
}
