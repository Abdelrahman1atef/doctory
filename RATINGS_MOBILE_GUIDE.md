# 📱 Ratings — Mobile App Integration Guide (Patient App)

> What the **patient mobile app** needs to do to let patients rate their visit. The backend is **fully implemented** — the mobile team only needs to **consume** the endpoints below. All submission happens in the patient app; viewing/managing happens on the web dashboards (read-only).

---

## 🎯 What the Mobile App Must Do

After a patient completes a visit, show a **rating sheet with 3 sections**:

| Section | `type` | Target field | Example |
|---|---|---|---|
| 1. تقييم الطبيب (Doctor rating) | `1` | `doctorId` | `"doctorId": "..."` |
| 2. تقييم العيادة (Clinic rating) | `2` | `clinicId` | `"clinicId": "..."` |
| 3. نظافة المكان (Place cleanliness) | `3` | `clinicId` | `"clinicId": "..."` |

Each section: **stars (1–5)**. At the end of the sheet, the patient writes **ONE general review text** (optional, max 1000 chars) — it is **shared**: the backend stores the same review text on all three rating rows, so it appears under every section on the web dashboard.

> ✅ **Implemented (Flutter) — current app behavior.** The sheet opens from the **Reviews page** (reachable from **clinic details** and **doctor details** pages):
> - **Clinic page** → shows all **3 sections**; the Doctor section has a **doctor picker dropdown** (from the clinic's doctors list) and is hidden when the clinic has no doctors.
> - **Doctor page** → Doctor section always; Clinic + Place cleanliness sections appear when the doctor belongs to a clinic (from the doctor's `clinicId`).
> - Each section currently sends its **own comment** (optional, ≤1000 chars) via the **legacy per-section** `POST /ratings` — the *shared ONE general review* above belongs to the **batch** endpoint, which the app has **not adopted yet** (see Suggested UX Flow).

> ⚠️ **`type` is an integer, not a string** — the backend uses default JSON enum serialization (`1` / `2` / `3`), there is **no** `JsonStringEnumConverter`. Sending `"type": "Clinic"` fails with a 400.

---

## 📡 Endpoints

| Method | Endpoint | Auth | Purpose |
|---|---|---|---|
| `POST` | `{base}/api/v1/ratings/batch` | ✅ Bearer (any authenticated role) | **Submit all sections + ONE general review in a single call** (recommended for new builds) |
| `POST` | `{base}/api/v1/ratings` | ✅ Bearer | Submit one rating row (legacy, per-section) |
| `GET` | `{base}/api/v1/doctors/{doctorId}/ratings` | ✅ Bearer | List doctor ratings (type=1) |
| `GET` | `{base}/api/v1/clinics/{clinicId}/ratings` | ✅ Bearer | List clinic ratings (type=2) |
| `GET` | `{base}/api/v1/clinics/{clinicId}/place-cleanliness-ratings` | ✅ Bearer | List cleanliness ratings (type=3) |

> The GET endpoints are also used by the web dashboard. The patient app **currently** consumes them to render the reviews page (doctor page → `doctors/{doctorId}/ratings`; clinic page → `clinics/{clinicId}/ratings` **+** `place-cleanliness-ratings`, merged and deduped by id) and submits with the **legacy** `POST /ratings` (one call per section). `POST /ratings/batch` is **not adopted yet**. The doctor/clinic averages are already returned by the existing mobile doctor-details endpoint (`GET /doctors/{doctorId}/details` → `averageRating`).

---

## 🧾 Submit All Ratings + General Review — `POST {base}/api/v1/ratings/batch`

Creates **all three rating rows atomically** (one DB transaction) with the same `review` text. If any section was already rated by the user → **400** and nothing is saved.

**Request:**
```json
{
  "doctorId": "3f9a0000-0000-0000-0000-000000000001",
  "clinicId": null,
  "doctorValue": 5,
  "clinicValue": 4,
  "cleanlinessValue": 4,
  "review": "تجربة ممتازة عموماً، دكتور راقي والعيادة نظيفة"
}
```

> `doctorId` is **optional**: if omitted, the doctor section is skipped and only clinic + cleanliness rows are created (`clinicId` then becomes required).

**Response (`ApiResponse<List<RatingDto>>`, HTTP 201):**
```json
{
  "success": true,
  "message": "تم إرسال التقييم بنجاح",
  "data": [
    {
      "id": "7d1c0000-0000-0000-0000-000000000009",
      "type": 1,
      "userId": "2f9a0000-0000-0000-0000-000000000004",
      "userName": "محمد أحمد",
      "doctorId": "3f9a0000-0000-0000-0000-000000000001",
      "clinicId": null,
      "value": 5,
      "review": "تجربة ممتازة عموماً، دكتور راقي والعيادة نظيفة",
      "createdAt": "2026-08-09T21:10:00"
    },
    {
      "id": "7d1c0000-0000-0000-0000-00000000000a",
      "type": 2,
      "userId": "2f9a0000-0000-0000-0000-000000000004",
      "userName": "محمد أحمد",
      "doctorId": null,
      "clinicId": "4a1c0000-0000-0000-0000-000000000002",
      "value": 4,
      "review": "تجربة ممتازة عموماً، دكتور راقي والعيادة نظيفة",
      "createdAt": "2026-08-09T21:10:00"
    },
    {
      "id": "7d1c0000-0000-0000-0000-00000000000b",
      "type": 3,
      "userId": "2f9a0000-0000-0000-0000-000000000004",
      "userName": "محمد أحمد",
      "doctorId": null,
      "clinicId": "4a1c0000-0000-0000-0000-000000000002",
      "value": 4,
      "review": "تجربة ممتازة عموماً، دكتور راقي والعيادة نظيفة",
      "createdAt": "2026-08-09T21:10:00"
    }
  ]
}
```

### Field rules

| Field | Type | Required | Notes |
|---|---|---|---|
| `doctorId` | Guid string | per section | required **only when** `doctorValue` is sent; must be a **Doctor entity id** |
| `clinicId` | Guid string | if no doctor | required when `doctorId` is omitted; ignored when `doctorId` is sent (clinic is derived from the doctor) |
| `doctorValue` | int | per section | 1–5, must be provided if `doctorId` is sent |
| `clinicValue` | int | ✅ | 1–5 |
| `cleanlinessValue` | int | ✅ | 1–5 |
| `review` | string | optional | **ONE general review** shared across all sections, max 1000 chars |

### Rules & duplicates

- All three rows are created **together or not at all** (single transaction).
- **Only after a completed visit**: the backend requires at least one **completed appointment** (`AppointmentStatus.Completed`) booked by the same user for the rated doctor/clinic — rating without a completed visit returns HTTP 400 "لا يمكنك التقييم إلا بعد زيارة مكتملة" (`Ratings.NoCompletedVisit`). (Applies to the legacy `POST /ratings` too.)
- **Self-rating is blocked**: a doctor's own user account cannot rate their own profile (HTTP 400 "لا يمكنك تقييم نفسك").
- The clinic must be **active** (`IsActive = true`) — otherwise HTTP 404.
- The same patient may rate the **same doctor only once** and the **same clinic section only once** — a second attempt returns HTTP 400 "لقد قمت بتقييم هذا العنصر مسبقاً" (`Ratings.AlreadyRated`) and **nothing** is saved.
- There is **no update or delete endpoint** — if already rated, show the "already rated" state instead of the form.

---

## 🧾 Legacy Endpoint — `POST {base}/api/v1/ratings` (one section per call)

Kept for backward compatibility with old builds. If `type` is **omitted**, the backend infers it:

```
IF doctorId != null  → type = 1 (Doctor)
ELSE                 → type = 2 (Clinic)
```

The new app should **always use `/ratings/batch`** instead.

---

## ❌ Error Responses

All errors are wrapped in `ApiResponse<T>` and localized by the `Accept-Language` request header (send `ar` for Arabic):

```json
{
  "success": false,
  "message": "لقد قمت بتقييم هذا العنصر مسبقاً",
  "statusCode": 400
}
```

| HTTP | Localization key | Arabic message |
|---|---|---|
| 400 | `Ratings.TargetRequired` | يجب تحديد طبيب أو عيادة للتقييم |
| 400 | `Ratings.InvalidValue` | قيمة التقييم يجب أن تكون بين 1 و 5 |
| 400 | `Ratings.DoctorValueRequired` | يجب تحديد قيمة تقييم الطبيب عند تقييم طبيب |
| 400 | `Ratings.DoctorTargetRequired` | يجب تحديد الطبيب عند إرسال قيمة تقييم للطبيب |
| 400 | `Ratings.AlreadyRated` | لقد قمت بتقييم هذا العنصر مسبقاً |
| 400 | `Ratings.NoCompletedVisit` | لا يمكنك التقييم إلا بعد زيارة مكتملة |
| 400 | `Ratings.CannotRateSelf` | لا يمكنك تقييم نفسك |
| 404 | `DoctorMessages.NotFound` | الطبيب غير موجود |
| 404 | `ClinicMessages.ClinicNotFound` | العيادة غير موجودة (أو غير فعّالة) |
| 401 | — | missing/expired bearer token |
| 429 | — | rate limited (max 10 rating requests/min/IP) |

---

## 🧭 Where Do `doctorId` / `clinicId` Come From?

- **`clinicId`** — the id of the clinic the patient visited (already available in the booking/appointment object).
- **`doctorId`** — the **Doctor entity id**, NOT the user id. It is the same `id` the patient gets from:
  - the booking confirmation (`appointment.doctorId`), or
  - the doctor's public profile (`GET /doctors/{doctorId}/details` — the same id used in the URL).

Never try to convert a user id into a doctor id client-side — they are different.

---

## 🧰 Model (Kotlin / Swift)

```kotlin
data class SubmitClinicRatingsRequest(
    val doctorId: String?,     // optional — omit to skip the doctor section
    val clinicId: String?,     // required only when doctorId is null
    val doctorValue: Int?,     // 1..5, required when doctorId is sent
    val clinicValue: Int,      // 1..5
    val cleanlinessValue: Int, // 1..5
    val review: String?        // ONE general review shared across all sections (max 1000)
)

data class RatingDto(
    val id: String,
    val type: Int,
    val userId: String,
    val userName: String?,
    val doctorId: String?,
    val clinicId: String?,
    val value: Int,
    val review: String?,
    val createdAt: String
)
```

> ⚠️ Do **not** mark `userName` / `review` / `doctorId` / `clinicId` as non-null — the JSON always contains the keys but the values can be `null`.

---

## 📱 Suggested UX Flow

> **Implemented in Flutter** (current behavior):

1. Entry: the patient opens the **Reviews page** from the clinic/doctor details screen. (Gating the sheet behind a **completed visit** is not implemented yet — see "Not yet adopted" below.)
2. Sections are rendered per entity (as in "What the Mobile App Must Do"): clinic page → doctor picker + clinic + cleanliness; doctor page → doctor section, plus clinic + cleanliness when the doctor has a linked clinic.
3. Each section = star selector (1–5) + its **own optional comment box** (≤1000 chars).
4. On submit → **one `POST /ratings` per rated section**, sent **sequentially and silently** (no loading spinner; button stays enabled, re-entry guarded; doctor section on clinic pages skips without a picked doctor).
5. On `AlreadyRated` (400) → that section switches to **read-only** with "لقد قمت بتقييم هذا العنصر مسبقاً" and stays locked; sections the user already rated are **pre-locked on open** (derived from the ratings list by matching `userId`).
6. After any successful submission → the list **refreshes silently** (no loading flash; the current list is kept if the refresh fails).
7. **Pull-to-refresh** on the list — silent when data is loaded, full reload from the error state.
8. All pending sections submitted successfully → green success snackbar + the sheet closes; only `AlreadyRated` → orange snackbar; any failure → red snackbar with the server message (sheet stays open).

> 🔲 **Not yet adopted** (contract is ready server-side): `POST /ratings/batch` (one call + ONE shared review + thank-you screen), completed-visit gating (`NoCompletedVisit`), `CannotRateSelf` / `NoCompletedVisit` surfaced as distinct validation errors, and 429 back-off.

---

## 🚫 What the Mobile App Does NOT Do

- ❌ No update / delete of ratings — the backend has **no** such endpoints.
- ❌ No creating doctors/clinics — ids come from existing booking/profile data.
- ❌ No rating without authentication — the token is required.
- ❌ No string enum values — always send `type`/values as int (`1`/`2`/`3`).

---

## ✅ Mobile Checklist

> Status reflects the **current Flutter app**. API contract items stay valid regardless.

| # | Item | Status | Mobile reference |
|---|---|---|---|
| 1 | Send `Accept-Language: ar` (or `en`) on all rating calls | ✅ done | set globally by `DioConsumer` (`lib/core/network/impl/dio_consumer.dart`) |
| 2 | Use `POST /ratings/batch` (one call, one general review) | 🔲 not adopted | app currently uses legacy `POST /ratings`, one call per section (`PatientReviewsRemoteDataSourceImpl.submitRating`) |
| 3 | Only show the rating sheet **after a completed visit** | 🔲 not implemented | sheet opens from the Reviews page; no visit-completion check |
| 4 | Validate client-side: values 1–5, `review` ≤ 1000 chars | ✅ done | `value.clamp(1, 5)` in `PatientReviewsCubit.submitSection`; `maxLength: 1000` on comment fields |
| 5 | Handle HTTP 400 `AlreadyRated` → "already rated" state, no retry | ✅ done | `BadRequestFailure` → `RatingSubmitResult.alreadyRated` → section locked read-only + orange snackbar; sections pre-locked on open from list (`userId` match) |
| 6 | Handle `NoCompletedVisit` / `CannotRateSelf` as distinct validation errors | ⚠️ partial | any 400 is mapped to the already-rated outcome; messages not distinguished yet |
| 7 | Handle 401 → re-auth; 429 → back off and retry | ⚠️ partial | 401 handled by the app-wide auth interceptor; 429 has no special handling |
| 8 | Use the **Doctor entity id** (from booking/profile) — not the user id | ✅ done | `DoctorModel.id` (same id as `/doctors/{id}`) or the doctor picked from the clinic list; `UserSession.doctorId` is stored but not used for rating |
| 9 | If the visit had no doctor, omit `doctorId`/`doctorValue` and send `clinicId` | ✅ done | doctor section is hidden when the clinic has no doctors / the doctor has no linked clinic |
