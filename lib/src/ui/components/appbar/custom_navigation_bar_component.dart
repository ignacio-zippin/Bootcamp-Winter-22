import 'package:flutter/material.dart';
import 'package:playground_app/src/ui/components/appbar/navigation_bar_component.dart';

simpleNavigationBar({
  String title = "",
  Function? onMenu,
  VoidCallback? onBack,
  VoidCallback? onCancel,
  Function? onInfo,
  Function? onNotification,
  bool hideNotificationButton = false,
  bool hideInfoButton = false,
}) {
  return NavigationBarComponent(
    title: title,
    hasBack: onBack != null && onMenu == null,
    hasCancel: onCancel != null,
    onMenuClick: onMenu,
    onBackClick: onBack,
    onCancelClick: onCancel,
    onInfo: onInfo,
    onNotification: onNotification,
    hideInfoButton: hideInfoButton,
    hideNotificationButton: hideNotificationButton,
  );
}
