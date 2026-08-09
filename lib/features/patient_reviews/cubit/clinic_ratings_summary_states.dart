abstract class ClinicRatingsSummaryStates {}

class ClinicRatingsSummaryInitial extends ClinicRatingsSummaryStates {}

class ClinicRatingsSummaryLoading extends ClinicRatingsSummaryStates {}

class ClinicRatingsSummaryLoaded extends ClinicRatingsSummaryStates {
  final double clinicAverage;
  final int clinicCount;
  final double receptionAverage;
  final int receptionCount;
  final double cleanlinessAverage;
  final int cleanlinessCount;

  ClinicRatingsSummaryLoaded({
    required this.clinicAverage,
    required this.clinicCount,
    required this.receptionAverage,
    required this.receptionCount,
    required this.cleanlinessAverage,
    required this.cleanlinessCount,
  });
}

class ClinicRatingsSummaryError extends ClinicRatingsSummaryStates {
  final String message;
  ClinicRatingsSummaryError(this.message);
}