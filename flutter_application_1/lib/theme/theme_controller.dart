import 'package:flutter/material.dart';

/// Holds the current [ThemeMode] and notifies listeners when it changes.
///
/// This is a StatefulWidget's natural companion: the toggle button in the
/// Home AppBar is what *changes* this value, so the value itself lives in
/// a ChangeNotifier rather than being hardcoded — that's what lets the
/// whole app's appearance flip instantly when the user taps the toggle.
class ThemeController extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.light;

  ThemeMode get mode => _mode;
  bool get isDark => _mode == ThemeMode.dark;

  void toggle() {
    _mode = isDark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}
