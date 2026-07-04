import 'package:doctory/core/common/models/role.dart';
import 'package:doctory/core/session/user_session.dart';
import 'package:flutter/material.dart';

class PermissionGate extends StatelessWidget {
  final Permission permission;
  final Widget child;
  final Widget? fallback;

  const PermissionGate({
    super.key,
    required this.permission,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    final permissions = UserSession.currentPermissions;
    if (permissions != null && permissions.contains(permission)) {
      return child;
    }
    return fallback ?? const SizedBox.shrink();
  }
}
