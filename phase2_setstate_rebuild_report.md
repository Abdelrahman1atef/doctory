# Phase 2 — setState & Rebuild Problems Scan Report

> **Project**: `doctory`
> **Scan Date**: 2026-05-10
> **Status**: 🔍 Diagnostic Only — No Changes Made

---

## 1. `setState()` Calls Inside GoogleMap Callbacks

### 1.1 `PickLocationScreen` — [pick_location_screen.dart](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/presentation/widgets/pick_location_screen.dart)

| Callback | Line | State Variable Updated | Severity |
|----------|------|----------------------|----------|
| `onTap` | L54-57 | `_pickedLocation` (LatLng?) | ⚠️ Medium |

```dart
// L54-57
onTap: (latLng) {
  setState(() {
    _pickedLocation = latLng;
  });
},
```

**Analysis**: `setState` on `onTap` rebuilds the **entire** widget tree including the `GoogleMap` itself. However, this only fires on user tap (infrequent), so the real-world impact is low. The marker set is also rebuilt inline (L59-69) on every `build()`.

**Other callbacks**: No `onCameraMove`, `onCameraIdle`, `onLongPress`, `onMapCreated`.

---

### 1.2 `MapSection` — [map_section.dart](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/presentation/sections/map_section.dart)

| Callback | Line | State Variable Updated | Severity |
|----------|------|----------------------|----------|
| `onMapCreated` | L279-283 | None (completes `Completer`) | ✅ OK |

```dart
// L279-283
onMapCreated: (GoogleMapController controller) {
  if (!_controller.isCompleted) {
    _controller.complete(controller);
  }
},
```

**No other map callbacks** (`onCameraMove`, `onCameraIdle`, `onTap`, `onLongPress`) are registered on the GoogleMap widget.

**However**, `setState` IS called from **non-callback methods** that affect the map:

| Method | Line | State Variable Updated | Trigger | Severity |
|--------|------|----------------------|---------|----------|
| `_loadMapStyle()` | L77-79 | `_mapStyle` (String?) | Theme change (`didChangeDependencies`) | ⚠️ Medium |
| `_generateCustomMarkers()` | L131-133 | `_customMarkers` (Set\<Marker\>) | `initState` + `didUpdateWidget` | 🔴 Critical |

```dart
// L131-133 — inside _generateCustomMarkers()
setState(() {
  _customMarkers = newMarkers;
});
```

---

### 1.3 `MapPickerWidget` — [map_picker_widget.dart](file:///d:/Programing/flutterApp/project/doctory/lib/core/common/widgets/map/map_picker_widget.dart)

| Callback | Line | State Variable Updated | Severity |
|----------|------|----------------------|----------|
| `onMapCreated` | L122-127 | None (`_controller` assigned, no setState) | ✅ OK |
| `onCameraMove` | L160-162 | `_current` (LatLng, no setState) | ✅ OK |
| `onCameraIdle` | L164-166 | Triggers `_reverseGeocode()` → multiple `setState` calls | 🔴 Critical |

**`onCameraIdle` → `_reverseGeocode()` setState chain:**

| Line | State Variable | Purpose |
|------|---------------|---------|
| L96 | `_loadingAddress = true` | Show loading spinner |
| L109 | `_address = address` | Update address text |
| L114 | `_address = ''` | Clear on error |
| L116 | `_loadingAddress = false` | Hide loading spinner |

```dart
// L94-117 — _reverseGeocode triggers up to 3 setState calls per camera idle
Future<void> _reverseGeocode(LatLng latLng) async {
  setState(() => _loadingAddress = true);       // rebuild 1
  try {
    ...
    setState(() => _address = address);          // rebuild 2
    widget.onLocationPicked(lat, lng, address);
  } catch (_) {
    setState(() => _address = '');               // rebuild 2 (error path)
  } finally {
    setState(() => _loadingAddress = false);     // rebuild 3
  }
}
```

> [!CAUTION]
> **3 consecutive `setState` calls** in `_reverseGeocode()` = up to **3 rebuilds of the `GoogleMap`** every time the camera stops moving. This is triggered by `onCameraIdle` which fires on **every** camera movement, including programmatic ones.

