/// App-wide spacing, padding and radius tokens.
///
/// The scale is **closed**: need an off-scale value? Round to the nearest
/// token instead of adding one. Naming is the value — `s16` is 16dp of
/// spacing, `r12` is a 12dp radius.
class AppSpacing {
  AppSpacing._();

  // ---------------------------------------------------------------- spacing
  static const double s2 = 2;
  static const double s3 = 3;
  static const double s4 = 4;
  static const double s6 = 6;
  static const double s8 = 8;
  static const double s10 = 10;
  static const double s12 = 12;
  static const double s16 = 16;
  static const double s20 = 20;
  static const double s24 = 24;
  static const double s32 = 32;
  static const double s40 = 40;
  static const double s48 = 48;
  static const double s56 = 56;
  static const double s64 = 64;

  // ---------------------------------------------------------------- radii
  static const double r4 = 4;
  static const double r8 = 8;
  static const double r10 = 10;
  static const double r12 = 12;
  static const double r14 = 14;
  static const double r16 = 16;
  static const double r20 = 20;
  static const double r24 = 24;

  /// Fully rounded — use for pills and circular chips.
  static const double rPill = 999;

  // ---------------------------------------------------------------- roles
  /// Standard horizontal margin for most screens.
  static const double screenPadding = s16;

  /// Default bottom padding for screens, to clear the navigation bar.
  static const double screenBottomPadding = s24;

  /// Deprecated alias kept for existing call sites.
  static const double horizontalPadding = screenPadding;
}
