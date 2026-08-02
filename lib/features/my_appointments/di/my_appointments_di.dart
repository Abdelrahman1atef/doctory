import 'package:doctory/core/config/deep_link_config.dart';
import 'package:doctory/core/network/interfaces/api_consumer.dart';
import 'package:doctory/core/router/app_router.dart';
import 'package:doctory/core/services/deep_link_service.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../cubit/my_appointments_cubit.dart';
import '../data/data_source/my_appointments_remote_data_source.dart';

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
}