**Additional setState outside callbacks:**

| Method | Line | State Variable | Trigger | Severity |
|--------|------|---------------|---------|----------|
| `_fetchCurrentLocation()` | L70 | `_loadingLocation = true` | `initState` | ⚠️ Medium |
| `_fetchCurrentLocation()` | L90 | `_loadingLocation = false` | After GPS fetch | ⚠️ Medium |

---

## 2. `build()` Methods Containing GoogleMap — Unrelated Rebuild Triggers

### 2.1 `MapSection.build()` — [map_section.dart:L199-311](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/presentation/sections/map_section.dart#L199)

**Structure**: `BlocListener` → `BlocBuilder<MapHomeCubit, MapHomeStates>` → `GoogleMap`

**🔴 CRITICAL**: The `BlocBuilder` has **NO `buildWhen`** condition. It rebuilds on **every** cubit state emission.

The `MapHomeCubit` emits state changes for:
- Search results loaded (clinics list changed)
- Clinic selected / deselected
- Route fetched / updated
- Navigation started / stopped
- **User location updates every 5 seconds** (`checkLiveLocation()` — [cubit L198-255](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/cubit/map_home_cubit.dart#L198))
- User heading changes

> [!WARNING]
> During navigation mode, `checkLiveLocation()` fires every 5 seconds and emits `currentUserLat`, `currentUserLng`, `currentUserHeading` updates. **Each emission rebuilds the entire `BlocBuilder`, which recreates the `Polyline` set and passes it to `GoogleMap`** — even though the `BlocListener` (with proper `listenWhen`) already handles camera movement for navigation.

**What gets rebuilt unnecessarily** inside the `BlocBuilder` (L248-308):
1. `Set<Polyline> polylines = {}` — **recreated from scratch** on every build (L249)
2. The `Stack` containing `GoogleMap`, `MapFabsSection`, and navigation button
3. The `GoogleMap` widget itself (though Flutter may diff props and avoid native re-render)

---

### 2.2 `MapPickerWidget.build()` — [map_picker_widget.dart:L170-261](file:///d:/Programing/flutterApp/project/doctory/lib/core/common/widgets/map/map_picker_widget.dart#L170)

**🔴 CRITICAL**: The `build()` method contains **both** the address display UI **and** the `GoogleMap`. Any `setState` for `_address`, `_loadingAddress`, or `_loadingLocation` rebuilds the **entire widget**, including the map.

**Unrelated rebuild triggers** (these affect the address UI, not the map):
- `_address` text changes (geocoding result)
- `_loadingAddress` toggle (loading spinner)
- `_loadingLocation` toggle (overlay)

All three share the same `build()` method as `GoogleMap`, so the map gets rebuilt for every address text update.

---

### 2.3 `PickLocationScreen.build()` — [pick_location_screen.dart:L31-100](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/presentation/widgets/pick_location_screen.dart#L31)

**⚠️ MEDIUM**: The `build()` contains both the `GoogleMap` and the confirm button. A `setState` from `onTap` (updating `_pickedLocation`) rebuilds the map + button + marker set. However, taps are infrequent so real-world impact is low.

---

### 2.4 `MapHomeBodySection.build()` — [map_home_body_section.dart:L46-101](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/presentation/sections/map_home_body_section.dart#L46)

**🔴 CRITICAL**: This is the **parent** of `MapSection`. It wraps everything in `BlocBuilder<MapHomeCubit, MapHomeStates>` with **NO `buildWhen`**.

Every cubit emission rebuilds this section, which **recreates `MapSection` with new constructor args**:
```dart
// L82-86 — new MapSection instance on every rebuild
MapHomeBodyWidget(
  mapSection: MapSection(
    clinics: clinics,
    selectedClinicId: selectedClinicId,
    sheetSizeNotifier: _sheetSizeNotifier,
  ),
  searchSection: isNavigating ? const SizedBox.shrink() : const MapSearchSection(),
  ...
);
```

> [!IMPORTANT]
> **Mitigation exists**: `MapHomeBodyWidget` wraps `mapSection` in a `KeyedSubtree(key: ValueKey('map_section_subtree'))` at [L24-27](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/presentation/widgets/map_home_body_widget.dart#L24). This helps Flutter preserve the element tree. But `MapSection` still receives new props and triggers `didUpdateWidget` → `_generateCustomMarkers()`.

---

## 3. State Management Wrapping the GoogleMap

### 3.1 `MapSection` — BlocBuilder wrapping GoogleMap directly

**File**: [map_section.dart:L247-310](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/presentation/sections/map_section.dart#L247)

```dart
return BlocListener<MapHomeCubit, MapHomeStates>(
  listenWhen: (previous, current) { ... },  // ✅ Has listenWhen
  listener: (context, state) { ... },
  child: BlocBuilder<MapHomeCubit, MapHomeStates>(
    // ❌ NO buildWhen — rebuilds on EVERY state emission
    builder: (context, state) {
      Set<Polyline> polylines = {};  // recreated each build
      ...
      return Stack(
        children: [
          GoogleMap(...),          // ← rebuilt unnecessarily
          ...
        ],
      );
    },
  ),
);
```

| Aspect | Status | Details |
|--------|--------|---------|
| `BlocListener` | ✅ Good | Has `listenWhen` — only reacts to clinic/nav changes |
| `BlocBuilder` | 🔴 Missing `buildWhen` | Rebuilds `GoogleMap` on every state emission |
| `ValueNotifier` | ✅ Good | `sheetSizeNotifier` used correctly in `MapFabsSection` with `ValueListenableBuilder` |

### 3.2 `MapHomeBodySection` — BlocBuilder wrapping MapSection parent

**File**: [map_home_body_section.dart:L47](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/presentation/sections/map_home_body_section.dart#L47)

```dart
return BlocBuilder<MapHomeCubit, MapHomeStates>(
  // ❌ NO buildWhen
  builder: (context, state) {
    ...
    return MapHomeBodyWidget(
      mapSection: MapSection(...),  // ← new instance props on every build
      ...
    );
  },
);
```

> [!CAUTION]
> **Double BlocBuilder problem**: `MapHomeBodySection` has a `BlocBuilder` → creates `MapSection` → which has its own `BlocBuilder` → wraps `GoogleMap`. Both have **no `buildWhen`**. Every cubit emission triggers **two** cascading rebuilds.

### 3.3 Other BlocBuilders on the map screen

| File | Line | What it wraps | Has `buildWhen`? |
|------|------|--------------|-----------------|
| [nearby_clinics_sheet.dart](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/presentation/sections/nearby_clinics_sheet.dart#L53) | L53 | Clinic list sheet | ❌ No |
| [map_fabs_section.dart](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/presentation/sections/map_fabs_section.dart#L43) | L43 | FAB buttons | ❌ No |
| [map_search_section.dart](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/presentation/sections/map_search_section.dart#L34) | L34 | Search bar + chips (uses `BlocConsumer`) | ❌ No |

**All 5 BlocBuilders/Consumers** on the map screen rebuild on every cubit emission. During navigation, this means **5 simultaneous rebuilds every 5 seconds**.

---

## 4. Marker `Set<Marker>` — Recreation Pattern

### 4.1 `MapSection._generateCustomMarkers()` — [map_section.dart:L104-134](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/presentation/sections/map_section.dart#L104)

```dart
Future<void> _generateCustomMarkers() async {
  final Set<Marker> newMarkers = {};           // ← New Set every time
  for (int i = 0; i < widget.clinics.length; i++) {
    final clinic = widget.clinics[i];
    ...
    final icon = await MarkerGenerator.createCustomMarkerBitmap(  // ← Async bitmap!
      title, isSelected: isSelected, isRegistered: clinic.isRegistered,
    );
    newMarkers.add(Marker(..., icon: icon));
  }
  setState(() {
    _customMarkers = newMarkers;               // ← Full replacement
  });
}
```

| Issue | Severity | Detail |
|-------|----------|--------|
| Set recreated from scratch | 🔴 Critical | Every call creates a brand new `Set<Marker>` and regenerates **all** markers |
| Called on every `didUpdateWidget` | 🔴 Critical | Triggers when `clinics` OR `selectedClinicId` changes ([L93-101](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/presentation/sections/map_section.dart#L93)) |
| No diff / incremental update | 🔴 Critical | Doesn't compare old vs new clinics — regenerates all bitmaps even if only 1 clinic's selection changed |

**Trigger chain**: Cubit emits → `MapHomeBodySection` BlocBuilder rebuilds → creates new `MapSection(clinics: ..., selectedClinicId: ...)` → `didUpdateWidget` fires → `_generateCustomMarkers()` → regenerates ALL marker bitmaps → `setState` → `GoogleMap` rebuilds

### 4.2 `PickLocationScreen` — Inline marker set

```dart
// L59-69 — Created inline inside build()
markers: _pickedLocation != null
    ? {
        Marker(
          markerId: const MarkerId('picked'),
          position: _pickedLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        ),
      }
    : {},
```

| Issue | Severity | Detail |
|-------|----------|--------|
| Set created inline in `build()` | ⚠️ Medium | New `Set` literal on every rebuild, but it's just 1 marker so impact is minimal |

### 4.3 `MapSection` BlocBuilder — Polyline set

```dart
// L249 — inside BlocBuilder.builder
Set<Polyline> polylines = {};
```

| Issue | Severity | Detail |
|-------|----------|--------|
| Polyline set recreated every build | ⚠️ Medium | New `Set<Polyline>` on every BlocBuilder rebuild. During navigation, this is every 5 seconds. |

---

## 5. `BitmapDescriptor` Creation — Hot Path Analysis

### 5.1 `MarkerGenerator.createCustomMarkerBitmap()` — [marker_generator.dart:L6-93](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/presentation/widgets/marker_generator.dart#L6)

```dart
static Future<BitmapDescriptor> createCustomMarkerBitmap(
  String title, {bool isSelected = false, bool isRegistered = true}
) async {
  // Creates a Canvas, draws circles, text, converts to PNG bytes
  final img = await pictureRecorder.endRecording().toImage(size, size);
  final data = await img.toByteData(format: ui.ImageByteFormat.png);
  return BitmapDescriptor.bytes(data!.buffer.asUint8List());
}
```

**Called from**: `MapSection._generateCustomMarkers()` at [L111](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/presentation/sections/map_section.dart#L111)

| Issue | Severity | Detail |
|-------|----------|--------|
| Called in a loop for **every** clinic | 🔴 Critical | No caching. If there are 20 clinics, 20 bitmaps are rendered from scratch |
| Triggered by `didUpdateWidget` | 🔴 Critical | Runs on every widget rebuild, not just when clinic data actually changes |
| No cache/memoization | 🔴 Critical | Same clinic with same title, same `isSelected`, same `isRegistered` generates a new bitmap every time |
| Canvas → PNG → bytes pipeline | ⚠️ High | Each call involves `toImage()` + `toByteData()` — expensive async operations |

### 5.2 `PickLocationScreen` — `BitmapDescriptor.defaultMarkerWithHue`

```dart
// L64-65
icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
```

| Issue | Severity | Detail |
|-------|----------|--------|
| Called inside `build()` inline marker | ⚠️ Low | `defaultMarkerWithHue` is cheap (returns a cached constant), but it's called in `build()` on every rebuild |

---

## Summary — Severity Matrix

### 🔴 Critical (Must Fix)

| # | Finding | File | Impact |
|---|---------|------|--------|
| C1 | `MapHomeBodySection` BlocBuilder has **no `buildWhen`** — recreates `MapSection` on every state emission | [map_home_body_section.dart:L47](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/presentation/sections/map_home_body_section.dart#L47) | Cascading rebuilds every 5s during navigation |
| C2 | `MapSection` BlocBuilder has **no `buildWhen`** — rebuilds `GoogleMap` on every state emission | [map_section.dart:L247](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/presentation/sections/map_section.dart#L247) | GoogleMap + polylines rebuilt every 5s |
| C3 | `_generateCustomMarkers()` recreates **ALL** markers from scratch with no diff | [map_section.dart:L104-134](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/presentation/sections/map_section.dart#L104) | N×async bitmap renders on each update |
| C4 | `MarkerGenerator.createCustomMarkerBitmap()` has **no caching** — renders canvas→PNG→bytes every call | [marker_generator.dart:L6-93](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/presentation/widgets/marker_generator.dart#L6) | Expensive GPU work repeated unnecessarily |
| C5 | `MapPickerWidget._reverseGeocode()` calls `setState` **3 times** per camera idle, rebuilding `GoogleMap` each time | [map_picker_widget.dart:L94-117](file:///d:/Programing/flutterApp/project/doctory/lib/core/common/widgets/map/map_picker_widget.dart#L94) | 3 map rebuilds per camera stop |

### ⚠️ High

| # | Finding | File | Impact |
|---|---------|------|--------|
| H1 | **5 BlocBuilders/Consumers** on the map screen, **none** have `buildWhen` | Multiple files | 5 parallel rebuilds on every cubit emission |
| H2 | `Polyline` set recreated inside `BlocBuilder.builder` on every rebuild | [map_section.dart:L249](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/presentation/sections/map_section.dart#L249) | Unnecessary object churn during navigation |
| H3 | `MapPickerWidget.build()` mixes address UI with `GoogleMap` — address changes rebuild map | [map_picker_widget.dart:L170-261](file:///d:/Programing/flutterApp/project/doctory/lib/core/common/widgets/map/map_picker_widget.dart#L170) | Map rebuilds on every geocoding result |

### ⚠️ Medium

| # | Finding | File | Impact |
|---|---------|------|--------|
| M1 | `PickLocationScreen.onTap` setState rebuilds entire widget including GoogleMap | [pick_location_screen.dart:L54-57](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/presentation/widgets/pick_location_screen.dart#L54) | Low frequency, minimal real impact |
| M2 | `_loadMapStyle()` setState rebuilds MapSection for theme change | [map_section.dart:L77-79](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/presentation/sections/map_section.dart#L77) | Rare — only on theme toggle |
| M3 | Inline marker set literal in `PickLocationScreen.build()` | [pick_location_screen.dart:L59-69](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/presentation/widgets/pick_location_screen.dart#L59) | Single marker, minimal impact |

---

## Rebuild Flow Diagram (Navigation Mode — Every 5 Seconds)

```
Ticker fires (every 5s)
  └─► MapHomeCubit.checkLiveLocation()
      └─► emit(state.copyWith(currentUserLat, currentUserLng, heading))
          │
          ├─► MapHomeBodySection BlocBuilder (NO buildWhen) ──► REBUILD
          │   └─► Creates new MapSection(clinics, selectedClinicId)
          │       └─► didUpdateWidget fires
          │           └─► _generateCustomMarkers() (if clinics/selection differ)
          │               └─► Loop: N × MarkerGenerator.createCustomMarkerBitmap() 🔥
          │                   └─► setState(_customMarkers = newMarkers) ──► REBUILD
          │
          ├─► MapSection BlocBuilder (NO buildWhen) ──► REBUILD
          │   └─► Set<Polyline> polylines = {} (recreated)
          │   └─► GoogleMap(...) ──► REBUILD
          │
          ├─► MapSearchSection BlocConsumer (NO buildWhen) ──► REBUILD
          │
          ├─► NearbyClinicsSheet BlocBuilder (NO buildWhen) ──► REBUILD
          │
          └─► MapFabsSection BlocBuilder (NO buildWhen) ──► REBUILD
```

> [!CAUTION]
> **Worst case during navigation**: Every 5 seconds, the cubit emits a location update. This triggers **5+ widget rebuilds**, potentially regenerates **all marker bitmaps** (if didUpdateWidget detects prop changes), and recreates the polyline set — all for a simple lat/lng heading update that the `BlocListener` already handles for camera animation.
