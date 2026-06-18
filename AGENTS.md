# Flutter Project Rules

## 1. Workflow & Analysis (Pre-Coding)
Before generating any code, you MUST:
1. **Analyze existing project files**: Understand the current implementation and patterns.
2. **Understand folder structure**: Respect the established hierarchy.
3. **Identify feature organization**: Follow how features are currently separated.
4. **Search for reusable components**: Check for existing Cubits, Models, Repositories, UseCases, and Custom Widgets.
5. **Reuse and Extend**: Always reuse existing components and extend features instead of creating duplicates.
6. **Never generate code blindly**: Ensure you understand the project context first.
7. **Respect existing structure**: If a structure (even if slightly different from these rules) exists and is consistent, adapt to it while maintaining high engineering principles.

## 2. Language & Communication
- Write code comments in English
- Use English for variable names, class names, and function names

## 3. Architecture & Structure (View-Section-Widget Pattern)
- Follow feature-based folder structure:
  ```
  lib/
  ├── core/
  │   ├── Router/          # Main GoRouter setup (app_router.dart, router_names.dart)
  │   ├── app_strings/     # App-wide string constants
  │   ├── cache/           # Local storage (Hive, SecureStorage, CacheHelper)
  │   ├── common/
  │   │   ├── functions/   # Shared utility functions
  │   │   └── widgets/     # Shared/common widgets used across features
  │   ├── config/          # App config, flavor config, API keys
  │   ├── error/           # Error handling (ErrorHandler, Exceptions, Failures)
  │   ├── extensions/      # Dart/Flutter extension methods
  │   ├── general/         # General cubit, bloc observer
  │   ├── locator/         # Main DI setup (GetIt service locator)
  │   ├── network/         # Dio setup, interceptors, API interfaces & implementations
  │   ├── services/        # App services (alerts, navigation, media, notifications)
  │   ├── session/         # Session/auth state management
  │   ├── theme/           # App colors, typography, theme manager
  │   ├── utils/           # Utility helpers (assets, extensions, constants, validators)
  │   └── validation/      # Form validation logic
  ├── features/
  │   └── feature_name/
  │       ├── cubit/           # Business logic only (connects repo <-> UI via sections)
  │       ├── data/
  │       │   ├── repo/        # Repository implementations
  │       │   ├── model/       # Data models (fromJson / toJson) — hand-written, no generation
  │       │   └── data_source/ # Remote/local data sources
  │       ├── di/              # Feature-specific DI (registered in core's main DI)
  │       ├── router/          # Feature-specific GoRouter routes (registered in core's main router)
  │       └── presentation/
  │           ├── widgets/     # Pure UI only — NO logic, receives data as parameters, max ~100 lines
  │           ├── sections/    # Logic + layout bridge — handles state & composes widgets
  │           └── views/       # Scaffold only — wires AppBar section, Body section, FAB section
  └── shared/        # Shared widgets & components
  ```

### Presentation Layer Rules (View-Section-Widget)

#### Views — Scaffold only, nothing else
- A View contains **only** a `Scaffold`.
- **Never use the `appBar` slot** on `Scaffold` — it causes fixed-height issues, overlap problems with `SafeArea`, and removes layout control.
- Place `SafeArea` directly wrapping the `body` — once, here, nowhere else.
- `body` receives `ProductsBodySection()` only — the AppBar lives inside the body as a normal widget.
- `floatingActionButton` and `bottomNavigationBar` slots still receive dedicated Sections.
- Zero logic, zero styling, zero BlocBuilder — pure wiring.

```dart
// ✅ correct
class ProductsView extends StatelessWidget {
  const ProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: const ProductsBodySection(),
      ),
      floatingActionButton: const ProductsFabSection(),
    );
  }
}
```

```dart
// 🚫 wrong — using Scaffold appBar slot
class ProductsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProductsAppBarSection(),           // 🚫 never use appBar slot
      body: const ProductsBodySection(),
    );
  }
}
```

```dart
// 🚫 wrong — logic, styling, or widgets directly in the view
class ProductsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(                              // 🚫 layout in view
        children: [
          ProductsAppBarSection(),
          ProductsListSection(),
        ],
      ),
    );
  }
}
```

#### Sections — logic + layout bridge, no styling
- Sections own **all state logic**: `BlocBuilder`, `BlocListener`, `BlocConsumer` live here only.
- Sections compose reusable widgets using `Row`, `Column`, and lightweight layout.
- Sections call cubit methods and pass data down to widgets as parameters.
- **Sections must NOT contain any design code** — no colors, no padding, no decoration, no text styles.
- If a section grows large, extract inner parts into smaller widgets.
- **`ProductsBodySection`** is always a `Column` — AppBar section on top, `Expanded` wrapping the scrollable content below.
- **AppBar sections** are plain `StatelessWidget` — no `PreferredSizeWidget`, no fixed height — just a normal widget inside the Column.

