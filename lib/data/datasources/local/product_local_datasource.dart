import 'package:flutter_task_systems/core/helpers/app_logger.dart';
import 'package:flutter_task_systems/data/models/product_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ProductLocalDatasource {
  static const String _boxName = 'products_cache';
  late Box<Product> _productBox;

  Future<void> init() async {
    try {
      _productBox = await Hive.openBox<Product>(_boxName);
    } catch (e) {
      AppLogger.error('Error initializing ProductHiveDatasource: $e');
      rethrow;
    }
  }

  Future<void> cacheProducts(List<Product> products) async {
    try {
      await _productBox.clear();

      for (int i = 0; i < products.length; i++) {
        await _productBox.put(i, products[i]);
      }

      AppLogger.debug('Cached ${products.length} products to Hive');
    } catch (e) {
      AppLogger.error('  Error caching products: $e');
      rethrow;
    }
  }

  Future<List<Product>> getAllCachedProducts() async {
    try {
      if (_productBox.isEmpty) {
        AppLogger.debug('Product cache is empty');
        return [];
      }

      final cachedProducts = _productBox.values.toList();
      AppLogger.debug(' Retrieved ${cachedProducts.length} products from cache');
      return cachedProducts;
    } catch (e) {
      AppLogger.error('  Error retrieving cached products: $e');
      return [];
    }
  }

  Future<Product?> getProductById(int productId) async {
    try {
      final products = _productBox.values.toList();
      final product = products.firstWhereOrNull((p) => p.id == productId);

      if (product != null) {
        AppLogger.debug('Found product $productId in cache');
      }

      return product;
    } catch (e) {
      AppLogger.error('Error getting product by ID: $e');
      return null;
    }
  }

  Future<bool> isProductCached(int productId) async {
    try {
      final products = _productBox.values.toList();
      return products.any((p) => p.id == productId);
    } catch (e) {
      AppLogger.error('Error checking if product cached: $e');
      return false;
    }
  }

  Future<int> getCacheCount() async {
    try {
      return _productBox.length;
    } catch (e) {
      AppLogger.error('Error getting cache count: $e');
      return 0;
    }
  }

  Future<void> clearCache() async {
    try {
      await _productBox.clear();
      AppLogger.debug('Cleared all cached products');
    } catch (e) {
      AppLogger.error('Error clearing cache: $e');
      rethrow;
    }
  }

  Future<List<Product>> searchCachedProducts(String query) async {
    try {
      final allProducts = _productBox.values.toList();
      final results = allProducts.where((p) => p.title.toLowerCase().contains(query.toLowerCase())).toList();

      AppLogger.debug('🔍 Found ${results.length} products matching "$query"');
      return results;
    } catch (e) {
      AppLogger.error('  Error searching cached products: $e');
      return [];
    }
  }

  Future<List<Product>> getByCategory(String category) async {
    try {
      final allProducts = _productBox.values.toList();
      final results = allProducts.where((p) => p.category.toLowerCase() == category.toLowerCase()).toList();

      AppLogger.debug('📂 Found ${results.length} products in category: $category');
      return results;
    } catch (e) {
      AppLogger.error('  Error getting products by category: $e');
      return [];
    }
  }

  Future<void> updateCache(List<Product> newProducts) async {
    try {
      final existing = _productBox.values.toList();
      final Map<int, Product> productMap = {};

      for (int i = 0; i < existing.length; i++) {
        productMap[i] = existing[i];
      }

      for (int i = 0; i < newProducts.length; i++) {
        productMap[i] = newProducts[i];
      }

      await _productBox.clear();
      for (final entry in productMap.entries) {
        await _productBox.put(entry.key, entry.value);
      }

      AppLogger.debug('Updated cache with ${newProducts.length} products');
    } catch (e) {
      AppLogger.error('Error updating cache: $e');
      rethrow;
    }
  }

  DateTime? getLastUpdated() {
    try {
      if (_productBox.isEmpty) return null;
      return DateTime.now();
    } catch (e) {
      AppLogger.error('  Error getting last updated: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> getCacheStats() async {
    try {
      final products = _productBox.values.toList();
      final categories = products.map((p) => p.category).toSet().length;
      final avgRating = products.isEmpty ? 0.0 : products.fold<double>(0, (sum, p) => sum + p.rating.rate) / products.length;

      return {
        'totalProducts': products.length,
        'categories': categories,
        'averageRating': avgRating.toStringAsFixed(2),
        'lastUpdated': DateTime.now(),
      };
    } catch (e) {
      AppLogger.error('  Error getting cache stats: $e');
      return {};
    }
  }

  Future<bool> hasCachedData() async {
    try {
      return _productBox.isNotEmpty;
    } catch (e) {
      AppLogger.error('  Error checking cached data: $e');
      return false;
    }
  }
}

extension IterableExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    try {
      for (final T element in this) {
        if (test(element)) return element;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
