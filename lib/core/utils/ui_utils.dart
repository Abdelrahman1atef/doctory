import 'package:flutter/material.dart';

/// Utilities for UI-related operations
class UiUtils {
  UiUtils._();

  /// Rebuild all children of a context
  static void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  /// Fix RTL issues with the last character in a text field
  static void fixRtlLastChar(TextEditingController? controller) {
    if (controller != null) {
      if (controller.selection ==
          TextSelection.fromPosition(
            TextPosition(offset: (controller.text.length) - 1),
          )) {
        controller.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length),
        );
      }
    }
  }
}
