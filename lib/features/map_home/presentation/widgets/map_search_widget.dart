import 'package:doctory/core/utils/extensions.dart';
import 'package:flutter/material.dart';

/// Pure widget — displays the Map search overlay layout (search bar + filter chips)
class MapSearchWidget extends StatelessWidget {
  final Widget searchBar;
  final Widget filterChips;

  const MapSearchWidget({
    super.key,
    required this.searchBar,
    required this.filterChips,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.paddingOf(context).top + 16,
      left: 16,
      right: 16,
      child: Column(
        children: [
          searchBar,
          16.ph,
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              child: filterChips,
            ),
          ),
        ],
      ),
    );
  }
}
