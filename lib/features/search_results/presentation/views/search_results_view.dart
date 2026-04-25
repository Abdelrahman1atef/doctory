import 'package:doctory/features/search_results/presentation/sections/search_list_section.dart';
import 'package:doctory/features/search_results/presentation/sections/search_map_section.dart';
import 'package:flutter/material.dart';

class SearchResultsView extends StatelessWidget {
  const SearchResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Map
          const Positioned.fill(child: SearchMapSection()),

          // Back Button
          PositionedDirectional(
            top: MediaQuery.of(context).padding.top + 16,
            start: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),

          // Bottom Sheet List
          const SearchListSection(),
        ],
      ),
    );
  }
}
