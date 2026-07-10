import '../../data/model/subscription_model.dart';

sealed class AdminSubscriptionsState {}

class AdminSubscriptionsInitial extends AdminSubscriptionsState {}

class AdminSubscriptionsLoading extends AdminSubscriptionsState {}

class AdminSubscriptionsLoaded extends AdminSubscriptionsState {
  final List<AdminSubscriptionModel> items;
  AdminSubscriptionsLoaded(this.items);
}

class AdminSubscriptionsError extends AdminSubscriptionsState {
  final String message;
  AdminSubscriptionsError(this.message);
}
