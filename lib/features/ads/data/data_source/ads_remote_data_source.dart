import 'package:doctory/core/network/interfaces/api_consumer.dart';
import 'package:doctory/features/ads/data/model/public_ad_model.dart';

abstract class AdsRemoteDataSource {
  Future<ApiResult<List<PublicAdModel>>> getActiveAds();
}

class AdsRemoteDataSourceImpl implements AdsRemoteDataSource {
  final ApiConsumer _apiConsumer;

  AdsRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<ApiResult<List<PublicAdModel>>> getActiveAds() async {
    return await _apiConsumer.get<List<PublicAdModel>>(
      path: 'public/ads/active',
      parser: (json) {
        final data = json['data'] as List<dynamic>?;
        if (data == null) return <PublicAdModel>[];
        return data
            .map((e) => PublicAdModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }
}