```dart
// ✅ correct — Body section owns the full layout including AppBar
class ProductsBodySection extends StatelessWidget {
  const ProductsBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        ProductsAppBarSection(),
        Expanded(
          child: ProductsListSection(),
        ),
      ],
    );
  }
}

// ✅ correct — AppBar section is a plain widget, no PreferredSizeWidget
class ProductsAppBarSection extends StatelessWidget {
  const ProductsAppBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCustomAppBar(title: context.l10n.products);
  }
}

// ✅ correct — FAB section
class ProductsFabSection extends StatelessWidget {
  const ProductsFabSection({super.key});

  @override
  Widget build(BuildContext context) {
    return AppFabButton(
      onPressed: () => context.read<ProductsCubit>().openAddProduct(),
    );
  }
}

// ✅ correct — list section with state
class ProductsListSection extends StatelessWidget {
  const ProductsListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsStates>(
      builder: (context, state) {
        if (state is ProductsLoading) return const AppLoadingWidget();
        if (state is ProductsError) return AppErrorWidget(message: state.message);
        if (state is ProductsSuccess) {
          return Column(
            children: state.products
                .map((p) => ProductItemWidget(product: p))
                .toList(),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
```

- 🚫 No `PreferredSizeWidget` on AppBar sections — AppBar is just a plain widget inside the body Column.
- 🚫 No `appBar` slot on Scaffold — never use it.
#### Widgets — pure UI, small, reusable
- Widgets are pure design — all data comes via constructor parameters.
- No cubit access (`context.read`) inside widgets.
- Max **~100 lines** per widget file — split aggressively into sub-widgets.
- Always use `const` constructors where possible.
- Must pass `dart analyze` with zero warnings/errors.
- `dart format` is not enforced, but `dart analyze` must be clean.

```dart
// ✅ correct
class ProductItemWidget extends StatelessWidget {
  const ProductItemWidget({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          ProductImageWidget(imageUrl: product.imageUrl),
          const SizedBox(width: 12),
          ProductInfoWidget(name: product.name, price: product.price),
        ],
      ),
    );
  }
}
```

## 4. Custom Widget Policy
- **Never Repeat UI Code**: If UI appears more than once, extract a widget.
- **Core First**: Prefer using existing core widgets first (e.g., `AppDefaultButton`, `AppCustomAppBar`).
- **Reuse**: Reuse existing components whenever possible. If no widget exists, create a reusable one.

## 5. State Management
- Use **Cubit** (from flutter_bloc) — no Bloc, no Riverpod, no Provider.
- States are **plain sealed Dart classes** — no Equatable, no Freezed, no copyWith, no generated code.
- Use a sealed class with a default initial state:

```dart
sealed class ProductsStates {}

class ProductsInitial extends ProductsStates {}

class ProductsLoading extends ProductsStates {}

class ProductsSuccess extends ProductsStates {
  final List<ProductModel> products;
  ProductsSuccess(this.products);
}

class ProductsError extends ProductsStates {
  final String message;
  ProductsError(this.message);
}
```

- Cubit emits states only — no UI logic, no navigation inside cubit (use a navigation service).
- Always use `context.read<Cubit>()` — never `BlocProvider.of`.
- 🚫 No Equatable — no `==` or `hashCode` overrides on states.
- 🚫 No Freezed, no copyWith, no @freezed, no part files for generation.
- 🚫 No build_runner generated code for state classes.

## 6. Data Models
- Models are **plain Dart classes** — no json_serializable, no Freezed, no generated code.
- Write `fromJson` / `toJson` manually:

```dart
class ProductModel {
  final int id;
  final String name;
  final double price;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }
}
```

- 🚫 No @JsonSerializable, no @freezed, no .g.dart files, no part directives for generation.

## 7. Dependency Injection
- Use **GetIt** for service locator (locator.dart).
- Register all cubits, repositories, and data sources in a central DI setup file or feature-specific DI modules.

## 8. BlocProvider Placement — Router Only

- `BlocProvider` MUST be placed in the **feature router** — never inside a View, Section, or Widget.
- The router is the only place responsible for creating and providing Cubits to the widget tree.
- This ensures the Cubit lifetime is tied to the Route — it gets disposed automatically when the user leaves the screen.
- If the Cubit needs to trigger an initial call (e.g., fetch data on load), do it inside `create:` using `..methodName()`.

```dart
// ✅ correct — BlocProvider in the feature router
GoRoute(
  path: RouterNames.products,
  builder: (context, state) => BlocProvider(
    create: (_) => locator<ProductsCubit>()..getProducts(),
    child: const ProductsView(),
  ),
),
```

