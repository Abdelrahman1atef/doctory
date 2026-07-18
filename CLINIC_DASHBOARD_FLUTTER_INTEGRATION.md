# Clinic Dashboard — Flutter Integration Guide

Integrates the 4 dashboard endpoints under `/api/v1/admin/clinics/`. All require a **JWT bearer token** from a user with `ClinicOwner` or similar authorized role. The JWT must include a `ClinicId` claim (added at login) — responses are automatically scoped to that clinic.

## Base URL

```
https://your-api-domain.com/api/v1
```

All endpoints share the prefix `/admin/clinics`.

## Common Response Envelope

Every response is wrapped in `ApiResponse<T>`:

```json
{
  "success": true,
  "data": { ... },
  "message": "...",
  "statusCode": 200,
  "errors": {}
}
```

On error `success` is `false` and `errors` contains validation/error details.

---

## 1. Dashboard Stats

Fetches visit counts and income broken down by today / week / month / year, plus pending actions count.

```
GET /admin/clinics/dashboard/stats
```

**Headers:** `Authorization: Bearer <token>`

**Response — `data`:**

```json
{
  "todayVisits": 12,
  "todayIncome": 540.00,
  "weeklyVisits": 48,
  "weeklyIncome": 2250.00,
  "monthlyVisits": 185,
  "monthlyIncome": 8900.00,
  "yearlyVisits": 1240,
  "yearlyIncome": 62300.00,
  "pendingActions": 7
}
```

- Visits count completions (`AppointmentStatus.Completed`).
- Income sums `Payment.Amount` where `Payment.Status == Paid`.
- `pendingActions` is the count of appointments with `Pending` status.

**Dart example:**

```dart
class DashboardStats {
  final int todayVisits;
  final double todayIncome;
  final int weeklyVisits;
  final double weeklyIncome;
  final int monthlyVisits;
  final double monthlyIncome;
  final int yearlyVisits;
  final double yearlyIncome;
  final int pendingActions;

  DashboardStats.fromJson(Map<String, dynamic> json)
      : todayVisits = json['todayVisits'],
        todayIncome = (json['todayIncome'] as num).toDouble(),
        weeklyVisits = json['weeklyVisits'],
        weeklyIncome = (json['weeklyIncome'] as num).toDouble(),
        monthlyVisits = json['monthlyVisits'],
        monthlyIncome = (json['monthlyIncome'] as num).toDouble(),
        yearlyVisits = json['yearlyVisits'],
        yearlyIncome = (json['yearlyIncome'] as num).toDouble(),
        pendingActions = json['pendingActions'];
}

Future<DashboardStats> fetchDashboardStats() async {
  final response = await dio.get('/admin/clinics/dashboard/stats');
  return DashboardStats.fromJson(response.data['data']);
}
```

---

## 2. Get Clinic Bookings

Paginated list of bookings for the current clinic, filterable by status.

```
GET /admin/clinics/bookings?status=pending&pageNumber=1&pageSize=20
```

**Query parameters:**

| Param      | Type   | Default | Description                                        |
|-----------|--------|---------|----------------------------------------------------|
| `status`  | string | —       | Filter: `pending`, `accepted`, `rejected`. Omit for all. |
| `pageNumber` | int | 1       | Page index (1-based)                                |
| `pageSize`   | int | 20      | Items per page (max 100)                            |

**Response — `data` format (paginated):**

```json
{
  "items": [
    {
      "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
      "patientName": "أحمد محمد",
      "patientPhone": "01012345678",
      "patientAge": 32,
      "clinicName": "عيادة الأسنان الحديثة",
      "doctorName": "د. سارة أحمد",
      "requestedDate": "2026-07-18",
      "requestedTime": "10:30 AM",
      "reason": "ألم في الضرس",
      "appointmentType": "inPerson",
      "status": "pending",
      "createdAt": "2026-07-17T14:30:00Z"
    }
  ],
  "pageNumber": 1,
  "pageSize": 20,
  "totalPages": 3,
  "totalCount": 42,
  "hasPreviousPage": false,
  "hasNextPage": true
}
```

**Field details:**

| Field             | Type     | Notes                                          |
|------------------|----------|------------------------------------------------|
| `appointmentType` | string   | `inPerson` (Examination) or `followUp`         |
| `status`         | string   | `pending`, `accepted`, or `rejected`            |
| `requestedDate`  | string   | `yyyy-MM-dd` format                             |
| `requestedTime`  | string   | `hh:mm tt` format (12h with AM/PM)              |

