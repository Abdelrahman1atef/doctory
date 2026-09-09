/// Carries state across the payment round trip to the gateway.
///
/// Two things have to survive the hop out to the gateway and back:
///
/// * the appointment id — the return URL
///   (`doctory://payment-result?success=…&order=…`) carries the gateway's own
///   order id, not ours, so the deep link handler has no other way to know
///   which appointment to reopen;
/// * the payment id to verify — the deep link handler cannot run the verify
///   call itself (it has no cubit instance bound to the UI), so it parks the
///   id here for the details screen to pick up once it is on screen.
abstract class PendingPayment {
  static String? _appointmentId;
  static String? _paymentIdToVerify;

  static String? get appointmentId => _appointmentId;

  /// True when a gateway return is waiting to be verified against the server.
  static bool get hasPaymentToVerify => _paymentIdToVerify != null;

  /// Recorded by the details screen before it hands off to the payment webview.
  static void start(String appointmentId) {
    _appointmentId = appointmentId;
    _paymentIdToVerify = null;
  }

  /// Recorded by the deep link handler when the gateway returns.
  static void awaitVerification(String paymentId) {
    _paymentIdToVerify = paymentId;
  }

  /// Returns the appointment id and clears it, so a stale id never survives
  /// into a later payment attempt.
  static String? consumeAppointmentId() {
    final id = _appointmentId;
    _appointmentId = null;
    return id;
  }

  /// Returns the payment id awaiting verification and clears it.
  static String? consumePaymentId() {
    final id = _paymentIdToVerify;
    _paymentIdToVerify = null;
    return id;
  }

  static void clear() {
    _appointmentId = null;
    _paymentIdToVerify = null;
  }
}
