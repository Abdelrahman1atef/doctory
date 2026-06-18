# Medical Appointment Booking API Specification

## 1. Booking Setup
**GET** `/api/v1/doctors/{id}/booking-setup`
**Purpose:** Fetches the configuration for a doctor's booking process, including appointment types and available days.

**Response:** `200 OK`
```json
{
  "data": {
    "doctorId": 1,
    "appointmentTypes": [
      { "id": 1, "name": { "en": "Standard", "ar": "عادي" }, "price": 500, "durationMinutes": 30, "isFollowUp": false },
      { "id": 2, "name": { "en": "Follow-up", "ar": "استشارة" }, "price": 200, "durationMinutes": 15, "isFollowUp": true }
    ],
    "availableDays": [
      { "date": "2026-06-19", "isAvailable": true },
      { "date": "2026-06-20", "isAvailable": true },
      { "date": "2026-06-21", "isAvailable": false }
    ]
  }
}
```

## 2. Available Slots
**GET** `/api/v1/doctors/{id}/slots?date=YYYY-MM-DD`
**Purpose:** Fetches individual time slots for a given day.

**Response:** `200 OK`
```json
{
  "data": {
    "date": "2026-06-19",
    "slots": [
      { "id": 101, "time": "09:00", "isAvailable": true },
      { "id": 102, "time": "09:30", "isAvailable": false },
      { "id": 103, "time": "10:00", "isAvailable": true }
    ]
  }
}
```

## 3. Reserve Slot
**POST** `/api/v1/bookings/reserve`
**Purpose:** Temporarily locks a slot for 10 minutes to allow the user to complete payment.

**Request:**
```json
{
  "doctorId": 1,
  "slotId": 103,
  "patientId": 456,
  "appointmentTypeId": 1,
  "notes": "Pain in left knee"
}
```

**Response:** `201 Created`
```json
{
  "data": {
    "reservationId": "res-987654",
    "expiresAt": "2026-06-18T15:30:00Z",
    "status": "reserved"
  }
}
```

**Errors:**
- `409 Conflict`: Slot already reserved or booked.
- `422 Unprocessable Entity`: Invalid follow-up request (patient has no prior appointment).

## 4. Initiate Payment
**POST** `/api/v1/payments/initiate`
**Purpose:** Initiates the payment gateway process for a reservation.

**Request:**
```json
{
  "reservationId": "res-987654",
  "paymentMethodId": 2
}
```

**Response:** `200 OK`
```json
{
  "data": {
    "paymentId": "pay-12345",
    "gatewayUrl": "https://gateway.example.com/pay/pay-12345",
    "status": "pending"
  }
}
```

## 5. Booking Status
**GET** `/api/v1/bookings/{id}/status`
**Purpose:** Polled by the client to verify if the server-to-server webhook has confirmed the payment and the reservation became a confirmed booking.

**Response:** `200 OK`
```json
{
  "data": {
    "bookingId": "bk-111222",
    "status": "confirmed",
    "receiptUrl": "https://api.example.com/receipts/bk-111222.pdf"
  }
}
```