```dart
// 🚫 wrong — BlocProvider inside the View
class ProductsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(                     // 🚫 never here
      create: (_) => locator<ProductsCubit>(),
      child: Scaffold(
        appBar: ProductsAppBarSection(),
        body: const ProductsBodySection(),
      ),
    );
  }
}
```

```dart
// 🚫 wrong — BlocProvider inside a Section
class ProductsBodySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(                     // 🚫 never here
      create: (_) => locator<ProductsCubit>(),
      child: const ProductsListSection(),
    );
  }
}
```

- 🚫 No `BlocProvider` inside Views, Sections, or Widgets — router only.
- 🚫 No `MultiBlocProvider` wrapping the whole app for feature-specific cubits — each route provides its own.

## 9. Networking & Results Handling

- Use **Dio** via an **interface-based approach** (`ApiConsumer`).
- **ApiResult<T>** MUST be used to wrap all API responses.
- **Fold Pattern**: Always handle results using the `.fold()` method:

```dart
final result = await _repository.getData();
result.fold(
  onSuccess: (data) => emit(SuccessState(data)),
  onFailure: (failure) => emit(ErrorState(failure.message)),
);
```

- **Generics & Parsers**: API methods should use generics and optional `parser` functions for model mapping.
- **Multipart**: Use `isFormData: true` for file uploads.



## 10. Data Layer (Repositories & Data Sources)
- **Data Sources Only**: All direct data operations (remote API calls, local database/cache queries) MUST happen inside the **Data Source**.
- **Repository Role**: The Repository MUST NOT interact with APIs or local storage directly. Instead, it calls the appropriate Data Source(s).
- **Data Merging & Syncing**: If a feature requires merging remote data with local data (or syncing), this logic MUST be implemented in the **Repository**. The Repository acts as the single source of truth for the Cubit.

## 11. Error Handling & Failures
- **Centralized Error Handling**: Use `ErrorHandler.handleDioException()` or `ErrorHandler.handleException()` to convert errors into `Failure` types.
- **Failure Types**: Use specific failure classes derived from the base `Failure` class:
  - `ServerFailure` (5xx errors)
  - `ValidationFailure` (422 errors, includes `errors` map)
  - `AuthFailure` (401 errors)
  - `PermissionFailure` (403 errors)
  - `NoInternetFailure` & `NetworkFailure`
- **User Feedback**: Use `failure.userMessage(context)` to get localized, user-friendly error messages from the failure object.

## 12. Localization
- Use Flutter's built-in localization with ARB files.
- All user-facing strings MUST be localized (no hardcoded strings in widgets).
- Access via `context.l10n`.

## 13. Code Style & Quality
- **Naming**: camelCase for variables/functions, PascalCase for classes.
- **SOLID**: Follow SOLID principles strictly.
- **Composition**: Prefer composition over inheritance.
- **Readability**: Keep files readable, maintainable, and avoid duplication.
- **Constants**: Use `const` constructors where possible and avoid magic numbers.
- **dart analyze** must pass with zero warnings/errors — this is mandatory.
- **dart format** is not enforced.

## 14. UI & Styling
- **No Hardcoding**: Never hardcode colors or text styles.
- **Theme Usage**: Use `AppColors.*` and predefined text styles from the theme classes.
- **Responsive**: Use responsive design patterns.

## 15. Forbidden Practices 🚫
- Logic, BlocBuilder, or widgets directly inside Views (Scaffold slots only).
- `appBar` slot on `Scaffold` — always put the AppBar inside the body Column as a plain widget.
- `SafeArea` anywhere except the `body` wrap in the View.
- Design code, colors, padding, or decoration inside Sections.
- UI helper methods inside any class (`_buildHeader()`, `_buildCard()`, etc.) — use widget classes.
- Hardcoded colors or text styles.
- Business logic inside Widgets or Views.
- Direct API calls inside UI.
- Direct Database/API calls inside Repository (must use Data Source).
- Widget files over ~100 lines — split into sub-widgets.
- Duplicated features or code.
- Equatable, Freezed, copyWith, or any generated code for states or models.
- json_serializable, @JsonSerializable, build_runner, .g.dart, .freezed.dart files.
- cubit access (context.read) inside Widgets.
- dart analyze warnings or errors left unresolved.
- BlocProvider inside Views, Sections, or Widgets — router only.
- MultiBlocProvider wrapping the whole app for feature-specific cubits.

## 16. General
- When creating new features, always create the full folder structure (cubit, data, di, router, presentation).
- Each presentation section type has its own file: `feature_appbar_section.dart`, `feature_body_section.dart`, `feature_fab_section.dart`.
- Write code like a Senior Flutter Engineer: Clean, Scalable, and Maintainable.