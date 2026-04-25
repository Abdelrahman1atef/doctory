import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/features/search_results/cubit/search_cubit.dart';
import 'package:doctory/features/search_results/presentation/views/search_results_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SearchRouter {
  static final List<GoRoute> routes = [
    GoRoute(
      path: AppRoutes.searchResults,
      builder: (context, state) {
        final query = state.extra as String? ?? '';
        return BlocProvider(
          create: (context) => sl<SearchCubit>()..getUserLocationAndSearch(query: query),
          child: const SearchResultsView(),
        );
      },
    ),
  ];
}
