import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../controllers/cart_scope.dart';
import '../controllers/product_controller.dart';
import '../controllers/product_scope.dart';
import '../theme/theme_scope.dart';
import '../widgets/brand_filter_bar.dart';
import '../widgets/product_card.dart';

/// The Home screen: search bar, brand filter, price-range slider,
/// responsive product grid (data from Supabase), and pagination bar.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const String _all = 'All';

  final TextEditingController _searchController = TextEditingController();
  bool _priceFilterOpen = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeController = ThemeScope.of(context);
    final cartController = CartScope.of(context);
    final pc = ProductScope.of(context);
    final theme = Theme.of(context);
    final brands = [_all, ...pc.availableBrands];

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
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                tooltip: 'Cart',
                icon: const Icon(Icons.shopping_bag_outlined),
                onPressed: () => context.push('/cart'),
              ),
              if (cartController.totalItemCount > 0)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      '${cartController.totalItemCount}',
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // ── Search Field ──────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
                        onChanged: pc.updateSearch,
                        decoration: InputDecoration(
                          hintText: 'Search sneakers or brands...',
                          hintStyle: TextStyle(
                            color: theme.colorScheme.onSurface.withOpacity(0.45),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          prefixIcon: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            child: Icon(
                              Icons.search_rounded,
                              color: theme.colorScheme.primary,
                              size: 24,
                            ),
                          ),
                          suffixIcon: pc.searchQuery.isEmpty
                              ? null
                              : Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: IconButton(
                                    icon: const Icon(
                                        Icons.close_rounded,
                                        size: 22),
                                    onPressed: () {
                                      _searchController.clear();
                                      pc.updateSearch('');
                                    },
                                  ),
                                ),
                          filled: true,
                          fillColor: theme.colorScheme.surface,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 18),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: theme.colorScheme.primary
                                  .withOpacity(0.15),
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

                // ── Brand Filter Row ──────────────────────────────────────
                if (pc.availableBrands.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: BrandFilterBar(
                        brands: brands,
                        selected: pc.selectedBrand,
                        onSelected: pc.selectBrand,
                      ),
                    ),
                  ),

                // ── Price Filter Panel ────────────────────────────────────
                SliverToBoxAdapter(
                  child: _PriceFilterPanel(
                    isOpen: _priceFilterOpen,
                    controller: pc,
                    onToggle: () => setState(
                        () => _priceFilterOpen = !_priceFilterOpen),
                  ),
                ),

                // ── Stat Cards ────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: _SummaryStatCard(
                            label: 'Matching pairs',
                            value: pc.isLoading
                                ? '…'
                                : '${pc.totalCount}',
                            icon: Icons.inventory_2_outlined,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _SummaryStatCard(
                            label: 'Available brands',
                            value: '${pc.availableBrands.length}',
                            icon: Icons.sell_outlined,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Loading / Error / Empty / Grid ────────────────────────
                if (pc.isLoading)
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (pc.error != null)
                  SliverFillRemaining(
                    child: _ErrorState(
                      message: pc.error!,
                      onRetry: pc.fetchProducts,
                    ),
                  )
                else if (pc.products.isEmpty)
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
                            'No sneakers match your filters.',
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
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.68,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final product = pc.products[index];
                              return ProductCard(
                                product: product,
                                onTap: () => context
                                    .push('/product/${product.id}'),
                              );
                            },
                            childCount: pc.products.length,
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),

          // ── Pagination bar ────────────────────────────────────────────────
          _PaginationBar(controller: pc),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Price Filter Panel
// ════════════════════════════════════════════════════════════════════════════

class _PriceFilterPanel extends StatelessWidget {
  final bool isOpen;
  final ProductController controller;
  final VoidCallback onToggle;

  const _PriceFilterPanel({
    required this.isOpen,
    required this.controller,
    required this.onToggle,
  });

