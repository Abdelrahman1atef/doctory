import 'package:doctory/features/intro/data/model/intro_model.dart';
import 'package:doctory/features/intro/presentation/widgets/intro_discover_widget.dart';
import 'package:doctory/features/intro/presentation/widgets/intro_book_widget.dart';
import 'package:doctory/features/intro/presentation/widgets/intro_compare_widget.dart';
import 'package:flutter/material.dart';

class IntroItemWidget extends StatelessWidget {
  final IntroModel intro;

  const IntroItemWidget({super.key, required this.intro});

  @override
  Widget build(BuildContext context) {
    switch (intro.id) {
      case 1:
        return const IntroDiscoverWidget();
      case 2:
        return const IntroBookWidget();
      case 3:
        return const IntroCompareWidget();
      default:
        return const SizedBox.shrink();
    }
  }
}
