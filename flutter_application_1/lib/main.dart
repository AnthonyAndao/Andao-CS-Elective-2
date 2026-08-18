import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const FruitListScreen(),
      routes: [
        GoRoute(
          path: 'fruit/:name',
          builder: (context, state) {
            final fruitName = state.pathParameters['name'] ?? 'Unknown';
            return FruitDetailScreen(fruitName: fruitName);
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Fruit App',
      routerConfig: _router,
    );
  }
}

class FruitListScreen extends StatelessWidget {
  const FruitListScreen({super.key});

  final List<Map<String, String>> fruits = const [
    {'name': 'Guava', 'icon': '🍈'},
    {'name': 'Saging', 'icon': '🍌'},
    {'name': 'Mangosteen', 'icon': '🫐'},
    {'name': 'Ponkan', 'icon': '🍊'},
    {'name': 'Kamote', 'icon': '🍠'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fruits List'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: fruits.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final fruit = fruits[index];
            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  context.go('/fruit/${fruit['name']}');
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        fruit['icon']!,
                        style: const TextStyle(fontSize: 48),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        fruit['name']!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class FruitDetailScreen extends StatelessWidget {
  final String fruitName;

  const FruitDetailScreen({super.key, required this.fruitName});

  String _getFruitIllustration(String name) {
    switch (name.toLowerCase()) {
      case 'guava':
        return '🍈';
      case 'saging':
        return '🍌';
      case 'mangosteen':
        return '🫐';
      case 'ponkan':
        return '🍊';
      case 'kamote':
        return '🍠';
      default:
        return '🍓';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(fruitName),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _getFruitIllustration(fruitName),
              style: const TextStyle(fontSize: 120),
            ),
            const SizedBox(height: 20),
            Text(
              fruitName,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}