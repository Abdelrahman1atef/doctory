import 'package:doctory/core/common/models/doctor_model.dart';
import 'package:doctory/core/network/interfaces/api_consumer.dart';
import 'doctor_details_endpoints.dart';
import '../model/doctor_details_response_dto.dart';

abstract class DoctorDetailsRemoteDataSource {
  Future<ApiResult<DoctorModel>> getDoctorDetails(String id);
}

class DoctorDetailsRemoteDataSourceImpl
    implements DoctorDetailsRemoteDataSource {
  final ApiConsumer apiConsumer;

  DoctorDetailsRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<ApiResult<DoctorModel>> getDoctorDetails(String id) {
    return apiConsumer.get<DoctorModel>(
      path: '${DoctorDetailsEndpoints.doctorDetails}/$id/details',
      parser: (json) =>
          DoctorDetailsResponseDto.fromJson(json).doctor,
    );
  }
}
