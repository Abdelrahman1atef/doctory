# Phase 4 — Ranked Diagnosis: Why the Map is Laggy

> **Project**: `doctory`
> **Scan Date**: 2026-05-10
> **Status**: 🔍 Final Diagnosis — No Changes Made

---

## 1. Every Cause of Map Lag — Ranked by Impact

### #1 🔴 CRITICAL — Cascading BlocBuilder Rebuilds (No `buildWhen` Anywhere)

**What's happening**: 5 `BlocBuilder`/`BlocConsumer` widgets on the map screen all listen to `MapHomeCubit` with **no `buildWhen` filter**. Every single cubit state emission — clinic search results, clinic selection, route update, user location update, heading change — triggers **all 5 widgets to rebuild simultaneously**, including the `GoogleMap` widget itself.

**Files & lines**:
- [map_home_body_section.dart:L47](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/presentation/sections/map_home_body_section.dart#L47) — parent of MapSection
- [map_section.dart:L247](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/presentation/sections/map_section.dart#L247) — wraps GoogleMap
- [map_search_section.dart:L34](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/presentation/sections/map_search_section.dart#L34) — search bar
- [nearby_clinics_sheet.dart:L53](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/presentation/sections/nearby_clinics_sheet.dart#L53) — clinic list
- [map_fabs_section.dart:L43](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/presentation/sections/map_fabs_section.dart#L43) — FAB buttons

**Why it causes lag**: During navigation, the cubit emits location updates every 5 seconds. Each emission rebuilds all 5 widget subtrees. The `BlocBuilder` in `map_section.dart` recreates the `Set<Polyline>` and re-renders the `GoogleMap` widget arguments — causing the native map platform view to diff and potentially re-render. This cascading rebuild is the **single biggest source of frame drops**.

**Severity**: 🔴 **Critical** — frame drops, jank on every state change

---

### #2 🔴 CRITICAL — Marker Bitmaps Regenerated From Scratch With No Cache

**What's happening**: Every time clinic data changes or a clinic is selected, `_generateCustomMarkers()` loops through **every** clinic and calls `MarkerGenerator.createCustomMarkerBitmap()` for each one. This method creates a `Canvas`, draws circles/text/shadows, converts to a `ui.Image`, then encodes to PNG bytes. **Zero caching** — the same clinic with the same title generates a brand new bitmap every time.

**Files & lines**:
- [map_section.dart:L104-134](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/presentation/sections/map_section.dart#L104) — `_generateCustomMarkers()`
- [marker_generator.dart:L6-93](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/presentation/widgets/marker_generator.dart#L6) — `createCustomMarkerBitmap()`

**Why it causes lag**: Canvas rendering → `toImage()` → `toByteData(format: PNG)` is **GPU-intensive async work**. With 20 clinics, that's 20 sequential canvas renders. This runs on the main isolate. Combined with issue #1, a single cubit emission can trigger `didUpdateWidget` → full marker regeneration → `setState` → GoogleMap rebuild. The user sees visible stutter whenever search results change.

**Severity**: 🔴 **Critical** — GPU + CPU heavy, blocks rendering pipeline

---

### #3 🔴 CRITICAL — GPS Blocks Search (Up to 4s Delay)

**What's happening**: When the user searches or taps a filter chip, `searchClinics()` in the cubit **awaits** `LocationHelper.getCurrentLocation()` **before** making the HTTP request. `getCurrentLocation()` tries `getLastKnownPosition()` first, but if that returns null, it calls `getCurrentPosition()` with a **4-second timeout**. During this wait, the user sees a loading state with no search happening.

**Files & lines**:
- [map_home_cubit.dart:L51-63](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/cubit/map_home_cubit.dart#L51) — GPS await before search
- [location_helper.dart:L42-84](file:///d:/Programing/flutterApp/project/doctory/lib/core/common/functions/location_helper.dart#L42) — getCurrentLocation with 4s timeout

**Why it causes lag**: This isn't a frame drop — it's a **perceived lag / cold-start delay**. The user taps "Dental", sees loading for 0-4 seconds (GPS), then waits for HTTP. Total perceived delay: 1-6 seconds. This makes the map feel unresponsive.

**Severity**: 🔴 **Critical** — perceived responsiveness, cold-start delay

---

### #4 🔴 CRITICAL — No Request Cancellation (Race Conditions)

**What's happening**: No `CancelToken` is used anywhere. If the user taps "Dental" then "Eye Care" quickly, both requests fire. The one that resolves last overwrites the state — which might be the "Dental" response arriving after "Eye Care", showing wrong results.

**Files & lines**:
- [map_home_cubit.dart:L65](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/cubit/map_home_cubit.dart#L65) — no CancelToken on `searchClinics`
- [map_home_cubit.dart:L115](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/cubit/map_home_cubit.dart#L115) — no CancelToken on `getRoute`

**Why it causes lag**: Not jank per se, but the user sees **flickering results** — data changes twice as both responses resolve. Each triggers the full rebuild cascade (#1) + marker regeneration (#2). Two searches = 2× the work.

**Severity**: 🔴 **Critical** — data races, double rebuilds, flickering UI

---

### #5 ⚠️ HIGH — MapPickerWidget: 3 setState Calls Per Camera Idle

**What's happening**: In `MapPickerWidget`, every time the camera stops moving, `_reverseGeocode()` fires. This method calls `setState` **3 separate times** (loading=true, address=result, loading=false). Each `setState` rebuilds the **entire** widget including the `GoogleMap`.

**Files & lines**:
- [map_picker_widget.dart:L94-117](file:///d:/Programing/flutterApp/project/doctory/lib/core/common/widgets/map/map_picker_widget.dart#L94) — `_reverseGeocode()` with 3 setState calls
- [map_picker_widget.dart:L164-166](file:///d:/Programing/flutterApp/project/doctory/lib/core/common/widgets/map/map_picker_widget.dart#L164) — `onCameraIdle` triggers it

**Why it causes lag**: 3 rebuilds of the GoogleMap widget per camera stop. The address UI and map share the same `build()` method, so address text changes force map re-renders. On rapid panning, this causes visible stutter.

**Severity**: ⚠️ **High** — frame drops in the location picker flow

---

### #6 ⚠️ HIGH — Pre-fetch on App Startup (preload: true)

**What's happening**: The Map tab branch has `preload: true` in the router config. This causes `MapHomeView` to mount at app startup, triggering GPS + HTTP + bitmap generation before the user ever visits the map.

**Files & lines**:
- [app_router.dart:L51](file:///d:/Programing/flutterApp/project/doctory/lib/core/router/app_router.dart#L51) — `preload: true`
- [map_home_view.dart:L23-34](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/presentation/views/map_home_view.dart#L23) — initState fires immediately

**Why it causes lag**: Competes with the Home tab for CPU/GPU/network during cold start. GPS + HTTP + N× canvas bitmap renders all fire while the user is looking at the Home screen. This can delay Home screen rendering and eat battery.

**Severity**: ⚠️ **High** — cold-start performance, battery drain

---

### #7 ⚠️ HIGH — Route Geometry Parsed on Main Thread

**What's happening**: `RouteModel.fromJson()` iterates the geometry array (potentially hundreds/thousands of coordinate pairs) creating `LatLng` objects, all on the main UI thread. No `compute()` or Isolate.

**Files & lines**:
- [route_model.dart:L14-28](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/data/model/route_model.dart#L14) — geometry parsing loop
- [dio_consumer.dart:L133](file:///d:/Programing/flutterApp/project/doctory/lib/core/network/impl/dio_consumer.dart#L133) — parser runs on main thread

**Why it causes lag**: During navigation, route updates fire every 5s (if user moved >20m). Parsing a large geometry array on the main thread can block rendering for 5-20ms, causing dropped frames.

**Severity**: ⚠️ **High** — frame drops during navigation

---

### #8 ⚠️ MEDIUM — MapSection Missing Controller Dispose

**What's happening**: `MapSection` stores `GoogleMapController` in a `Completer` but never calls `dispose()` on the controller. `MapPickerWidget` does it correctly.

**Files & lines**:
- [map_section.dart:L32-33](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/presentation/sections/map_section.dart#L32) — Completer, no dispose

**Why it causes lag**: Memory leak. The native map controller holds GPU textures and platform resources. Not disposing means they accumulate, especially if MapSection is rebuilt by its parent.

**Severity**: ⚠️ **Medium** — memory leak, gradual degradation

---

### #9 ⚠️ MEDIUM — Polyline Set Recreated Inside BlocBuilder

**What's happening**: Inside the `BlocBuilder.builder` callback, a new `Set<Polyline>` is created from scratch on every rebuild — even if the route hasn't changed.

**Files & lines**:
- [map_section.dart:L249](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/presentation/sections/map_section.dart#L249) — `Set<Polyline> polylines = {}`

**Why it causes lag**: Object allocation churn. Combined with #1, this creates a new set every 5 seconds during navigation. Flutter diffs the GoogleMap props and may trigger native-side polyline re-rendering.

**Severity**: ⚠️ **Medium** — unnecessary allocations, potential native re-render

---

### #10 ⚠️ LOW — initGoogleMaps() Called Without Await

**What's happening**: The Google Maps renderer initialization (`initializeWithRenderer(AndroidMapRenderer.latest)`) is fire-and-forget — called without `await` after `runApp()`.

**Files & lines**:
- [main.dart:L93](file:///d:/Programing/flutterApp/project/doctory/lib/main.dart#L93) — `initGoogleMaps()` without await

**Why it causes lag**: If the `GoogleMap` widget renders before the renderer finishes initializing, it may use the legacy renderer or cause a brief flicker. On most devices this resolves in <100ms, so impact is low.

**Severity**: ⚠️ **Low** — potential first-render flicker

---

## 2. Is the GoogleMap Widget Rebuilt When Switching Tabs?

**Answer: NO — it is NOT recreated, but YES — it IS rebuilt (re-rendered in place).**

**Explanation**: `StatefulShellRoute.indexedStack` keeps **all tab branches alive** in the widget tree using an internal `IndexedStack`. When the user switches away from the Map tab and comes back, `MapSection` is **never disposed and recreated** — the same widget instance persists. The `GoogleMap` native view stays alive.

**However**, the `GoogleMap` widget's **parent BlocBuilder** has no `buildWhen`, so any cubit emission that happened while the user was on another tab will trigger a rebuild of the `GoogleMap` widget's arguments when the user returns. Flutter diffs the new props against the old ones, which usually avoids a full native re-render, but it still costs CPU cycles.

**The `KeyedSubtree` wrapper** at [map_home_body_widget.dart:L24-27](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/presentation/widgets/map_home_body_widget.dart#L24) helps preserve the element tree across parent rebuilds. So the map itself survives tab switches gracefully — **this is not a primary lag cause**.

---

## 3. Is There Background Pre-Warming of the Map?

**Answer: YES.**

The Map branch has `preload: true` at [app_router.dart:L51](file:///d:/Programing/flutterApp/project/doctory/lib/core/router/app_router.dart#L51). This causes `MapHomeView` to be constructed and mounted at app startup, **before the user ever visits the Map tab**. This triggers:

1. `MapHomeCubit` creation → `searchClinics()` → GPS call + HTTP `GET /clinics/search`
2. `MapSection.initState()` → `_generateCustomMarkers()` → N× canvas bitmap renders
3. `Ticker.start()` → fires every frame (though `checkLiveLocation` is a no-op until navigation)

This is a form of "pre-warming" — the data and markers are ready when the user taps the Map tab. **But it comes at the cost of cold-start performance, battery, and network usage.**

---

## 4. Are Search Results Processed on the Main Thread in a Way That Causes Jank?

**Answer: YES.**

The entire parsing chain runs on the main UI thread:

1. `DioConsumer._handleRequest()` calls `jsonDecode(data)` on the main thread ([dio_consumer.dart:L126](file:///d:/Programing/flutterApp/project/doctory/lib/core/network/impl/dio_consumer.dart#L126))
2. The `parser` callback runs on the main thread ([dio_consumer.dart:L133](file:///d:/Programing/flutterApp/project/doctory/lib/core/network/impl/dio_consumer.dart#L133))
3. `ClinicSearchResponse.fromJson()` iterates the items list, calling `ClinicModel.fromJson()` for each clinic — which in turn may parse nested `DoctorModel` lists, `photos`, `operatingHours` maps
4. `RouteModel.fromJson()` iterates potentially thousands of geometry coordinate pairs

**No `compute()` or `Isolate` is used anywhere in the project.**

For small clinic lists (<20 items), the parsing is fast enough (~1-3ms) and unlikely to cause visible jank. **But for route geometry** (which can be 500-2000 points on long routes), parsing on the main thread during navigation (every 5s) can block rendering for 10-20ms — enough to drop 1-2 frames.

---

## 5. Team Summary — Why This Map Feels Laggy

> **The map screen suffers from a "death by a thousand rebuilds" problem.** Five separate `BlocBuilder` widgets all listen to the same cubit with no filtering (`buildWhen`), so every state change — whether it's a search result, clinic selection, location update, or heading change — triggers all five to rebuild simultaneously. The worst offender is the `GoogleMap` widget itself, which sits inside one of these unfiltered builders and gets its polyline set recreated on every emission. On top of that, every time clinic data changes, all marker bitmaps are regenerated from scratch using an expensive Canvas→PNG pipeline with zero caching — so selecting a single clinic causes every marker on the map to be re-rendered. Search feels sluggish because the cubit awaits a GPS fix (up to 4 seconds) before even sending the HTTP request, there's no request cancellation for rapid filter taps, and all JSON parsing happens on the main UI thread. During navigation mode, these problems compound: a Ticker fires every 5 seconds, triggering a GPS call + potential route fetch + state emission → which cascades into 5+ widget rebuilds + full marker regeneration + polyline recreation. The map was also set to `preload: true`, meaning all of this initialization work (GPS, HTTP, bitmap rendering) fires at app startup before the user even visits the map tab, slowing down the cold start.
