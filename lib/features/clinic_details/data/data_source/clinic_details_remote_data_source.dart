import 'package:doctory/core/common/models/clinic_model.dart';
import 'package:doctory/core/network/interfaces/api_consumer.dart';
import 'clinic_details_endpoints.dart';
import '../model/clinic_details_response_dto.dart';

abstract class ClinicDetailsRemoteDataSource {
  Future<ApiResult<ClinicModel>> getClinicDetails(String id);
}

class ClinicDetailsRemoteDataSourceImpl
    implements ClinicDetailsRemoteDataSource {
  final ApiConsumer apiConsumer;

  ClinicDetailsRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<ApiResult<ClinicModel>> getClinicDetails(String id) {
    return apiConsumer.get<ClinicModel>(
      path: '${ClinicDetailsEndpoints.clinicDetails}/$id',
      parser: (json) =>
          ClinicDetailsResponseDto.fromJson(json).clinic,
    );
  }
}
