import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/intro/presentation/widgets/intro_buttons_widget.dart';
import 'package:doctory/features/intro/presentation/widgets/intro_indicator_widget.dart';
import 'package:doctory/features/intro/presentation/widgets/intro_item_widget.dart';
import 'package:doctory/features/intro/presentation/widgets/intro_skip_button_widget.dart';
import 'package:flutter/material.dart';

class IntroSliderWidget extends StatelessWidget {
  const IntroSliderWidget({
    super.key,
    required this.pageController,
    required this.introData,
    required this.currentIndex,
    required this.onPageChanged,
    required this.onNext,
    required this.onDone,
  });

  final PageController pageController;
  final List<dynamic> introData;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onNext;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: pageController,
            itemCount: introData.length,
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) {
              return IntroItemWidget(intro: introData[index]);
            },
          ),
        ),
        IntroIndicatorWidget(
          pageController: pageController,
          count: introData.length,
        ),
        IntroButtonsWidget(
          isLastPage: currentIndex == introData.length - 1,
          onNext: onNext,
          onStart: onDone,
        ),
        IntroSkipButtonWidget(onSkip: onDone),
        context.bottomPadding.ph,
      ],
    );
  }
}
