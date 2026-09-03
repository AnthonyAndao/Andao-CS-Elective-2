import 'package:flutter/material.dart';

import 'router.dart';
import 'theme/app_theme.dart';
import 'theme/theme_controller.dart';
import 'theme/theme_scope.dart';

void main() {
  runApp(const SoleMateApp());
}

/// Root widget. This is a [StatefulWidget] because it owns the
/// [ThemeController] instance for the whole app's lifetime — that instance
/// must survive rebuilds, so it's created once in [State.initState] rather
/// than fresh on every build.
class SoleMateApp extends StatefulWidget {
  const SoleMateApp({super.key});

  @override
  State<SoleMateApp> createState() => _SoleMateAppState();
}

class _SoleMateAppState extends State<SoleMateApp> {
  late final ThemeController _themeController;

  @override
  void initState() {
    super.initState();
    _themeController = ThemeController();
  }

  @override
  void dispose() {
    _themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeScope(
      controller: _themeController,
      child: AnimatedBuilder(
        animation: _themeController,
        builder: (context, _) {
          return MaterialApp.router(
            title: 'SoleMate',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: _themeController.mode,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
