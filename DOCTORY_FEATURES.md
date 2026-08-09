# Doctory — App Features (Product Owner Guide)

> A simple, non-technical walkthrough of everything the Doctory app does today.

---

## 1. What Is Doctory?

Doctory is a mobile app that helps people **find doctors and clinics nearby, book appointments, chat with medical professionals, and manage their healthcare** — all from their phone.

The app serves **three types of users**:

| User Type | What they can do |
|---|---|
| 🧑‍🤝‍🧑 **Patients** | Find clinics on a map, view doctors, book appointments, pay online, chat, write reviews, read medical posts |
| 👨‍⚕️ **Doctors (freelance)** | Own a profile, get booked by patients, chat, post to the community |
| 🏥 **Clinic owners & staff** | Run a clinic dashboard, accept/reject booking requests, see visits & income stats |

The app is **bilingual (Arabic / English)**, and works like a typical marketplace: patients book, clinics confirm.

---

## 2. First Use & Onboarding (New Users)

1. **Welcome screen** — the user taps "Start Now".
2. **Language choice** — pick Arabic or English (asked once on first launch).
3. **Introduction slides** — 3 simple slides: *Discover* clinics, *Book* appointments, *Compare* doctors.
4. **Location permission** — the app asks to know the user's location so it can show nearby clinics (the user can skip; the app then defaults to Mansoura).

---

## 3. Sign Up & Login (Auth)

### Create an account
Sign up as one of **3 types**:
- **User (patient)** — name, email, phone, password, birth date, gender.
- **Freelance doctor** — everything above **plus**: bio, years of experience, specialization, photo, professional practice card, and medical union/syndicate ID (uploaded as images).
- **Clinic** — same as doctor, **plus** a tax card; after registering, the clinic owner completes a **Clinic Profile** (name, location on map, working hours for each weekday, logo, description).

### Login
- Email + password, **or** Google, **or** Facebook.
- After login, the app sends the user to the right place automatically:
  - Patient → Home
  - Doctor → Home
  - Clinic owner → Clinic Dashboard (or a "pending approval" / "profile not complete" screen when applicable)

### Other auth features
- **OTP verification** — a code is sent by email to verify the account (also used to reset passwords).
- **Forgot / Reset password** — email → verification code → set a new password.
- **Complete profile** — lets users finish missing personal details.

---

## 4. Main Screen Tabs (after login)

The app has **5 tabs** at the bottom:

| Tab | Purpose |
|---|---|
| 🏠 **Home** | Greeting + personalized content, ads carousel, quick search, famous specialties, recommended doctors & featured clinics |
| 🗺️ **Map / Clinic Locator** | Find nearby clinics on a Google Map |
| 📅 **My Appointments** | All booked appointments with status (pending, confirmed, cancelled…) |
| 💬 **Chat** | Messages with doctors & clinics |
| ☰ **More** | Profile, community, delete account, logout |

---

## 5. Home Screen

- **Greeting header** with the user's name and a notification bell (shows unread badge).
- **Ads carousel** — rotating promotional banners (auto-play every 4 seconds); tapping an ad opens the advertised clinic's page.
- **Search bar** — type a clinic name or specialty; results open on the map.
- **Famous specialties grid** — e.g., heart, teeth, eyes… tap one to see related clinics on the map.
- **Featured doctors & clinics** — hand-picked recommendations.
- Pull down to refresh.

---

## 6. Find a Clinic (Map / Clinic Locator) ⭐ Core Feature

The heart of the app:

1. **Map view** — clinics appear as colored markers. Registered clinics (bookable in-app) are shown differently from unregistered ones (found via map data, info only).
2. **Search & filters** — search by name, filter by **specialty**, radius (**1–50 km**), or "nearest first". The user can even **pick a custom location** on the map to search around it.
3. **Clinic cards** — a bottom sheet lists nearby clinics with distance from the user.
4. **Navigation mode** ⭐ — tap a clinic and the app shows a **live route with turn-by-turn navigation**: distance, duration, and real-time updates as the user moves.
5. **Tap a registered clinic** → opens its details page.

---

## 7. Clinic Details Page

- **Photos / logo** header, clinic name, specialty, owner name.
- **Rating** with a breakdown: *cleanliness, doctor behavior, reception* — plus a link to read all patient reviews.
- **Contact info**: address, phone, email, website.
- **Weekly working hours** — each weekday shown with **Open / Closed** status.
- **Doctors list** — horizontal carousel; tap a doctor to open their profile.
- **"Book Appointment"** button → starts the booking flow.

---

## 8. Doctor Details Page

- Profile photo with a **verified badge** for freelance doctors.
- Specialty, clinic name, **experience (years)**, **rating**.
- **About section** — bio + qualifications.
- **Weekly availability** — which days/hours the doctor works.
- **Recent reviews** — last 3 ratings with comments.
- **"Book Appointment"** button.

---

