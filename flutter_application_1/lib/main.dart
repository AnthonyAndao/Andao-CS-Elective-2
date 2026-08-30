import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

void main() => runApp(const MyApp());

bool get isIOS => !kIsWeb && Platform.isIOS;
bool get isAndroid => !kIsWeb && Platform.isAndroid;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Responsive & Adaptive Wireframe Dashboard',
      theme: ThemeData(useMaterial3: true),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (isIOS) {
      return const CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Dashboard'),
        ),
        child: SafeArea(child: _ResponsiveBody()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: const _ResponsiveBody(),
      floatingActionButton: kIsWeb
          ? null
          : FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add),
            ),
    );
  }
}

class _ResponsiveBody extends StatelessWidget {
  const _ResponsiveBody();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width < 600) {
          return const _MobileLayout();
        } else if (width < 1024) {
          return const _TabletLayout();
        } else {
          return const _DesktopLayout();
        }
      },
    );
  }
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        _WireBox(height: 60),
        SizedBox(height: 12),
        _WireBox(height: 60),
        SizedBox(height: 12),
        _WireBox(height: 60),
        SizedBox(height: 20),
        _WireBox(height: 160),
        SizedBox(height: 12),
        _WireBox(height: 100),
      ],
    );
  }
}

class _TabletLayout extends StatelessWidget {
  const _TabletLayout();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _WireSidebar(collapsed: true),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Row(
                  children: [
                    Expanded(child: _WireBox(height: 90)),
                    SizedBox(width: 12),
                    Expanded(child: _WireBox(height: 90)),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: const [
                      _WireBox(),
                      _WireBox(),
                      _WireBox(),
                      _WireBox(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _WireSidebar(collapsed: false),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Row(
                  children: [
                    Expanded(child: _WireBox(height: 100)),
                    SizedBox(width: 16),
                    Expanded(child: _WireBox(height: 100)),
                    SizedBox(width: 16),
                    Expanded(child: _WireBox(height: 100)),
                    SizedBox(width: 16),
                    Expanded(child: _WireBox(height: 100)),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    children: const [
                      _WireBox(height: 60),
                      SizedBox(height: 12),
                      _WireBox(height: 60),
                      SizedBox(height: 12),
                      _WireBox(height: 60),
                      SizedBox(height: 12),
                      _WireBox(height: 60),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 24, 24, 24),
            child: Column(
              children: const [
                _WireBox(height: 220),
                SizedBox(height: 16),
                _WireBox(height: 140),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _WireBox extends StatelessWidget {
  final double? height;

  const _WireBox({this.height});

  @override
  Widget build(BuildContext context) {
    final radius = isIOS ? 12.0 : 6.0;
    final color =
        isIOS ? CupertinoColors.systemGrey5 : Colors.grey.shade300;

    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class _WireSidebar extends StatelessWidget {
  final bool collapsed;

  const _WireSidebar({required this.collapsed});

  @override
  Widget build(BuildContext context) {
    final items = [
      Icons.home,
      Icons.settings,
      Icons.info_outline,
      Icons.logout,
    ];

    return Container(
      width: collapsed ? 70 : 220,
      color: isIOS ? CupertinoColors.systemGrey6 : Colors.grey.shade200,
      padding: const EdgeInsets.symmetric(
        vertical: 24,
        horizontal: 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isIOS ? CupertinoIcons.circle_fill : Icons.circle,
            size: 28,
            color: Colors.grey.shade600,
          ),
          const SizedBox(height: 28),
          for (final icon in items) ...[
            Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: Colors.grey.shade700,
                ),
                if (!collapsed) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }
}