  String _fmt(double v) {
    final s = v.toStringAsFixed(0);
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final posFromEnd = s.length - i;
      buf.write(s[i]);
      if (posFromEnd > 1 && (posFromEnd - 1) % 3 == 0) buf.write(',');
    }
    return '₱${buf.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pc = controller;
    final isFiltered = pc.isPriceFiltered;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isFiltered
                ? theme.colorScheme.primary.withOpacity(0.5)
                : theme.colorScheme.outline.withOpacity(0.12),
            width: isFiltered ? 1.6 : 1.0,
          ),
        ),
        child: Column(
          children: [
            // Header
            InkWell(
              onTap: onToggle,
              borderRadius: isOpen
                  ? const BorderRadius.vertical(top: Radius.circular(16))
                  : BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.tune_rounded,
                        size: 18,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Price Range',
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '${_fmt(pc.priceRange.start)} – ${_fmt(pc.priceRange.end)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withOpacity(0.65),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isFiltered)
                      GestureDetector(
                        onTap: pc.resetPriceRange,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color:
                                theme.colorScheme.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Reset',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(width: 6),
                    AnimatedRotation(
                      turns: isOpen ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 280),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color:
                            theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Expandable body
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 260),
              firstCurve: Curves.easeOut,
              secondCurve: Curves.easeIn,
              crossFadeState: isOpen
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  children: [
                    Divider(
                      color: theme.colorScheme.outline.withOpacity(0.12),
                      height: 1,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _PriceLabel(
                          label: 'Min',
                          value: _fmt(pc.priceRange.start),
                          theme: theme,
                        ),
                        _PriceLabel(
                          label: 'Max',
                          value: _fmt(pc.priceRange.end),
                          theme: theme,
                          alignRight: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: theme.colorScheme.primary,
                        inactiveTrackColor:
                            theme.colorScheme.primary.withOpacity(0.18),
                        thumbColor: theme.colorScheme.primary,
                        overlayColor:
                            theme.colorScheme.primary.withOpacity(0.12),
                        rangeThumbShape:
                            const RoundRangeSliderThumbShape(
                                enabledThumbRadius: 10),
                        trackHeight: 4,
                      ),
                      child: RangeSlider(
                        min: pc.minPrice,
                        max: pc.maxPrice > pc.minPrice
                            ? pc.maxPrice
                            : pc.minPrice + 1,
                        values: RangeValues(
                          pc.priceRange.start.clamp(pc.minPrice, pc.maxPrice),
                          pc.priceRange.end.clamp(pc.minPrice, pc.maxPrice),
                        ),
                        divisions: 20,
                        // Update label live while dragging
                        onChanged: pc.updatePriceRange,
                        // Fire the Supabase query only when user lifts finger
                        onChangeEnd: (_) => pc.commitPriceRange(),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _fmt(pc.minPrice),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withOpacity(0.45),
                          ),
                        ),
                        Text(
                          _fmt(pc.maxPrice),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withOpacity(0.45),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              secondChild: const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceLabel extends StatelessWidget {
  final String label;
  final String value;
  final ThemeData theme;
  final bool alignRight;

  const _PriceLabel({
    required this.label,
    required this.value,
    required this.theme,
    this.alignRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Error State
// ════════════════════════════════════════════════════════════════════════════

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded,
                size: 48, color: theme.colorScheme.error.withOpacity(0.7)),
            const SizedBox(height: 12),
            Text(
              'Could not load products',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.55),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Pagination Bar
// ════════════════════════════════════════════════════════════════════════════

class _PaginationBar extends StatelessWidget {
  final ProductController controller;

  const _PaginationBar({required this.controller});

  List<int> _buildPageList(int current, int total) {
    if (total <= 7) return List.generate(total, (i) => i);
    final pages = <int>[0];
    if (current > 2) pages.add(-1);
    for (int i = (current - 1).clamp(1, total - 2);
        i <= (current + 1).clamp(1, total - 2);
        i++) {
      pages.add(i);
    }
    if (current < total - 3) pages.add(-1);
    pages.add(total - 1);
    return pages;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pc = controller;
    final total = pc.totalPages;
    final current = pc.currentPage;
    final visiblePages = _buildPageList(current, total);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
              color: theme.colorScheme.outline.withOpacity(0.12)),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _NavButton(
            icon: Icons.chevron_left_rounded,
            tooltip: 'Previous page',
            onPressed: current > 0 ? pc.previousPage : null,
          ),
          const SizedBox(width: 4),
          for (int page in visiblePages) ...[
            if (page == -1)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text('…',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    )),
              )
            else
              _PageButton(
                page: page,
                isSelected: page == current,
                onPressed: () => pc.goToPage(page),
              ),
          ],
          const SizedBox(width: 4),
          _NavButton(
            icon: Icons.chevron_right_rounded,
            tooltip: 'Next page',
            onPressed: current < total - 1 ? pc.nextPage : null,
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  const _NavButton(
      {required this.icon,
      required this.tooltip,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final enabled = onPressed != null;
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 36,
            height: 36,
            child: Icon(
              icon,
              size: 22,
              color: enabled
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withOpacity(0.25),
            ),
          ),
        ),
      ),
    );
  }
}

class _PageButton extends StatelessWidget {
  final int page;
  final bool isSelected;
  final VoidCallback onPressed;

  const _PageButton(
      {required this.page,
      required this.isSelected,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.primary
            : theme.colorScheme.surfaceVariant.withOpacity(0.6),
        borderRadius: BorderRadius.circular(8),
        border: isSelected
            ? null
            : Border.all(
                color: theme.colorScheme.outline.withOpacity(0.12)),
      ),
      child: InkWell(
        onTap: isSelected ? null : onPressed,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 36,
          height: 36,
          child: Center(
            child: Text(
              '${page + 1}',
              style: theme.textTheme.labelLarge?.copyWith(
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface,
                fontWeight:
                    isSelected ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Summary Stat Card
// ════════════════════════════════════════════════════════════════════════════

class _SummaryStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryStatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.12),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
