import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/cache/cache_helper.dart';
import 'package:doctory/features/intro/cubit/intro_cubit.dart';
import 'package:doctory/features/intro/cubit/intro_states.dart';
import 'package:doctory/features/intro/presentation/sections/splash_body_section.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/common/widgets/sheets/language_bottom_sheet_section.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _playOceanSound();
    context.read<IntroCubit>().checkUserStatus();
  }

  Future<void> _playOceanSound() async {
    try {
      await _audioPlayer.setSourceAsset('audio/ocean.mp3');
      await _audioPlayer.setVolume(0.7);
      await _audioPlayer.play(AssetSource('audio/ocean.mp3'));
    } catch (e) {
      debugPrint('🎵 [SplashView] Audio error: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<IntroCubit, IntroStates>(
      listener: (context, state) {
        if (state is ShowLanguageBottomSheetState) {
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            isDismissible: false,
            enableDrag: false,
            builder: (context) => LanguageBottomSheetSection(
              onContinue: () async {
                context.pop(); // Close Bottom Sheet
                await CacheHelper.saveBool('isLanguageSelected', true);
                if (context.mounted) {
                  context.go(AppRoutes.intro);
                }
              },
            ),
          );
        } else if (state is NavigateToIntroState) {
          context.go(AppRoutes.intro);
        } else if (state is NavigateToLoginState) {
          context.go(AppRoutes.login);
        } else if (state is NavigateToMainState) {
          context.go(AppRoutes.login);
        }
      },
      child: const Scaffold(body: SplashBodySection()),
    );
  }
}
