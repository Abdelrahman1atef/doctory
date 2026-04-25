import 'package:doctory/core/network/interfaces/api_consumer.dart';
import 'package:doctory/features/search_results/data/data_source/search_endpoints.dart';
import 'package:doctory/features/search_results/data/model/hospital_model.dart';

abstract class SearchRemoteDataSource {
  Future<ApiResult<List<HospitalModel>>> searchHospitals({
    required double lat,
    required double lng,
    String? query,
  });
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final ApiConsumer _apiConsumer;

  SearchRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<ApiResult<List<HospitalModel>>> searchHospitals({
    required double lat,
    required double lng,
    String? query,
  }) async {
    await Future.delayed(const Duration(seconds: 1)); // simulate network delay
    final dummyJson = {
      "success": true,
      "errors": {},
      "data": [
        {
          "id": "00000000-0000-0000-0000-000000000000",
          "name": "Mansoura Military Hospital",
          "nameAr": null,
          "address":
              "Mansoura Military Hospital, Sandob Bridge, Sandob And Kafr Al Manasra, El Mansura, Ad Dakahliya, 35796, Egypt",
          "addressAr": null,
          "phone": null,
          "lat": 31.0200341,
          "lng": 31.39608991,
          "isRegistered": false,
          "specializationName": null,
          "distance": 0.002364392690151377,
        },
        {
          "id": "00000000-0000-0000-0000-000000000001",
          "name": "International Hospital",
          "nameAr": null,
          "address":
              "International Hospital, Amam Al Mostashfa Al Dawly Street, Sandob And Kafr Al Manasra, El Mansura, Ad Dakahliya, 35517, Egypt",
          "addressAr": null,
          "phone": null,
          "lat": 31.03193645,
          "lng": 31.39068707,
          "isRegistered": false,
          "specializationName": null,
          "distance": 0.011153866239461118,
        },
        {
          "id": "00000000-0000-0000-0000-000000000002",
          "name": "مستشفي الصدر",
          "nameAr": null,
          "address":
              "مستشفي الصدر, Street 9, Second Al Hewar, El Mansura, Ad Dakahliya, 35516, Egypt",
          "addressAr": null,
          "phone": null,
          "lat": 31.03238175,
          "lng": 31.37284993,
          "isRegistered": false,
          "specializationName": null,
          "distance": 0.02396182555642075,
        },
        {
          "id": "00000000-0000-0000-0000-000000000003",
          "name": "Tabarak Hospital",
          "nameAr": null,
          "address":
              "Tabarak Hospital, Ma'moun Al Shenawy Street, Sabea Al Bahr Al Saghir, El Mansura, Ad Dakahliya, 35512, Egypt",
          "addressAr": null,
          "phone": null,
          "lat": 31.0457302,
          "lng": 31.39453,
          "isRegistered": false,
          "specializationName": null,
          "distance": 0.02441462115139318,
        },
        {
          "id": "00000000-0000-0000-0000-000000000004",
          "name": "التأمين الصحي",
          "nameAr": null,
          "address":
              "التأمين الصحي, Al Abbasi Street, Third Rihan, El Mansura, Ad Dakahliya, 35513, Egypt",
          "addressAr": null,
          "phone": null,
          "lat": 31.0427801,
          "lng": 31.3783093,
          "isRegistered": false,
          "specializationName": null,
          "distance": 0.02664733870851758,
        },
        {
          "id": "00000000-0000-0000-0000-000000000005",
          "name": "Al-Hekma Hospital",
          "nameAr": null,
          "address":
              "Al-Hekma Hospital, Al Sheikh Saad Street, Fifth Siyam, El Mansura, Ad Dakahliya, 35512, Egypt",
          "addressAr": null,
          "phone": null,
          "lat": 31.0475408,
          "lng": 31.3886277,
          "isRegistered": false,
          "specializationName": null,
          "distance": 0.026787544872753727,
        },
        {
          "id": "00000000-0000-0000-0000-000000000006",
          "name": "عيادة أ.د. محمد أبوحجازى لطب المخ والأعصاب",
          "nameAr": null,
          "address":
              "195, Al Gemhoureya Street, Second Al Hewar, Talkha, Ad Dakahliya, 35511, Egypt",
          "addressAr": null,
          "phone": null,
          "lat": 31.0474963,
          "lng": 31.3844462,
          "isRegistered": false,
          "specializationName": null,
          "distance": 0.027902238668356328,
        },
        {
          "id": "00000000-0000-0000-0000-000000000007",
          "name": "Hospital of Ophthalmology",
          "nameAr": null,
          "address":
              "Hospital of Ophthalmology, Ghehan Al Sadat Street, First Mit Talkha, Talkha, Ad Dakahliya, 35516, Egypt",
          "addressAr": null,
          "phone": null,
          "lat": 31.0440243,
          "lng": 31.36494221,
          "isRegistered": false,
          "specializationName": null,
          "distance": 0.03695949101979859,
        },
        {
          "id": "00000000-0000-0000-0000-000000000008",
          "name": "Gezeera International Hospital - El Sallab",
          "nameAr": null,
          "address":
              "Gezeera International Hospital - El Sallab, Mohamed Atef Al Mangy Street, First Mit Talkha, Talkha, Ad Dakahliya, 35516, Egypt",
          "addressAr": null,
          "phone": null,
          "lat": 31.0453946,
          "lng": 31.3656479,
          "isRegistered": false,
          "specializationName": null,
          "distance": 0.03727525846990674,
        },
      ],
      "message": "The operation was successful",
      "statusCode": 200,
    };

    final List<dynamic> data = dummyJson['data'] as List<dynamic>;
    final list = data
        .map((e) => HospitalModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return ApiResult.success(list);
  }
}
