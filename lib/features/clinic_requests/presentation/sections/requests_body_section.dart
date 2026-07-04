import 'package:doctory/features/clinic_requests/cubit/reservation_requests_cubit.dart';
import 'package:doctory/features/clinic_requests/cubit/reservation_requests_state.dart';
import 'package:doctory/features/clinic_requests/presentation/widgets/request_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RequestsBodySection extends StatelessWidget {
  const RequestsBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReservationRequestsCubit, ReservationRequestsState>(
      builder: (context, state) {
        if (state is RequestsLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is RequestsError) {
          return Center(child: Text(state.message));
        }
        if (state is RequestsLoaded) {
          if (state.requests.isEmpty) {
            return const Center(child: Text('لا توجد طلبات'));
          }
          return ListView.builder(
            itemCount: state.requests.length,
            itemBuilder: (context, index) {
              final request = state.requests[index];
              return RequestCard(
                request: request,
                onAccept: () => context
                    .read<ReservationRequestsCubit>()
                    .accept(request.id),
                onReject: () => context
                    .read<ReservationRequestsCubit>()
                    .reject(request.id),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
