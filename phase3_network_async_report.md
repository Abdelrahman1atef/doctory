# Phase 3 — Network & Async Code Scan Report

> **Project**: `doctory`
> **Scan Date**: 2026-05-10
> **Status**: 🔍 Diagnostic Only — No Changes Made

---

## 1. HTTP Requests Triggered by the Map Screen

### Complete Request Inventory

| # | Endpoint | Method | File | Line | Trigger | When |
|---|----------|--------|------|------|---------|------|
| R1 | `GET /clinics/search` | Dio GET | [map_home_remote_data_source.dart:L42](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/data/data_source/map_home_remote_data_source.dart#L42) | L42-55 | `MapHomeCubit.searchClinics()` | On widget init (MapHomeView.initState) + on search submit + on filter chip tap |
| R2 | `GET /maps/route` | Dio GET | [map_home_remote_data_source.dart:L65](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/data/data_source/map_home_remote_data_source.dart#L65) | L65-74 | `MapHomeCubit.getRoute()` | On clinic selection + every 5s during navigation (if user moved >20m) |
| R3 | `Geolocator.getCurrentPosition()` | Platform GPS | [map_home_cubit.dart:L59](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/cubit/map_home_cubit.dart#L59) | L59 | `searchClinics()` | Before every search (to get user lat/lng), unless custom location is set |
| R4 | `Geolocator.getCurrentPosition()` | Platform GPS | [map_home_cubit.dart:L151](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/cubit/map_home_cubit.dart#L151) | L151-155 | `selectClinic()` | On each clinic selection (to calc route start point) |
| R5 | `Geolocator.getCurrentPosition()` | Platform GPS | [map_home_cubit.dart:L208](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/cubit/map_home_cubit.dart#L208) | L208-210 | `checkLiveLocation()` | Every 5s during navigation (via Ticker) |
| R6 | `Geolocator.getLastKnownPosition()` + `getCurrentPosition()` | Platform GPS | [location_helper.dart:L51-75](file:///d:/Programing/flutterApp/project/doctory/lib/core/common/functions/location_helper.dart#L51) | L51, L65 | `LocationHelper.getCurrentLocation()` | Called by `MapSection._getCurrentLocation()` in initState + FAB press |
| R7 | `placemarkFromCoordinates()` | Geocoding API | [map_picker_widget.dart:L98](file:///d:/Programing/flutterApp/project/doctory/lib/core/common/widgets/map/map_picker_widget.dart#L98) | L98-100 | `MapPickerWidget._reverseGeocode()` | On every camera idle in MapPickerWidget (not the main map screen) |

---

### Detailed Request Flow on Map Screen Load

```
User taps "Map" tab (or app loads with preload: true)
│
├─► MapHomeView.initState() [map_home_view.dart:L23-35]
│   ├─► MapHomeCubit.searchClinics() [cubit:L18]
│   │   ├─► Geolocator.getCurrentPosition() [cubit:L59] ──► R3 (GPS)
│   │   └─► _apiConsumer.get('/clinics/search') [data_source:L42] ──► R1 (HTTP)
│   │
│   └─► Ticker starts [map_home_view.dart:L28-34]
│       └─► (fires every 5s, but checkLiveLocation() is no-op until navigation starts)
│
├─► MapSection.initState() [map_section.dart:L44-56]
│   ├─► _generateCustomMarkers() ──► (no network, just bitmap rendering)
│   └─► IF clinics empty: _getCurrentLocation()
│       └─► LocationHelper.getCurrentLocation() ──► R6 (GPS)
│
└─► Total on first load: 1 HTTP + 1-2 GPS calls
```

### Request Flow During Navigation (Every 5 Seconds)

```
Ticker fires (every 5s) [map_home_view.dart:L28-33]
└─► MapHomeCubit.checkLiveLocation() [cubit:L198]
    ├─► Geolocator.getCurrentPosition() ──► R5 (GPS)
    │
    ├─► IF user moved > 20m:
    │   └─► MapHomeCubit.getRoute() [cubit:L226]
    │       └─► _apiConsumer.get('/maps/route') ──► R2 (HTTP)
    │
    └─► IF user moved ≤ 20m:
        └─► emit(state.copyWith(lat, lng, heading)) ──► no HTTP, just state update
```

> [!WARNING]
> During navigation: **1 GPS call every 5 seconds** guaranteed. Plus **1 HTTP call** (route fetch) if user moved >20m. This is approximately **12 GPS calls/minute** + **variable HTTP calls/minute**.

---

## 2. JSON Parsing Operations — Isolate Analysis

### All `fromJson` / JSON Parsing Locations

| # | File | Line | Operation | On Isolate? | Severity |
|---|------|------|-----------|-------------|----------|
| P1 | [dio_consumer.dart](file:///d:/Programing/flutterApp/project/doctory/lib/core/network/impl/dio_consumer.dart#L126) | L126 | `jsonDecode(data)` — fallback if response is String | ❌ Main thread | ⚠️ Medium |
| P2 | [dio_consumer.dart](file:///d:/Programing/flutterApp/project/doctory/lib/core/network/impl/dio_consumer.dart#L133) | L133 | `parser(data as Map<String, dynamic>)` — calls model parsers | ❌ Main thread | ⚠️ Medium |
| P3 | [map_home_remote_data_source.dart](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/data/data_source/map_home_remote_data_source.dart#L54) | L54 | `ClinicSearchResponse.fromJson(json)` via parser | ❌ Main thread | ⚠️ Medium |
| P4 | [map_home_remote_data_source.dart](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/data/data_source/map_home_remote_data_source.dart#L73) | L73 | `RouteModel.fromJson(json)` via parser | ❌ Main thread | ⚠️ Medium |
| P5 | [map_home_models.dart](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/data/model/map_home_models.dart#L22) | L22-36 | `ClinicSearchResponse.fromJson()` — iterates items list, calls `ClinicModel.fromJson` per item | ❌ Main thread | ⚠️ Medium |
| P6 | [clinic_model.dart](file:///d:/Programing/flutterApp/project/doctory/lib/core/common/models/clinic_model.dart#L103) | L103-135 | `ClinicModel.fromJson()` — nested parsing (doctors, photos, specialties, operatingHours) | ❌ Main thread | ⚠️ Medium |
| P7 | [route_model.dart](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/data/model/route_model.dart#L14) | L14-28 | `RouteModel.fromJson()` — iterates geometry list, creates `LatLng` per point | ❌ Main thread | ⚠️ High |

> [!CAUTION]
> **ZERO** `compute()` or `Isolate` usage found **anywhere** in the entire project. All JSON parsing runs on the **main UI thread**.
>
> The most concerning is **P7** (`RouteModel.fromJson`) — route geometry can contain **hundreds or thousands** of `LatLng` points. Parsing this list on the main thread during navigation (every 5s when user moves) could cause frame drops.

### Parsing Chain (Main Thread)

```
DioConsumer._handleRequest() [main thread]
├── response = await _dio.get(...)                    // Dio handles HTTP I/O
├── data = jsonDecode(data)           [L126]          // Main thread ❌
└── parser(data)                      [L133]          // Main thread ❌
    └── ClinicSearchResponse.fromJson(json) [L54]     // Main thread ❌
        └── for each item:
            └── ClinicModel.fromJson(e)    [L27]      // Main thread ❌
                └── DoctorModel.fromJson() (if nested) // Main thread ❌
```

---

## 3. Search Flow — Step-by-Step Analysis

### How Search Works (End to End)

**Step 1 — User Types in Search Bar**

[MapSearchBarWidget](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/presentation/widgets/map_search_bar_widget.dart) (L47-49):
```dart
TextField(
  controller: controller,
  onSubmitted: onSubmitted,  // ← Only fires on keyboard "Done" / Enter
  // ❌ No onChanged callback
)
```

**Step 2 — `onSubmitted` fires** → calls `MapSearchSection` callback

[MapSearchSection](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/presentation/sections/map_search_section.dart) (L45-47):
```dart
onSubmitted: (value) {
  context.read<MapHomeCubit>().searchClinics(searchText: value);
},
```

**Step 3 — Cubit calls repo** → repo calls data source → HTTP GET

[MapHomeCubit.searchClinics()](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/cubit/map_home_cubit.dart#L18) (L18-103):
```dart
emit(MapHomeLoadingState(clinics: currentClinics));  // ← UI shows loading

// Get GPS location (BLOCKS until GPS resolves)
final position = await LocationHelper.getCurrentLocation();  // R3

// HTTP request
final result = await _mapHomeRepo.searchClinics(...);        // R1

result.fold(
  onSuccess: (data) => emit(MapHomeLoadedState(clinics: data.items, ...)),
  onFailure: (failure) => emit(MapHomeErrorState(...)),
);
```

**Step 4 — Parsing on main thread** → state emitted → UI rebuilds

### Search Flow Issues

| # | Issue | Severity | Detail |
|---|-------|----------|--------|
| S1 | **No debounce** | ⚠️ Medium | Search only fires on `onSubmitted` (keyboard Done), not on `onChanged`, so debounce is less critical. But filter chip taps have no protection. |
| S2 | **No request cancellation** | 🔴 Critical | No `CancelToken` used. If user taps "Dental" then immediately taps "Cardiology", both requests fire and whichever resolves last wins — potentially showing stale results. |
| S3 | **GPS call blocks search** | 🔴 Critical | `searchClinics()` awaits `LocationHelper.getCurrentLocation()` **before** making the HTTP request ([cubit:L59](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/cubit/map_home_cubit.dart#L59)). If GPS is slow (up to 4s timeout), the user sees loading for 4+ seconds before the search even starts. |
| S4 | **Parsing on main thread** | ⚠️ Medium | `ClinicSearchResponse.fromJson` iterates the items list on main thread. For small result sets (<50 clinics) this is acceptable. |
| S5 | **No empty query guard** | ⚠️ Low | Tapping "All" chip calls `searchClinics()` with no searchText — fires a full unfiltered search. No throttle on repeated taps. |

### Filter Chip Flow (No Keyboard Needed)

[MapSearchSection](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/presentation/sections/map_search_section.dart) (L63-101):
```dart
MapFilterChipWidget(
  label: 'Dental',
  onTap: () {
    context.read<MapHomeCubit>().searchClinics(searchText: 'Dental');
  },
),
```

> [!WARNING]
> Filter chips trigger `searchClinics()` **immediately** on tap with **no debounce** and **no cancellation**. Rapid tapping can fire multiple concurrent HTTP requests + GPS calls.

---

## 4. Timers, Subscriptions & Periodic Polling

### 4.1 Ticker — `MapHomeView` (Main Periodic Mechanism)

**File**: [map_home_view.dart:L27-34](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/presentation/views/map_home_view.dart#L27)

```dart
_ticker = createTicker((elapsed) {
  if (elapsed - _lastTick > const Duration(seconds: 5)) {
    _lastTick = elapsed;
    _cubit.checkLiveLocation();  // ← Fires every ~5 seconds
  }
});
_ticker.start();
```

| Aspect | Detail |
|--------|--------|
| **Type** | `Ticker` (from `SingleTickerProviderStateMixin`) |
| **Frequency** | Fires on every frame (~60fps), but `checkLiveLocation()` only executes every 5s |
| **Lifecycle** | Starts in `initState`, disposed in `dispose` |
| **Offstage behavior** | ✅ `Ticker` auto-pauses when widget is offstage (other tab active). **BUT** with `StatefulShellRoute.indexedStack`, the widget is technically **never offstage** — it's always in the widget tree (just obscured). The ticker keeps running. |
| **What it does** | Calls `checkLiveLocation()` which: gets GPS → optionally fetches route → emits state |

> [!CAUTION]
> **The Ticker never truly pauses.** Because `StatefulShellRoute.indexedStack` keeps all branches mounted, the `MapHomeView` is never "offstage" in the ticker sense. This means:
> - **GPS is polled every 5 seconds** even when the user is on the Home, Community, or More tab
> - **However**, `checkLiveLocation()` has an early return: `if (!_isLiveNavigating) return;` — so it only does real work during active navigation. GPS calls only fire when `_isLiveNavigating == true`.

### 4.2 No Other Timers/Subscriptions Found

| Pattern | Found? |
|---------|--------|
| `Timer` / `Timer.periodic` | ❌ Not in map_home feature |
| `StreamSubscription` | ❌ Not in map_home feature |
| `Stream.listen` | ❌ Not in map_home feature |
| `Geolocator.getPositionStream` | ❌ Not used (uses polling via Ticker instead) |

---

## 5. Pre-fetch / Background Requests Before User Navigates to Map

### Analysis

**Router configuration** ([app_router.dart:L51](file:///d:/Programing/flutterApp/project/doctory/lib/core/router/app_router.dart#L51)):
```dart
StatefulShellBranch(routes: MapHomeRouter.routes, preload: true),
```

**YES — there IS a pre-fetch.** The `preload: true` flag on the Map's `StatefulShellBranch` causes:

1. `MapHomeView` is **constructed and mounted** before the user visits the Map tab
2. `MapHomeView.initState()` fires immediately → creates `MapHomeCubit` → calls `searchClinics()`
3. `searchClinics()` → `LocationHelper.getCurrentLocation()` (GPS) → `GET /clinics/search` (HTTP)
4. `MapSection.initState()` → `_generateCustomMarkers()` (bitmap rendering)

### Pre-fetch Sequence

```
App launches → LayoutView mounts
│
├─► Home tab renders (visible)
│
└─► Map branch preloads (invisible, but mounted)
    └─► MapHomeView.initState()
        ├─► MapHomeCubit created (registered as Factory in GetIt)
        ├─► searchClinics(searchQuery: null) fires immediately
        │   ├─► GPS: getCurrentLocation() ──► Platform call
        │   └─► HTTP: GET /clinics/search ──► Network call
        │
        └─► Ticker starts (runs every frame, checkLiveLocation every 5s)
            └─► No-op because _isLiveNavigating == false
```

> [!WARNING]
> **The map screen fires 1 GPS call + 1 HTTP request** before the user ever visits it. This happens at app startup because of `preload: true`. On slow networks or slow GPS, this adds latency and battery drain to the initial app load.
>
> Additionally, `_generateCustomMarkers()` renders N bitmap markers (canvas → PNG → bytes) in the background — this consumes CPU even before the map is visible.

---

## Summary — Severity Matrix

### 🔴 Critical

| # | Finding | Impact |
|---|---------|--------|
| C1 | **No request cancellation** — no `CancelToken` used anywhere. Rapid filter chip taps fire concurrent uncancellable requests. | Stale data race conditions, wasted bandwidth |
| C2 | **GPS blocks search** — `searchClinics()` awaits GPS (up to 4s timeout) before making HTTP request. | User sees loading for 4+ seconds per search |
| C3 | **Pre-fetch fires on app startup** — `preload: true` + `initState` triggers GPS + HTTP before user visits map. | Unnecessary battery/data usage on cold start |

### ⚠️ High

| # | Finding | Impact |
|---|---------|--------|
| H1 | **Route geometry parsed on main thread** — `RouteModel.fromJson()` iterates potentially thousands of LatLng points on UI thread. | Frame drops during navigation route updates |
| H2 | **No `compute()`/Isolate usage in entire project** — all JSON parsing is main thread. | Potential jank for large responses |
| H3 | **Ticker keeps ticking on other tabs** — `indexedStack` keeps widget mounted, ticker callback fires every frame. | Minor CPU waste (but `checkLiveLocation` early-returns) |

### ⚠️ Medium

| # | Finding | Impact |
|---|---------|--------|
| M1 | **No debounce on filter chips** — each tap fires immediate GPS + HTTP. | Redundant requests on rapid tapping |
| M2 | **GPS called in cubit AND in MapSection** — `searchClinics()` gets GPS, then `MapSection._getCurrentLocation()` also gets GPS independently. | 2 GPS calls where 1 would suffice |
| M3 | **Geocoding on every camera idle** (MapPickerWidget only) — `placemarkFromCoordinates()` fires on every camera stop. | Network call on every map pan (in picker, not main map) |

### ✅ Good Patterns Found

| Pattern | Detail |
|---------|--------|
| Ticker guards navigation-only work | `checkLiveLocation()` returns early if `!_isLiveNavigating` |
| 20m movement threshold for route updates | Avoids route fetches for minor GPS jitter |
| GPS timeout (4s) in `LocationHelper` | Prevents infinite GPS waits |
| `LocationHelper.getLastKnownPosition()` first | Fast fallback before expensive fresh GPS fix |
| Cubit state preserves clinics during loading | `MapHomeLoadingState(clinics: currentClinics)` keeps old data visible |

---

## Request Timeline Visualization

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        APP STARTUP                                     │
├─────────────────────────────────────────────────────────────────────────┤
│ t=0s   │ LayoutView mounts → Home visible, Map preloads              │
│ t=0s   │ ├── GPS: getCurrentLocation() ──────────────► [0-4s wait]   │
│ t=0-4s │ └── HTTP: GET /clinics/search ──────────────► [waiting GPS] │
│ t=1-5s │     └── Response parsed on main thread                      │
│ t=1-5s │     └── _generateCustomMarkers() → N× bitmap renders       │
│        │                                                              │
├─────────────────────────────────────────────────────────────────────────┤
│                     USER TAPS MAP TAB                                  │
├─────────────────────────────────────────────────────────────────────────┤
│        │ Map is already loaded (preloaded). No new requests.          │
│        │                                                              │
├─────────────────────────────────────────────────────────────────────────┤
│                     USER TAPS "Dental" CHIP                            │
├─────────────────────────────────────────────────────────────────────────┤
│ t=0s   │ searchClinics(searchText: 'Dental')                         │
│ t=0s   │ ├── GPS: getCurrentLocation() ──────────────► [0-4s wait]   │
│ t=0-4s │ └── HTTP: GET /clinics/search?SearchText=Dental             │
│ t=1-5s │     └── Response parsed (main thread)                       │
│ t=1-5s │     └── BlocBuilder rebuilds → _generateCustomMarkers()     │
│        │                                                              │
├─────────────────────────────────────────────────────────────────────────┤
│                     USER TAPS CLINIC → NAVIGATION STARTS               │
├─────────────────────────────────────────────────────────────────────────┤
│ t=0s   │ selectClinic() → GPS → HTTP: GET /maps/route                │
│ t=5s   │ checkLiveLocation() → GPS → (maybe) HTTP: GET /maps/route   │
│ t=10s  │ checkLiveLocation() → GPS → (maybe) HTTP: GET /maps/route   │
│ t=15s  │ checkLiveLocation() → GPS → (maybe) HTTP: GET /maps/route   │
│  ...   │ (continues every 5s until stopNavigation())                  │
└─────────────────────────────────────────────────────────────────────────┘
```
