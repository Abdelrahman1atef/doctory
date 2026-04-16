import 'package:flutter/material.dart';
import 'package:doctory/core/extensions/widget_extensions.dart';
import 'package:doctory/core/services/alerts.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:lottie/lottie.dart';

class SnackDesgin extends StatelessWidget {
  const SnackDesgin({
    super.key,
    required this.text,
    this.state = SnackState.success,
  });

  final String text;
  final SnackState state;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child:
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              state == SnackState.success
                  ? Lottie.asset(
                      "assets/json/success.json",
                      width: 32,
                      height: 32,
                    )
                  : Lottie.asset(
                      "assets/json/error.json",
                      width: 32,
                      height: 32,
                    ),
              10.pw,
              Expanded(
                child: Text(
                  text,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ).setContainerToView(
            color: state == SnackState.success
                ? AppColors.primary
                : AppColors.error,
            margin: 20,
            radius: 8,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
    );
  }
}