**Dart example:**

```dart
class PaginatedBookings {
  final List<ClinicBooking> items;
  final int pageNumber;
  final int pageSize;
  final int totalPages;
  final int totalCount;
  final bool hasNextPage;

  PaginatedBookings.fromJson(Map<String, dynamic> json)
      : items = (json['items'] as List).map((e) => ClinicBooking.fromJson(e)).toList(),
        pageNumber = json['pageNumber'],
        pageSize = json['pageSize'],
        totalPages = json['totalPages'],
        totalCount = json['totalCount'],
        hasNextPage = json['hasNextPage'];
}

class ClinicBooking {
  final String id;
  final String patientName;
  final String patientPhone;
  final int patientAge;
  final String clinicName;
  final String doctorName;
  final String requestedDate;
  final String requestedTime;
  final String reason;
  final String appointmentType;
  final String status;
  final DateTime createdAt;

  ClinicBooking.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        patientName = json['patientName'],
        patientPhone = json['patientPhone'],
        patientAge = json['patientAge'],
        clinicName = json['clinicName'],
        doctorName = json['doctorName'],
        requestedDate = json['requestedDate'],
        requestedTime = json['requestedTime'],
        reason = json['reason'],
        appointmentType = json['appointmentType'],
        status = json['status'],
        createdAt = DateTime.parse(json['createdAt']);
}

Future<PaginatedBookings> fetchBookings({String? status, int page = 1}) async {
  final params = <String, dynamic>{'pageNumber': page, 'pageSize': 20};
  if (status != null) params['status'] = status;
  final response = await dio.get('/admin/clinics/bookings', queryParameters: params);
  return PaginatedBookings.fromJson(response.data['data']);
}
```

---

## 3. Accept Booking

Accepts a pending (or reserved) booking.

```
POST /admin/clinics/bookings/accept
```

**Request body:**

```json
{
  "bookingId": "3fa85f64-5717-4562-b3fc-2c963f66afa6"
}
```

**Response — `data`:** `true` if accepted.

**Error cases (400 Bad Request):**
- Booking belongs to a different clinic.
- Booking status is not `Pending` or `Reserved` (e.g. already accepted/rejected).
- Booking does not exist (404).

On success, a push notification is sent to the patient via FCM.

**Dart example:**

```dart
Future<bool> acceptBooking(String bookingId) async {
  final response = await dio.post(
    '/admin/clinics/bookings/accept',
    data: {'bookingId': bookingId},
  );
  return response.data['data'] == true;
}
```

---

## 4. Reject Booking

Rejects a pending (or reserved) booking with an optional reason.

```
POST /admin/clinics/bookings/reject
```

**Request body:**

```json
{
  "bookingId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "reason": "الموعد غير متاح"
}
```

`reason` is optional — omit the field or set `null` to reject without a reason.

**Response — `data`:** `true` if rejected.

**Error cases:** Same as accept (clinic mismatch, invalid status).

**Dart example:**

```dart
Future<bool> rejectBooking(String bookingId, {String? reason}) async {
  final response = await dio.post(
    '/admin/clinics/bookings/reject',
    data: {
      'bookingId': bookingId,
      if (reason != null) 'reason': reason,
    },
  );
  return response.data['data'] == true;
}
```

---

## Error Handling Pattern (Flutter)

```dart
import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  ApiException(this.message, {this.statusCode});
}

Future<T> safeApiCall<T>(Future<T> Function() call) async {
  try {
    return await call();
  } on DioException catch (e) {
    final data = e.response?.data;
    final message = data is Map ? data['message'] ?? 'خطأ غير متوقع' : 'خطأ غير متوقع';
    throw ApiException(message, statusCode: e.response?.statusCode);
  }
}
```

---

## Status & AppointmentType Mapping Reference

| Backend Enum           | API Response String |
|------------------------|---------------------|
| `AppointmentStatus.Pending` | `pending`           |
| `AppointmentStatus.Accepted` | `accepted`         |
| `AppointmentStatus.Rejected` | `rejected`         |
| `AppointmentType.Examination` | `inPerson`         |
| `AppointmentType.FollowUp`   | `followUp`         |

For UI localization in Arabic, use these strings directly as display labels or map them:

```dart
String bookingStatusLabel(String status) {
  switch (status) {
    case 'pending':   return 'قيد الانتظار';
    case 'accepted':  return 'مقبول';
    case 'rejected':  return 'مرفوض';
    default:          return status;
  }
}
```
