import 'package:flutter/material.dart';
import 'package:doctory/core/extensions/widget_extensions.dart';
import 'package:doctory/core/services/alerts.dart'; // For SnackState enum
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/utils/extensions.dart';

class AbherToastWidget extends StatelessWidget {
  const AbherToastWidget({
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
              Icon(
                state == SnackState.success ? Icons.check_circle : Icons.error,
                color: Colors.white,
                size: 28,
              ),
              12.pw,
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
