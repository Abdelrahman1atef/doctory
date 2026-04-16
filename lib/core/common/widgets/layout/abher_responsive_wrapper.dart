import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AppResponsiveWrapper extends StatelessWidget {
  const AppResponsiveWrapper({super.key, this.child});
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return ResponsiveBreakpoints.builder(
      breakpoints: const [
        Breakpoint(start: 0, end: 450, name: MOBILE),
        Breakpoint(start: 451, end: 850, name: TABLET),
        Breakpoint(start: 851, end: 1920, name: DESKTOP),
        Breakpoint(start: 1921, end: double.infinity, name: '4K'),
      ],
      child: Builder(
        builder: (context) {
          return ResponsiveScaledBox(
            width: ResponsiveValue<double>(
              context,
              defaultValue: 450,
              conditionalValues: [
                const Condition.equals(name: MOBILE, value: 450),
                const Condition.equals(name: TABLET, value: 600),
                const Condition.equals(name: DESKTOP, value: 1200),
                const Condition.equals(name: "4k", value: 2300),
              ],
            ).value,
            child: child!,
          );
        },
      ),
    );
  }
}
