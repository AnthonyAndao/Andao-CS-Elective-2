import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/product.dart';

/// Number of products shown per page (matches the 6–8 requirement).
const int kProductsPerPage = 6;

/// Central async state controller for the product catalogue.
///
/// Data source
/// -----------
/// Every fetch hits Supabase with:
/// ```
/// .from('products')
/// .select('*', FetchOptions(count: CountOption.exact))
/// .gte('price', min)          ← price range low
/// .lte('price', max)          ← price range high
/// .eq('brand', brand)         ← brand filter  (skipped when "All")
/// .or('name.ilike.%q%,...')   ← search        (skipped when empty)
/// .range(from, to)            ← pagination slice
/// .order('price')
/// ```
/// The `count: CountOption.exact` header makes Supabase return the total
/// matching-row count in the response, so we always know how many pages
/// there are without a second round-trip.
class ProductController extends ChangeNotifier {
  final SupabaseClient _db = Supabase.instance.client;

  // ── Filter state ──────────────────────────────────────────────────────────

  String _selectedBrand = 'All';
  String _searchQuery = '';

  double minPrice = 0;
  double maxPrice = 25000;
  RangeValues _priceRange = const RangeValues(0, 25000);

  // ── Pagination state ──────────────────────────────────────────────────────

  int _currentPage = 0;
  int _totalCount = 0;

  // ── Data & async state ────────────────────────────────────────────────────

  List<Product> _products = [];
  List<String> _availableBrands = [];
  bool _isLoading = false;
  String? _error;

  // ── Constructor ───────────────────────────────────────────────────────────

  ProductController() {
    _initialize();
  }

  Future<void> _initialize() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _fetchCatalogueMeta();
      await fetchProducts();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Getters ───────────────────────────────────────────────────────────────

  String get selectedBrand => _selectedBrand;
  String get searchQuery => _searchQuery;
  RangeValues get priceRange => _priceRange;
  int get currentPage => _currentPage;
  int get totalCount => _totalCount;
  List<Product> get products => _products;
  List<String> get availableBrands => _availableBrands;
  bool get isLoading => _isLoading;
  String? get error => _error;

  int get totalPages =>
      (_totalCount / kProductsPerPage).ceil().clamp(1, 999);

  bool get isPriceFiltered =>
      _priceRange.start > minPrice || _priceRange.end < maxPrice;

  // ── Supabase fetches ──────────────────────────────────────────────────────

  /// Fetches price bounds and brand list in a single clean query.
  Future<void> _fetchCatalogueMeta() async {
    final res = await _db.from('products').select('brand, price');
    final rows = res as List<dynamic>;

    if (rows.isNotEmpty) {
      // Brands
      final brands = rows
          .map((e) => e['brand'] as String)
          .toSet()
          .toList()
        ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
      _availableBrands = brands;

      // Prices: calculate actual bounds from database rows
      final prices = rows.map((e) => (e['price'] as num).toDouble()).toList();
      final lowest = prices.reduce((a, b) => a < b ? a : b);
      final highest = prices.reduce((a, b) => a > b ? a : b);

      // Floor min and ceil max for clean round-number slider bounds
      minPrice = (lowest / 1000).floor() * 1000.0;     // e.g. 4000.0
      maxPrice = ((highest / 1000).ceil() * 1000.0) + 1000.0; // e.g. 23000.0

      if (minPrice >= maxPrice) {
        maxPrice = minPrice + 10000;
      }

      // Default price range spans all products
      _priceRange = RangeValues(minPrice, maxPrice);
    }
  }

  /// Main query — applies all active filters + pagination.
  ///
  /// Uses two queries (v2 API):
  /// • `filtered().count(CountOption.exact)` → total matching rows
  /// • `filtered().order('price', ascending: true).range(from, to)` → page data
  Future<void> fetchProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final from = _currentPage * kProductsPerPage;
      final to = from + kProductsPerPage - 1; // Supabase range is inclusive

      // ── Local helper: returns a fresh filter builder with all active
      //    filters applied. Called twice so both queries stay identical.
      PostgrestFilterBuilder<List<Map<String, dynamic>>> filtered() {
        var q = _db
            .from('products')
            .select()
            .gte('price', _priceRange.start)
            .lte('price', _priceRange.end);
        if (_selectedBrand != 'All') {
          q = q.eq('brand', _selectedBrand);
        }
        if (_searchQuery.isNotEmpty) {
          q = q.or(
            'name.ilike.%${_searchQuery}%,brand.ilike.%${_searchQuery}%',
          );
        }
        return q;
      }

      // ── 1. Total count ────────────────────────────────────────────────
      final countRes = await filtered().count(CountOption.exact);
      _totalCount = countRes.count ?? 0;

      // ── 2. Paginated page data ─────────────────────────────────────────
      final data = await filtered()
          .order('price', ascending: true)
          .range(from, to);
      _products = data.map((e) => Product.fromJson(e)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Mutation helpers ──────────────────────────────────────────────────────

  void selectBrand(String brand) {
    if (_selectedBrand == brand) return;
    _selectedBrand = brand;
    _resetPage();
    fetchProducts();
  }

  void updateSearch(String query) {
    _searchQuery = query;
    _resetPage();
    fetchProducts();
  }

  void updatePriceRange(RangeValues range) {
    _priceRange = range;
    // We deliberately do NOT trigger a fetch on every slider tick — we wait
    // for onChangeEnd (called in home_screen via [onChangedEnd]).
    notifyListeners();
  }

  /// Called when the user lifts their finger off the slider.
  void commitPriceRange() {
    _resetPage();
    fetchProducts();
  }

  void resetPriceRange() {
    _priceRange = RangeValues(minPrice, maxPrice);
    _resetPage();
    fetchProducts();
  }

  void goToPage(int page) {
    final clamped = page.clamp(0, totalPages - 1);
    if (_currentPage == clamped) return;
    _currentPage = clamped;
    fetchProducts();
  }

  void nextPage() => goToPage(_currentPage + 1);
  void previousPage() => goToPage(_currentPage - 1);

  void _resetPage() => _currentPage = 0;
}
