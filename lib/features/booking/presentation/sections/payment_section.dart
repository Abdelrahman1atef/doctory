import 'package:doctory/features/booking/cubit/booking_cubit.dart';
import 'package:doctory/features/booking/cubit/booking_state.dart';
import 'package:doctory/features/booking/presentation/widgets/booking_error_banner.dart';
import 'package:doctory/features/booking/presentation/widgets/booking_payment_method_card.dart';
import 'package:doctory/features/booking/presentation/widgets/booking_payment_summary.dart';
import 'package:doctory/features/booking/presentation/widgets/booking_section_header.dart';
import 'package:doctory/features/booking/presentation/widgets/booking_timer_banner.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentSection extends StatelessWidget {
  const PaymentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      buildWhen: (prev, curr) => curr is BookingData,
      builder: (context, state) {
        if (state is! BookingData) return const SizedBox.shrink();

        final reservation = state.reservation;
        if (reservation == null) return const SizedBox.shrink();

        final timeLeft = reservation.expiresAt.difference(DateTime.now());

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BookingTimerBanner(
                minutes: timeLeft.inMinutes,
                seconds: timeLeft.inSeconds % 60,
              ),
              const SizedBox(height: 24),
              BookingSectionHeader(
                title: 'payment_details'.tr(),
                subtitle: 'complete_payment_to_confirm'.tr(),
              ),
              const SizedBox(height: 20),
              BookingPaymentSummary(
                amount: reservation.amount,
                currency: reservation.currency,
              ),
              const SizedBox(height: 24),
              Text(
                'payment_method'.tr(),
              ),
              const SizedBox(height: 12),
              BookingPaymentMethodCard(
                icon: Icons.credit_card_rounded,
                title: 'credit_card'.tr(),
                subtitle: 'credit_card_desc'.tr(),
                isSelected: true,
              ),
              // const SizedBox(height: 12),
              // BookingPaymentMethodCard(
              //   icon: Icons.money_rounded,
              //   title: 'cash'.tr(),
              //   subtitle: 'cash_desc'.tr(),
              //   isSelected: false,
              // ),
              if (state.submissionError != null) ...[
                const SizedBox(height: 20),
                BookingErrorBanner(message: state.submissionError!),
              ],
            ],
          ),
        );
      },
    );
  }
}
