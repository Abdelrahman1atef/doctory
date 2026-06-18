import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:lottie/lottie.dart';

class AbherLoading {
  static bool shown = false;

  static void show({bool fullScreen = false}) {
    if (!shown) {
      SmartDialog.show(
        keepSingle: true,
        builder: (_) => fullScreen
            ? const AbherCircularProgressIndicator()
            : const Dialog(
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: AbherCircularProgressIndicator(),
                ),
              ),
      );
      shown = true;
    }
  }

  static void dismis() {
    if (shown) {
      SmartDialog.dismiss();
      shown = false;
    }
  }
}

class AbherCircularProgressIndicator extends StatelessWidget {
  const AbherCircularProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class AbherSuccess {
  static bool shown = false;

  static void show({bool fullScreen = false}) {
    if (shown == false) {
      SmartDialog.show(
        // clickMaskDismiss: false,
        // animationType: SmartAnimationType.scale,
        // animationTime: const Duration(milliseconds: 100),
        keepSingle: true,
        builder: (_) => fullScreen
            ? const AbherSuccessWidget()
            : const Dialog(
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: AbherSuccessWidget(),
                ),
              ),
      );

      shown = true;
    }
  }

  static void dismis() {
    if (shown) {
      SmartDialog.dismiss();
      shown = false;
    }
  }
}

class AbherSuccessWidget extends StatefulWidget {
  const AbherSuccessWidget({super.key});

  @override
  State<AbherSuccessWidget> createState() => _AbherSuccessWidgetState();
}

class _AbherSuccessWidgetState extends State<AbherSuccessWidget> {
  @override
  void initState() {
    // TODO(dev): implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      AbherSuccess.dismis();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Lottie.asset("assets/json/success.json"));
  }
}
