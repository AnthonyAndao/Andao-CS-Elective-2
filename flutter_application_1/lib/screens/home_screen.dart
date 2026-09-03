import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/products.dart';
import '../models/product.dart';
import '../theme/theme_scope.dart';
import '../widgets/brand_filter_bar.dart';
import '../widgets/product_card.dart';

/// The Home screen: hero header, search, brand filter row, and a
/// responsive product grid.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const String _all = 'All';

  String _selectedBrand = _all;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Product> get _filteredProducts {
    return products.where((p) {
      final matchesBrand = _selectedBrand == _all || p.brand == _selectedBrand;
      final matchesSearch = _searchQuery.isEmpty ||
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.brand.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesBrand && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final themeController = ThemeScope.of(context);
    final theme = Theme.of(context);
    final brands = [_all, ...availableBrands];
    final filtered = _filteredProducts;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.local_fire_department_rounded,
                color: theme.colorScheme.onPrimary,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'SoleMate',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: themeController.isDark
                ? 'Switch to light mode'
                : 'Switch to dark mode',
            icon: Icon(
              themeController.isDark
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_outlined,
            ),
            onPressed: themeController.toggle,
          ),
          IconButton(
            tooltip: 'Cart',
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cart coming in the next milestone'),
                ),
              );
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ---- Cleaned Hero Header ----
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.tertiaryContainer,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.35),
                    blurRadius: 25,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top Authenticated Tag
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: theme.colorScheme.onPrimary
                                  .withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.verified_rounded,
                                size: 14,
                                color: theme.colorScheme.onPrimary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'AUTHENTICATED',
                                style: TextStyle(
                                  color: theme.colorScheme.onPrimary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Title & Subtitle
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Find Your\nNext Pair.',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w900,
                            height: 1.05,
                            letterSpacing: -0.8,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${products.length} exclusive drops available',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onPrimary
                                .withOpacity(0.85),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    // Stat Pills
                    Row(
                      children: [
                        _HeroStatPill(
                          icon: Icons.inventory_2_outlined,
                          text: '${products.length} Pairs',
                        ),
                        const SizedBox(width: 8),
                        _HeroStatPill(
                          icon: Icons.sell_outlined,
                          text: '${availableBrands.length} Brands',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ---- Enlarged Search Field ----
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Search sneakers or brands...',
                    hintStyle: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.45),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Icon(
                        Icons.search_rounded,
                        color: theme.colorScheme.primary,
                        size: 24,
                      ),
                    ),
                    suffixIcon: _searchQuery.isEmpty
                        ? null
                        : Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: IconButton(
                              icon: const Icon(Icons.close_rounded, size: 22),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            ),
                          ),
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                    contentPadding: const EdgeInsets.symmetric(vertical: 18),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: theme.colorScheme.primary.withOpacity(0.15),
                        width: 1.2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: theme.colorScheme.primary,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ---- Brand Filter Row ----
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: BrandFilterBar(
                brands: brands,
                selected: _selectedBrand,
                onSelected: (brand) => setState(() => _selectedBrand = brand),
              ),
            ),
          ),

          // ---- Section Header + Result Count ----
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedBrand == _all ? 'Featured Kicks' : _selectedBrand,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${filtered.length} ${filtered.length == 1 ? 'pair' : 'pairs'}',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ---- Responsive Product Grid (or empty state) ----
          if (filtered.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: Column(
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: 44,
                      color: theme.colorScheme.primary.withOpacity(0.6),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No sneakers match your search.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverLayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.crossAxisExtent;
                  final int crossAxisCount = width >= 900
                      ? 4
                      : width >= 600
                          ? 3
                          : 2;

                  return SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.68,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = filtered[index];
                        return ProductCard(
                          product: product,
                          onTap: () => context.push('/product/${product.id}'),
                        );
                      },
                      childCount: filtered.length,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

/// Compact stat pill widget used within the hero header.
class _HeroStatPill extends StatelessWidget {
  final IconData icon;
  final String text;

  const _HeroStatPill({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: theme.colorScheme.onPrimary),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}