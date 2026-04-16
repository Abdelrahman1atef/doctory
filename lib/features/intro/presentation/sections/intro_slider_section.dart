import 'package:doctory/features/intro/cubit/intro_cubit.dart';
import 'package:doctory/features/intro/presentation/widgets/intro_slider_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IntroSliderSection extends StatefulWidget {
  const IntroSliderSection({super.key});

  @override
  State<IntroSliderSection> createState() => _IntroSliderSectionState();
}

class _IntroSliderSectionState extends State<IntroSliderSection> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  void _nextPage() {
    final introData = context.read<IntroCubit>().getIntros();
    if (_currentIndex < introData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onDone() {
    context.read<IntroCubit>().setIntroSeen();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final introData = context.read<IntroCubit>().getIntros();

    return IntroSliderWidget(
      pageController: _pageController,
      introData: introData,
      currentIndex: _currentIndex,
      onPageChanged: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      onNext: _nextPage,
      onDone: _onDone,
    );
  }
}
