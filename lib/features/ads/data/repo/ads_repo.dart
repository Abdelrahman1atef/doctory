import 'package:doctory/core/error/error_handler.dart';
import 'package:doctory/core/network/interfaces/api_consumer.dart';
import 'package:doctory/features/ads/data/data_source/ads_remote_data_source.dart';
import 'package:doctory/features/ads/data/model/public_ad_model.dart';

abstract class AdsRepo {
  Future<ApiResult<List<PublicAdModel>>> getActiveAds();
}

class AdsRepoImpl implements AdsRepo {
  final AdsRemoteDataSource _remoteDataSource;

  AdsRepoImpl(this._remoteDataSource);

  @override
  Future<ApiResult<List<PublicAdModel>>> getActiveAds() async {
    try {
      return await _remoteDataSource.getActiveAds();
    } on Exception catch (e) {
      return ApiResult.failure(ErrorHandler.handleException(e));
    }
  }
}