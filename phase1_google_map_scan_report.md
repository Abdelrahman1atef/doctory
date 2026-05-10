# Phase 1 — Google Maps & Navigation Structure Scan Report

> **Project**: `doctory`
> **Scan Date**: 2026-05-10
> **Status**: 🔍 Diagnostic Only — No Changes Made

---

## 1. Files Containing a `GoogleMap` Widget

| # | File Path | Class Name | Widget Type |
|---|-----------|-----------|-------------|
| 1 | [pick_location_screen.dart](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/presentation/widgets/pick_location_screen.dart#L50) | `PickLocationScreen` | `StatefulWidget` |
| 2 | [map_section.dart](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/presentation/sections/map_section.dart#L265) | `MapSection` | `StatefulWidget` |
| 3 | [map_picker_widget.dart](file:///d:/Programing/flutterApp/project/doctory/lib/core/common/widgets/map/map_picker_widget.dart#L220) | `MapPickerWidget` | `StatefulWidget` |

> [!NOTE]
> All three are `StatefulWidget`. None of them are `StatelessWidget`.

---

## 2. Main Scaffold with `BottomNavigationBar`

**File**: [layout_view.dart](file:///d:/Programing/flutterApp/project/doctory/lib/features/layout/presentation/views/layout_view.dart)

### Tab Switching Mechanism: `StatefulShellRoute.indexedStack` (GoRouter)

The `LayoutView` does **NOT** use `IndexedStack`, `PageView`, or a conditional `Column` directly. Instead, it delegates tab switching to GoRouter's **`StatefulShellRoute.indexedStack`**, which uses an `IndexedStack` internally.

#### Router Setup ([app_router.dart:L45-L54](file:///d:/Programing/flutterApp/project/doctory/lib/core/router/app_router.dart#L45-L54)):
```dart
StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) {
    return LayoutView(navigationShell: navigationShell);
  },
  branches: [
    StatefulShellBranch(routes: HomeRouter.routes),
    StatefulShellBranch(routes: MapHomeRouter.routes, preload: true),
    StatefulShellBranch(routes: CommunityRouter.routes),
    StatefulShellBranch(routes: MoreRouter.routes),
  ],
),
```

#### LayoutView Body & BottomNavigationBar ([layout_view.dart:L59-L90](file:///d:/Programing/flutterApp/project/doctory/lib/features/layout/presentation/views/layout_view.dart#L59-L90)):
```dart
child: Scaffold(
  body: widget.navigationShell,              // ← The shell renders the active branch
  bottomNavigationBar: BottomNavigationBar(
    currentIndex: widget.navigationShell.currentIndex,
    onTap: _onItemTapped,
    selectedItemColor: AppColors.stitchPrimary,
    unselectedItemColor: AppColors.textSecondary,
    type: BottomNavigationBarType.fixed,
    items: [
      BottomNavigationBarItem(
        icon: const Icon(Icons.home_outlined),
        activeIcon: const Icon(Icons.home_rounded),
        label: context.tr('home'),
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.map_outlined),
        activeIcon: const Icon(Icons.map_rounded),
        label: context.tr('map.title'),
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.people_outline),
        activeIcon: const Icon(Icons.people_rounded),
        label: context.tr('community'),
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.more_horiz_outlined),
        activeIcon: const Icon(Icons.more_horiz_rounded),
        label: context.tr('more'),
      ),
    ],
  ),
),
```

> [!IMPORTANT]
> **Key Finding**: `StatefulShellRoute.indexedStack` keeps **all branches alive** in memory using an internal `IndexedStack`. This means the `MapHomeView` (and its `GoogleMap`) stays alive even when the user is on the Home, Community, or More tab.
>
> Additionally, `MapHomeRouter` has **`preload: true`**, meaning the Map tab is initialized **before the user ever visits it**.

---

## 3. `AutomaticKeepAliveClientMixin` in Bottom Nav Screens

| Tab Index | Screen | File | Widget Type | Has `AutomaticKeepAliveClientMixin`? | Calls `super.build(context)`? |
|-----------|--------|------|-------------|--------------------------------------|-------------------------------|
| 0 | `HomeView` | [home_view.dart](file:///d:/Programing/flutterApp/project/doctory/lib/features/home/presentation/views/home_view.dart) | `StatelessWidget` | ❌ No | N/A |
| 1 | `MapHomeView` | [map_home_view.dart](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/presentation/views/map_home_view.dart) | `StatefulWidget` (with `SingleTickerProviderStateMixin`) | ❌ No | ❌ No |
| 2 | `CommunityView` | [community_view.dart](file:///d:/Programing/flutterApp/project/doctory/lib/features/community/presentation/views/community_view.dart) | `StatelessWidget` | ❌ No | N/A |
| 3 | `MoreView` | [more_view.dart](file:///d:/Programing/flutterApp/project/doctory/lib/features/more/presentation/views/more_view.dart) | `StatelessWidget` | ❌ No | N/A |

> [!NOTE]
> **None** of the bottom nav screens use `AutomaticKeepAliveClientMixin`.
> This is **not needed** because `StatefulShellRoute.indexedStack` already preserves all branch states internally. The mixin would be redundant.
>
> The only place `AutomaticKeepAliveClientMixin` is used in the entire project is in [dropdown.dart:L41](file:///d:/Programing/flutterApp/project/doctory/lib/core/common/widgets/dropdowns/dropdown.dart#L41) (`_DropDownItemState`), which correctly calls `super.build(context)` at [L67](file:///d:/Programing/flutterApp/project/doctory/lib/core/common/widgets/dropdowns/dropdown.dart#L67).

---

## 4. `GoogleMapController` Storage & `onMapCreated` Callbacks

### 4.1 `MapSection` ([map_section.dart](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/presentation/sections/map_section.dart))

**Variable Declaration** (L32-33):
```dart
final Completer<GoogleMapController> _controller =
    Completer<GoogleMapController>();
```

**`onMapCreated` Callback** (L279-283):
```dart
onMapCreated: (GoogleMapController controller) {
  if (!_controller.isCompleted) {
    _controller.complete(controller);
  }
},
```

**Controller Usage** (L146, L184):
```dart
// In _fitResults():
final GoogleMapController controller = await _controller.future;

// In _getCurrentLocation():
final GoogleMapController controller = await _controller.future;
```

> [!WARNING]
> `MapSection` uses a `Completer<GoogleMapController>` but **never disposes** the controller. There is no `dispose()` override in `_MapSectionState`. Since `StatefulShellRoute.indexedStack` keeps the branch alive, the controller persists, but if `MapSection` is rebuilt (e.g. due to `didUpdateWidget`), a new `Completer` is created on each rebuild **at the class-field level**, so the old completer reference is lost but the old controller is not disposed.

---

### 4.2 `MapPickerWidget` ([map_picker_widget.dart](file:///d:/Programing/flutterApp/project/doctory/lib/core/common/widgets/map/map_picker_widget.dart))

**Variable Declaration** (L47):
```dart
GoogleMapController? _controller;
```

**`onMapCreated` Callback** (L122-127):
```dart
void _onMapCreated(GoogleMapController controller) {
  _controller = controller;
  if (widget.markers != null && widget.markers!.isNotEmpty) {
    _centerCameraOnMarkers();
  }
}
```

**Usage in GoogleMap** (L225):
```dart
onMapCreated: _onMapCreated,
```

**Dispose** (L61-63):
```dart
@override
void dispose() {
  _controller?.dispose();
  super.dispose();
}
```

> [!TIP]
> `MapPickerWidget` correctly disposes its `GoogleMapController` in `dispose()`. This is the proper pattern.

---

### 4.3 `PickLocationScreen` ([pick_location_screen.dart](file:///d:/Programing/flutterApp/project/doctory/lib/features/map_home/presentation/widgets/pick_location_screen.dart))

> [!CAUTION]
> `PickLocationScreen` has a `GoogleMap` widget at L50 but does **NOT** store any `GoogleMapController` at all. There is no `onMapCreated` callback, no controller variable, and no dispose logic. The map is uncontrolled.

---

## 5. Package Versions & Android Configuration

### `google_maps_flutter` Version
From [pubspec.yaml:L53-54](file:///d:/Programing/flutterApp/project/doctory/pubspec.yaml#L53-L54):
```yaml
google_maps_flutter: ^2.12.3
google_maps_flutter_android: ^2.14.3
```

### `useAndroidViewSurface` in `main.dart`
From [main.dart:L22-34](file:///d:/Programing/flutterApp/project/doctory/lib/main.dart#L22-L34):
```dart
Future<void> initGoogleMaps() async {
  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    mapsImplementation.useAndroidViewSurface = true;    // ← SET TO TRUE
    try {
      await mapsImplementation.initializeWithRenderer(
        AndroidMapRenderer.latest,
      );
    } catch (e) {
      debugPrint("Google Maps initialization: $e");
    }
  }
}
```

> [!WARNING]
> `useAndroidViewSurface = true` **is set**, but `initGoogleMaps()` is called **without `await`** at [main.dart:L93](file:///d:/Programing/flutterApp/project/doctory/lib/main.dart#L93):
> ```dart
> // Initialize Google Maps in the background after runApp
> initGoogleMaps(); // No await here
> ```
> This means the map renderer initialization is a fire-and-forget async call. The `GoogleMap` widget could render before the renderer is initialized, potentially causing a race condition.

---

## Summary of Findings

| Finding | Severity | Details |
|---------|----------|---------|
| `StatefulShellRoute.indexedStack` keeps all tabs alive | ℹ️ Info | All 4 tabs remain mounted. Map stays alive in background. |
| Map branch has `preload: true` | ⚠️ Warning | Map initializes before user visits it — extra memory + network usage. |
| `MapSection` doesn't dispose `GoogleMapController` | ⚠️ Warning | Potential memory leak; `Completer` pattern makes dispose tricky. |
| `PickLocationScreen` has no controller at all | ℹ️ Info | Map is uncontrolled — can't animate camera programmatically. |
| `MapPickerWidget` properly disposes controller | ✅ Good | Best practice followed. |
| `initGoogleMaps()` called without `await` | ⚠️ Warning | Possible race condition with first map render. |
| No `AutomaticKeepAliveClientMixin` on nav screens | ✅ Good | Not needed with `indexedStack`. |
