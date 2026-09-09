/// A day of the week as the API reports it.
///
/// The backend is inconsistent about the shape: some endpoints send the English
/// name (`"Sunday"`), others send the numeric index (`"0"`). [fromApi] accepts
/// either, and [labelKey] is the translation key so the UI never renders the
/// raw English value.
enum WeekDay {
  sunday('Sunday'),
  monday('Monday'),
  tuesday('Tuesday'),
  wednesday('Wednesday'),
  thursday('Thursday'),
  friday('Friday'),
  saturday('Saturday');

  const WeekDay(this.apiName);

  /// The English name the API uses for this day.
  final String apiName;

  /// Translation key for the localized day name (e.g. 'sunday').
  String get labelKey => name;

  /// Parses an API `dayOfWeek` value, accepting either the English name
  /// (case-insensitive) or the 0-6 index, where 0 is Sunday. Returns null when
  /// the value matches neither.
  static WeekDay? fromApi(String? value) {
    if (value == null || value.isEmpty) return null;

    final index = int.tryParse(value);
    if (index != null) {
      return index >= 0 && index < WeekDay.values.length
          ? WeekDay.values[index]
          : null;
    }

    final normalized = value.trim().toLowerCase();
    for (final day in WeekDay.values) {
      if (day.name == normalized) return day;
    }
    return null;
  }

  /// Translation key for an API `dayOfWeek` value, falling back to the raw
  /// value when it is not a day this enum recognizes.
  static String labelKeyFor(String? value) =>
      fromApi(value)?.labelKey ?? (value ?? '');
}
