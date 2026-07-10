import '../../data/model/ad_model.dart';

sealed class AdminAdsState {}

class AdminAdsInitial extends AdminAdsState {}

class AdminAdsLoading extends AdminAdsState {}

class AdminAdsLoaded extends AdminAdsState {
  final List<AdminAdModel> items;
  AdminAdsLoaded(this.items);
}

class AdminAdsError extends AdminAdsState {
  final String message;
  AdminAdsError(this.message);
}
