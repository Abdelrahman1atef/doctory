# Medical Appointment Booking Backend Guide

## Overview
This is the implementation guide for the highly scalable, production-ready Medical Appointment Booking backend. It uses an event-driven, cache-optimized architecture built to handle millions of bookings with zero double-booking issues.

## Tech Stack Recommendations
- **Database**: PostgreSQL (Relational integrity, strong ACID properties)
- **Cache**: Redis (Fast reads for available days, Distributed Locks)
- **Message Broker**: RabbitMQ or Kafka (Async tasks like notifications)
- **Backend**: Node.js/NestJS, Go, or Spring Boot.

## Core Concepts
### 1. Reservation System
Do not allow immediate booking of a slot. Instead, implement a **Reservation Lock**.
- User selects a slot.
- Server validates and creates a `Reservation` with `expiresAt` = `now() + 10 minutes`.
- During this 10-minute window, the slot is locked and hidden from other users.
- If payment succeeds, convert `Reservation` to `Booking`.
- If payment fails or time expires, the slot is released.

### 2. Double-Booking Prevention
Rely on the database to prevent double bookings, not just application code.
- Create a Unique Compound Index in PostgreSQL on `(doctor_id, date, start_time, status)`.
- Use Redis Distributed Locks (Redlock) when creating a reservation to handle concurrent requests.

### 3. Caching Strategy
- **Static Assets**: Specializations, Doctor Profiles, Clinic Details. Cache for 24 hours. Invalidate on update.
- **Semi-Dynamic Assets**: `AvailableDays` (which days have slots). Cache for 5 minutes.
- **Dynamic Assets**: `AvailableSlots`. Read directly from the database or cache with 10-second TTL due to high volatility.

### 4. Background Workers (Cron vs Event-Driven)
Do not use a generic cron job running every minute to clear expired reservations. It will cause DB load spikes.
- **Recommended**: Use Redis Keyspace Notifications. Set a TTL of 10 minutes on the Redis key. When the key expires, an event triggers a worker to mark the reservation as expired in the DB.

## API Performance Notes
- Keep payloads small. Filter data at the database level.
- Use ETag or Last-Modified headers for `/booking-setup` so the app doesn't re-download data if it hasn't changed.
- Implement strict Rate Limiting on the `/bookings/reserve` and `/payments/initiate` endpoints to prevent abuse.

## Security Notes
- All endpoints except public reads MUST require a valid JWT `Bearer` token.
- Payment webhooks must verify the signature of the Payment Gateway.
- Never trust the client's `price` field. Always calculate the price on the backend based on the `appointmentTypeId`.
- Validate that the patient ID belongs to the authenticated user's account.

## Idempotency
- Implement Idempotency Keys on the `POST /bookings/reserve` and `POST /payments/initiate` endpoints to ensure network retries don't create multiple reservations or charges.
