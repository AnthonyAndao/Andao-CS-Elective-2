import 'package:flutter/material.dart';
import 'theme_controller.dart';

/// Makes the app's single [ThemeController] reachable from any screen
/// (e.g. the toggle button in Home's AppBar) via `ThemeScope.of(context)`,
/// without passing it manually through go_router's route builders.
class ThemeScope extends InheritedNotifier<ThemeController> {
  const ThemeScope({
    super.key,
    required ThemeController controller,
    required super.child,
  }) : super(notifier: controller);

  static ThemeController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ThemeScope>();
    assert(scope != null, 'ThemeScope not found in widget tree');
    return scope!.notifier!;
  }
}
