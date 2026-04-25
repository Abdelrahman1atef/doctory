import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/features/search_results/cubit/search_cubit.dart';
import 'package:doctory/features/search_results/cubit/search_states.dart';
import 'package:doctory/features/search_results/presentation/widgets/hospital_list_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class SearchListSection extends StatefulWidget {
  const SearchListSection({super.key});

  @override
  State<SearchListSection> createState() => _SearchListSectionState();
}

class _SearchListSectionState extends State<SearchListSection> {
  final DraggableScrollableController _sheetController = DraggableScrollableController();

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: _sheetController,
      initialChildSize: 0.4,
      minChildSize: 0.15,
      maxChildSize: 0.9,
      snapSizes: const [
        0.15,
        0.4,
        0.9,
      ],
      snap: true,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Drag Handle
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Expanded(
                child: BlocBuilder<SearchCubit, SearchStates>(
                  builder: (context, state) {
                    if (state is SearchLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is SearchSuccessState) {
                      if (state.hospitals.isEmpty) {
                        return Center(
                          child: Text(
                            context.tr('no_results_found'),
                            style: AppStyles.s16Medium.copyWith(
                              color: AppColors.stitchSecondary,
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: state.hospitals.length,
                        itemBuilder: (context, index) {
                          final hospital = state.hospitals[index];
                          final isSelected = state.selectedIndex == index;

                          return HospitalListItemWidget(
                            hospital: hospital,
                            isSelected: isSelected,
                            onTap: () {
                              context.read<SearchCubit>().selectHospital(index);
                              
                              // If sheet is expanded (max size), shrink it so user can see the map
                              if (_sheetController.isAttached && _sheetController.size > 0.4) {
                                _sheetController.animateTo(
                                  0.4,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOut,
                                );
                              }
                            },
                          );
                        },
                      );
                    } else if (state is SearchErrorState) {
                      return Center(
                        child: Text(
                          state.message,
                          style: AppStyles.s14Medium.copyWith(
                            color: Colors.red,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
