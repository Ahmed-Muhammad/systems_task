import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_systems/core/helpers/app_logger.dart';
import 'package:flutter_task_systems/data/datasources/local/product_local_datasource.dart';
import 'package:flutter_task_systems/data/models/product_model.dart';
import 'package:flutter_task_systems/data/repositories/product_repository.dart';
import 'package:get/get.dart';

class ProductListController extends GetxController {
  final ProductRepository repository;
  final ProductLocalDatasource productHiveDS;

  ProductListController(this.repository, this.productHiveDS);

  final products = <Product>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final error = ''.obs;
  final favorites = <int>[].obs;
  final isGridView = true.obs;
  final isDarkMode = false.obs;
  final isViewingFavorites = false.obs;

  final isOnline = true.obs;
  final isLoadingFromCache = false.obs;
  final isRefreshingAfterReconnect = false.obs;
  final cacheCount = 0.obs;

  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  int currentPage = 1;
  static const int pageSize = 10;

  @override
  void onInit() {
    super.onInit();
    AppLogger.debug('ProductListController initializing...');

    _initHiveDatasource();

    _initConnectivityListener();

    loadFavorites().then((_) {
      AppLogger.debug(' Favorites loaded, now loading products');
      loadProducts();
    });
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }

  Future<void> _initHiveDatasource() async {
    try {
      await productHiveDS.init();

      final count = await productHiveDS.getCacheCount();
      cacheCount.value = count;

      if (count > 0) {
      } else {
        AppLogger.debug('No products in cache yet');
      }
    } catch (e) {
      AppLogger.error('Error initializing Hive datasource: $e');
    }
  }

  void _initConnectivityListener() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        final wasOffline = !isOnline.value;
        isOnline.value = !results.contains(ConnectivityResult.none);

        AppLogger.debug('Connectivity changed: ${isOnline.value ? "ONLINE" : "OFFLINE"}');

        if (wasOffline && isOnline.value) {
          AppLogger.debug('Reconnected!...');
          _handleReconnection();
        }
      },
    );
  }

  Future<void> _handleReconnection() async {
    try {
      isRefreshingAfterReconnect.value = true;
      await refreshProducts();
      AppLogger.debug('Successfully refreshed after reconnection');
    } catch (e) {
      AppLogger.error('Failed to refresh after reconnection: $e');
    } finally {
      isRefreshingAfterReconnect.value = false;
    }
  }

  Future<void> loadProducts() async {
    try {
      isLoading.value = true;
      error.value = '';
      products.clear();

      if (isOnline.value) {
        AppLogger.debug('Loading products from API (ONLINE)...');
        final data = await repository.getProducts(limit: 100);
        products.assignAll(data);

        await productHiveDS.cacheProducts(data);
        cacheCount.value = data.length;
        isLoadingFromCache.value = false;
      } else {
        AppLogger.debug('Loading products from cache (OFFLINE)...');
        isLoadingFromCache.value = true;
        final cachedData = await productHiveDS.getAllCachedProducts();

        if (cachedData.isEmpty) {
          error.value = 'No cached data available. Please go online first.';
          AppLogger.debug('no Cache Data');
        } else {
          products.assignAll(cachedData);
          cacheCount.value = cachedData.length;
          AppLogger.debug(' Loaded ${cachedData.length} products from cache');
        }
      }
    } catch (e) {
      error.value = e.toString();
      AppLogger.error('Error loading products: $e');

      if (!isOnline.value) {
        await _loadFromCacheAsFallback();
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadFromCacheAsFallback() async {
    try {
      final cachedData = await productHiveDS.getAllCachedProducts();
      if (cachedData.isNotEmpty) {
        products.assignAll(cachedData);
        isLoadingFromCache.value = true;
        cacheCount.value = cachedData.length;
        error.value = '';
        AppLogger.debug('Loaded ${cachedData.length} products from cache');
      } else {
        error.value = 'No cached data available. Please check your connection.';
      }
    } catch (e) {
      AppLogger.error('  Cache fallback also failed: $e');
    }
  }

  Future<void> refreshProducts() async {
    try {
      error.value = '';

      if (!isOnline.value) {
        isLoadingFromCache.value = true;
        final cachedData = await productHiveDS.getAllCachedProducts();
        if (cachedData.isEmpty) {
          error.value = 'No cached data available';
        } else {
          products.assignAll(cachedData);
          cacheCount.value = cachedData.length;
        }
        return;
      }

      final data = await repository.getProducts(limit: 100);
      products.assignAll(data);

      await productHiveDS.cacheProducts(data);
      cacheCount.value = data.length;

      isLoadingFromCache.value = false;
      AppLogger.debug('Refreshed ${data.length} products');
    } catch (e) {
      error.value = e.toString();
      AppLogger.error('Error refreshing: $e');

      await _loadFromCacheAsFallback();
    }
  }

  /// Toggle favorite with offline support
  Future<void> toggleFavorite(Product product) async {
    try {
      final isFav = favorites.contains(product.id);

      if (isFav) {
        await repository.removeFromFavorites(product.id);
        favorites.remove(product.id);
        AppLogger.debug('Removed from favorites');
      } else {
        await repository.addToFavorites(product);
        favorites.add(product.id);
        AppLogger.debug('Added to favorites');
      }

      update();
    } catch (e) {
      error.value = 'Failed to update favorite: $e';
      AppLogger.error('  Error toggling favorite: $e');
    }
  }

  Future<void> loadFavorites() async {
    try {
      final favs = await repository.getFavorites();
      AppLogger.debug(' Found ${favs.length} favorites in Hive');
      favorites.assignAll(favs.map((p) => p.id));
      update();
    } catch (e) {
      AppLogger.error('Error loading favorites: $e');
    }
  }

  bool isFavorite(int productId) {
    return favorites.contains(productId);
  }

  Future<List<Product>> searchCachedProducts(String query) async {
    try {
      return await productHiveDS.searchCachedProducts(query);
    } catch (e) {
      AppLogger.error('Error searching products: $e');
      return [];
    }
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      return await productHiveDS.getByCategory(category);
    } catch (e) {
      AppLogger.error('Error getting products by category: $e');
      return [];
    }
  }

  Future<void> viewCacheStats() async {
    try {
      final stats = await productHiveDS.getCacheStats();
      AppLogger.debug('📊 Cache Stats: $stats');
    } catch (e) {
      AppLogger.error('Error getting cache stats: $e');
    }
  }

  Future<void> clearCache() async {
    try {
      await productHiveDS.clearCache();
      cacheCount.value = 0;
      AppLogger.debug('🗑️ Cache cleared');
    } catch (e) {
      AppLogger.error('Error clearing cache: $e');
    }
  }

  void toggleViewMode() {
    isGridView.toggle();
    AppLogger.debug('Toggling view mode: ${isGridView.value ? "Grid" : "List"}');
  }

  void toggleTheme() {
    isDarkMode.toggle();
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    AppLogger.debug('Toggling theme: ${isDarkMode.value ? "Dark" : "Light"}');
  }
}
