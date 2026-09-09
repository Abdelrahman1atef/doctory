import 'package:doctory/core/config/deep_link_config.dart';
import 'package:doctory/core/network/interfaces/api_consumer.dart';
import 'package:doctory/core/router/app_router.dart';
import 'package:doctory/core/services/deep_link_service.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../cubit/my_appointments_cubit.dart';
import '../data/data_source/my_appointments_remote_data_source.dart';
import '../domain/pending_payment.dart';

void setupMyAppointmentsDI(GetIt sl) {
  if (!sl.isRegistered<MyAppointmentsRemoteDataSource>()) {
    sl.registerLazySingleton<MyAppointmentsRemoteDataSource>(
      () => MyAppointmentsRemoteDataSourceImpl(
        apiConsumer: sl<ApiConsumer>(),
      ),
    );
  }

  if (!sl.isRegistered<MyAppointmentsCubit>()) {
    sl.registerFactory<MyAppointmentsCubit>(
      () => MyAppointmentsCubit(
        remoteDataSource: sl<MyAppointmentsRemoteDataSource>(),
      ),
    );
  }

  // Deep link handler — /appointments/{id}
  DeepLinkService.instance.register((uri) {
    if (uri.scheme != DeepLinkConfig.scheme ||
        uri.host != DeepLinkConfig.host) {
      return false;
    }
    if (uri.path.startsWith('/appointments/')) {
      final segments = uri.pathSegments;
      final appointmentId =
          segments.length > 1 ? segments[1] : null;
      final detailsPath = appointmentId != null && appointmentId.isNotEmpty
          ? '/my-appointments/details?id=$appointmentId'
          : '/my-appointments';
      DeepLinkService.instance.setPendingPath(detailsPath);
      AppRouter.navigatorKey.currentContext?.go(detailsPath);
      return true;
    }
    return false;
  });

  // Deep link handler — doctory://payment-result?success=…&order=…
  //
  // The gateway sends the user back here after paying. The webview's own
  // result callback usually fires first; this is the fallback for when the
  // gateway navigates out to the browser instead.
  DeepLinkService.instance.register((uri) {
    if (uri.scheme != 'doctory' || uri.host != 'payment-result') return false;

    final success = _isTruthy(uri.queryParameters['success']);
    final appointmentId = PendingPayment.consumeAppointmentId();

    // Close the payment webview if it is still on top.
    final navigator = AppRouter.navigatorKey.currentState;
    if (navigator != null && navigator.canPop()) navigator.pop();

    // `order` is the payment id. Park it for the details screen, which owns the
    // cubit instance bound to the UI and can run the verify call.
    final paymentId = uri.queryParameters['order'];
    if (success && paymentId != null && paymentId.isNotEmpty) {
      PendingPayment.awaitVerification(paymentId);
    } else {
      PendingPayment.clear();
    }

    final path = appointmentId != null && appointmentId.isNotEmpty
        ? '/my-appointments/details?id=$appointmentId'
        : '/my-appointments';
    DeepLinkService.instance.setPendingPath(path);
    AppRouter.navigatorKey.currentContext?.go(path);

    // A failure is reported here; success is reported by the details screen
    // once the server has actually confirmed the payment.
    if (!success) {
      final messengerContext = AppRouter.navigatorKey.currentContext;
      if (messengerContext != null) {
        ScaffoldMessenger.of(messengerContext).showSnackBar(
          SnackBar(
            content: Text('payment_failed'.tr()),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
    return true;
  });
}

/// The gateway is not consistent about how it spells a successful result.
bool _isTruthy(String? value) {
  final normalized = value?.trim().toLowerCase();
  return normalized == 'true' || normalized == '1' || normalized == 'success';
}
