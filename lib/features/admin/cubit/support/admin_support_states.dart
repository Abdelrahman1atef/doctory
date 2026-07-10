import '../../data/model/support_ticket_model.dart';

sealed class AdminSupportState {}

class AdminSupportInitial extends AdminSupportState {}

class AdminSupportLoading extends AdminSupportState {}

class AdminSupportLoaded extends AdminSupportState {
  final List<AdminSupportTicketModel> items;
  AdminSupportLoaded(this.items);
}

class AdminSupportError extends AdminSupportState {
  final String message;
  AdminSupportError(this.message);
}
