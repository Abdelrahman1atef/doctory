import 'package:doctory/core/router/app_router.dart';
import 'package:doctory/core/common/widgets/layout/abher_responsive_wrapper.dart';
import 'package:doctory/core/theme/theme_manager.dart';
import 'package:doctory/core/utils/app_assets.dart';
import 'package:doctory/core/utils/utils.dart';
import 'package:doctory/core/general/general_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class Doctory extends StatefulWidget {
  const Doctory({super.key});

  @override
  State<Doctory> createState() => _DoctoryState();
}

class _DoctoryState extends State<Doctory> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Precache all app images
    AppAssets.precacheImages(context);
  }

  @override
  Widget build(BuildContext context) {
    // Sync Utils.lang with EasyLocalization
    Utils.lang = context.locale.languageCode;

    return BlocProvider(
      create: (context) => GeneralCubit(),
      child: BlocListener<GeneralCubit, GeneralState>(
        listenWhen: (previous, current) => current is ConnectivityChanged,
        listener: (context, state) {
          if (state is ConnectivityChanged) {
            // if (!state.isConnected) {
            //   Alerts.showToast(
            //     'no_internet_connection'.tr(),
            //     displayTime: const Duration(seconds: 5),
            //   );
            // } else {
            //   Alerts.showToast('internet_connected'.tr(), displayTime: const Duration(seconds: 2));
            // }
          }
        },
        child: ValueListenableBuilder<ThemeMode>(
          valueListenable: AppThemeManager.instance.themeNotifier,
          builder: (context, themeMode, child) {
            return MaterialApp.router(
              key: ValueKey(context.locale.languageCode),
              title: 'Doctory',
              debugShowCheckedModeBanner: false,
              theme: AppThemeManager.lightTheme,
              themeMode: ThemeMode.light,
              routerConfig: AppRouter.router,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              builder: (context, child) {
                child = BotToastInit()(context, child);
                child = FlutterSmartDialog.init()(context, child);
                return AppResponsiveWrapper(child: child);
              },
            );
          },
        ),
      ),
    );
  }
}
