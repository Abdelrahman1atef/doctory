import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/admin_repo.dart';
import '../../data/model/specialization_model.dart';
import 'admin_specializations_states.dart';

class AdminSpecializationsCubit extends Cubit<AdminSpecializationsState> {
  final AdminRepo _repo;
  List<AdminSpecializationModel> _all = [];
  String _query = '';
  String _statusFilter = '';

  AdminSpecializationsCubit(this._repo) : super(AdminSpecializationsInitial());

  void load() async {
    emit(AdminSpecializationsLoading());
    final result = _repo.getSpecializations();
    result.fold(
      onSuccess: (items) {
        _all = items;
        _applyFilter();
      },
      onFailure: (f) => emit(AdminSpecializationsError(f.message)),
    );
  }

  void add(AdminSpecializationModel item) {
    _all = [item, ..._all];
    _applyFilter();
  }

  void update(AdminSpecializationModel item) {
    _all = _all.map((e) => e.id == item.id ? item : e).toList();
    _applyFilter();
  }

  void toggleStatus(String id) {
    _all = _all.map((e) {
      if (e.id == id) return e.copyWith(isActive: !e.isActive);
      return e;
    }).toList();
    _applyFilter();
  }

  void filter(String query, String status) {
    _query = query;
    _statusFilter = status;
    _applyFilter();
  }

  void _applyFilter() {
    var filtered = _all.where((s) {
      final matchSearch = _query.isEmpty ||
          s.name.toLowerCase().contains(_query.toLowerCase()) ||
          s.nameAr.contains(_query);
      final matchStatus = _statusFilter.isEmpty ||
          (_statusFilter == 'active' && s.isActive) ||
          (_statusFilter == 'inactive' && !s.isActive);
      return matchSearch && matchStatus;
    }).toList();
    emit(AdminSpecializationsLoaded(filtered));
  }
}
