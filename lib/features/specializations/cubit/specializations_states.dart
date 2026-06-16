import 'package:doctory/core/common/models/specialty_model.dart';

abstract class SpecializationsStates {}

class SpecializationsInitialState extends SpecializationsStates {}

class SpecializationsLoadingState extends SpecializationsStates {
  final List<SpecialtyModel> oldItems;
  final bool isFirstFetch;

  SpecializationsLoadingState(this.oldItems, {this.isFirstFetch = false});
}

class SpecializationsSuccessState extends SpecializationsStates {
  final List<SpecialtyModel> items;
  final bool hasNextPage;

  SpecializationsSuccessState({
    required this.items,
    required this.hasNextPage,
  });
}

class SpecializationsErrorState extends SpecializationsStates {
  final String message;

  SpecializationsErrorState(this.message);
}