## 9. Booking an Appointment ⭐ Core Feature

A simple **6-step wizard**:

1. **Type of visit** — *In-person* or *Follow-up*.
2. **Patient info** — name, age, gender, complaint, optional chronic diseases.
3. **Pick a date** — a 30-day calendar; only the doctor's working days are selectable.
4. **Pick a time** — available time slots grouped into *Morning / Afternoon / Evening*.
5. **Review** — summary of doctor, date, time, fee, and patient details.
6. **Done!** — booking confirmed with a **reference number**. Status starts as **"Pending"** until the clinic accepts it.

---

## 10. My Appointments

- **Status tabs**: Pending, Awaiting Payment, Confirmed, Completed, Cancelled, Rejected.
- **Appointment details page** — full info: doctor, clinic, date/time, patient details, complaint, booking reference, and amount.
- **Pay online** 💳 — accepted appointments can be paid in-app through a secure payment web page.
- **Cancel** — with a cancellation reason (allowed for pending appointments, and within 2 hours of paying for confirmed ones).
- Infinite scrolling list + pull-to-refresh.

---

## 11. Chat (Messaging) 💬

Full messaging between patients and doctors/clinics:

- **Conversations list** — most recent first, unread count badges, last message preview.
- **Chat room** — text messages with:
  - **Attachments**: images, videos, files, and **voice messages** (record directly in chat).
  - **Replies** to a specific message.
  - **Typing indicator**, **online status**, and read/delivered ticks.
- **New chat** — search for a user by name and start a conversation.
- **Real-time** — new messages, typing, and read receipts arrive instantly, no refresh needed.

---

## 12. Community (Social Feed) 📰

A doctor/patient social network inside the app:

- **Post feed** — infinite scrolling, pull-to-refresh, photos/videos in posts.
- **Create a post** — text + up to **10 images/videos/audio/files**, all compressed automatically in the background; upload continues even if the user leaves the screen.
- **Reactions** — 6 types (like, love, haha, wow, sad, angry).
- **Comments** — write, edit, delete, like, and reply to comments.
- **Post options** — *Start conversation* with the author (jumps into chat) and *Copy link* (share the post outside the app; opening the link opens the post directly).
- **Author profiles** — tapping a doctor's avatar opens their profile; tapping a clinic opens the clinic page.

---

## 13. Reviews & Ratings ⭐

- **View reviews** — overall rating + sub-ratings (cleanliness / doctor behavior / reception) with written comments.
- **Write a review** — rate all 3 aspects (all required) + optional comment; the overall score is the average of the three.
- Available on both **clinic pages** and **doctor pages**.

---

## 14. Notifications 🔔

- **Real-time push notifications** (phone notifications) for:
  - Appointment reminders, confirmations, cancellations
  - New chat messages
  - Payment confirmations
  - System announcements
- **In-app notification center** — paginated list with read/unread state.
- Tapping a notification **jumps to the right place** — the chat room, the appointment details, etc.

---

## 15. Specializations (Specialties)

- **Full list of medical specialties** — paginated, searchable scan through all of them.
- Tapping any specialty opens the **map** filtered to clinics of that specialty.

---

## 16. More Tab (Profile & Settings)

- **Personal profile** — edit name, phone, birth date, gender, and change profile photo.
- **Logout** — with confirmation; clears the app safely.
- **Delete account** — permanent deletion with confirmation.

---

## 17. Clinic Owner Dashboard 🏥

For clinic owners only (after login):

- **3 stat cards**: Today's visits, Today's income (EGP), Pending actions.
- **Period overview**: visits & income for the **week / month / year**.
- **Booking requests inbox**: filter by status (Pending / Accepted / Rejected); each request shows patient info with **Accept / Reject** buttons.
- **Request details sheet**: full patient details — phone, age, clinic, doctor, date/time, appointment type, reason.
- **"Pending approval" screen** — shown while the clinic account waits for platform approval.

---

## 17.5. Deep Links & Shared Content 🔗

- Links like `doctory://post/123` open posts directly from outside the app.
- Ad banners and shared posts deep-link into the right screens.

---

## 18. Summary — The Big Picture

```
Patient journey:  Browse → Search on map → Clinic details → Doctor details
                  → Book appointment (6 steps) → Wait for clinic acceptance
                  → Pay online → Get reminders → Chat → Leave a review

Clinic journey:   Register clinic → Complete profile → Wait for approval
                  → Dashboard (visits & income) → Accept/reject bookings

All users:        Community posts, real-time chat, notifications, bilingual AR/EN
```

---

## 19. Known Notes / Not Yet Connected

| Area | Status |
|---|---|
| Submitting a review | Simulated locally — not sent to the server yet |
| Online appointment type | Hidden in the UI (prepared, not active) |
| Cancelling own posts | UI option exists, backend call not wired |
| Admin panel | Exists but uses demo data (out of scope for this doc) |