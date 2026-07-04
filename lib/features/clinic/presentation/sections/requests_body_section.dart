import 'package:doctory/core/app_strings/locale_keys.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/features/clinic/cubit/reservation_requests_cubit.dart';
import 'package:doctory/features/clinic/cubit/reservation_requests_state.dart';
import 'package:doctory/features/clinic/presentation/widgets/request_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RequestsBodySection extends StatelessWidget {
  const RequestsBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReservationRequestsCubit, ReservationRequestsState>(
      builder: (context, state) {
        return Column(
          children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go(AppRoutes.home);
                        }
                      },
                      icon: const Icon(Icons.arrow_back_ios_new),
                    ),
                    Text(
                      LocaleKeys.requests_inbox.tr(),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
              ),
            ),
            Expanded(
              child: _buildBody(state, context),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBody(ReservationRequestsState state, BuildContext context) {
    if (state is RequestsLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is RequestsError) {
      return Center(child: Text(state.message));
    }
    if (state is RequestsLoaded) {
      if (state.requests.isEmpty) {
        return Center(
          child: Text(LocaleKeys.no_requests.tr()),
        );
      }
      return ListView.builder(
        itemCount: state.requests.length,
        itemBuilder: (context, index) {
          final request = state.requests[index];
          return RequestCard(
            request: request,
            onAccept: () =>
                context.read<ReservationRequestsCubit>().accept(request.id),
            onReject: () =>
                context.read<ReservationRequestsCubit>().reject(request.id),
          );
        },
      );
    }
    return const SizedBox.shrink();
  }
}
