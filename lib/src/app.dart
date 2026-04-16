import 'package:doctory/core/router/app_router.dart';
import 'package:doctory/core/common/widgets/layout/abher_responsive_wrapper.dart';
import 'package:doctory/core/theme/theme_manager.dart';
import 'package:doctory/core/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class Doctory extends StatelessWidget {
  const Doctory({super.key});

  @override
  Widget build(BuildContext context) {
    // Sync Utils.lang with EasyLocalization
    Utils.lang = context.locale.languageCode;

    return ValueListenableBuilder<ThemeMode>(
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
    );
  }
}
