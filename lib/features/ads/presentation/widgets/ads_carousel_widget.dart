import 'dart:async';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/features/ads/data/model/public_ad_model.dart';
import 'package:doctory/features/ads/presentation/widgets/ads_badge_widget.dart';
import 'package:doctory/features/ads/presentation/widgets/ads_indicator_dots_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AdsCarouselWidget extends StatefulWidget {
  final List<PublicAdModel> ads;
  final ValueChanged<PublicAdModel> onAdTap;
  final String? title;

  const AdsCarouselWidget({
    super.key,
    required this.ads,
    required this.onAdTap,
    this.title,
  });

  @override
  State<AdsCarouselWidget> createState() => _AdsCarouselWidgetState();
}

class _AdsCarouselWidgetState extends State<AdsCarouselWidget> {
  static const Duration _autoPlayInterval = Duration(seconds: 4);
  static const double _bannerHeight = 180;

  late final PageController _pageController;
  Timer? _autoPlayTimer;
  int _currentPage = 0;

  int get _adCount => widget.ads.length;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.ads.length * 100;
    _pageController = PageController(initialPage: _currentPage);
    _startAutoPlay();
  }

  @override
  void didUpdateWidget(AdsCarouselWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.ads.length != widget.ads.length) _startAutoPlay();
  }

  @override
  void dispose() {
    _stopAutoPlay();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _stopAutoPlay();
    if (_adCount < 2) return;
    _autoPlayTimer = Timer.periodic(_autoPlayInterval, (_) {
      if (!mounted || !_pageController.hasClients) return;
      _pageController.nextPage(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    });
  }

  void _stopAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = null;
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is UserScrollNotification) {
      if (notification.direction == ScrollDirection.idle) {
        _startAutoPlay();
      } else {
        _stopAutoPlay();
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // if (widget.title != null) ...[
        //   Text(
        //     widget.title!,
        //     style: AppStyles.s16Bold.copyWith(color: AppColors.textPrimary),
        //   ),
        //   const SizedBox(height: 12),
        // ],
        SizedBox(
          height: _bannerHeight,
          child: NotificationListener<ScrollNotification>(
            onNotification: _handleScrollNotification,
            child: PageView.builder(
              clipBehavior: Clip.none,
              controller: _pageController,
              itemCount: _adCount < 2 ? _adCount : null,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemBuilder: (context, index) {
                final ad = widget.ads[index % _adCount];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: AdsBadgeWidget(
                    ad: ad,
                    onTap: () => widget.onAdTap(ad),
                  ),
                );
              },
            ),
          ),
        ),
        if (_adCount > 1) ...[
          const SizedBox(height: 10),
          AdsIndicatorDotsWidget(
            totalDots: _adCount,
            activeDot: _currentPage % _adCount,
          ),
        ],
      ],
    );
  }
}