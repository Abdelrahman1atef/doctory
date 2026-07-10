import '../../data/model/payment_model.dart';

sealed class AdminPaymentsState {}

class AdminPaymentsInitial extends AdminPaymentsState {}

class AdminPaymentsLoading extends AdminPaymentsState {}

class AdminPaymentsLoaded extends AdminPaymentsState {
  final List<AdminPaymentModel> items;
  AdminPaymentsLoaded(this.items);
}

class AdminPaymentsError extends AdminPaymentsState {
  final String message;
  AdminPaymentsError(this.message);
}
