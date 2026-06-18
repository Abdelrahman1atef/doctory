enum BookingStatus {
  pending('pending'),
  reserved('reserved'),
  confirmed('confirmed'),
  completed('completed'),
  cancelled('cancelled'),
  noShow('no_show');

  final String value;

  const BookingStatus(this.value);

  factory BookingStatus.fromValue(String value) {
    return BookingStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => BookingStatus.pending,
    );
  }
}
