import 'package:flutter_task_systems/data/datasources/local/favorite_local_datasource.dart';
import 'package:flutter_task_systems/data/datasources/remote/product_remote_datasource.dart';
import 'package:flutter_task_systems/data/models/product_model.dart';

class ProductRepository {
  final ProductRemoteDatasource productApi;
  final FavoriteLocalDatasource favoriteDatasource;

  List<Product> _cachedProducts = [];

  ProductRepository(this.productApi, this.favoriteDatasource);

  Future<List<Product>> getProducts({int limit = 20}) async {
    try {
      return _cachedProducts = await productApi.fetchProducts(limit: limit);
    } catch (e) {
      if (_cachedProducts.isNotEmpty) {
        return _cachedProducts;
      }
      rethrow;
    }
  }

  Future<Product> getProductById(int id) async {
    try {
      return await productApi.fetchProductById(id);
    } catch (e) {
      // Try to find in cached products
      try {
        return _cachedProducts.firstWhere((p) => p.id == id);
      } catch (_) {
        rethrow;
      }
    }
  }

  Future<void> addToFavorites(Product? product) async {
    if (product == null) {
      return;
    }
    await favoriteDatasource.addFavorite(product);
  }

  Future<void> removeFromFavorites(int productId) async {
    await favoriteDatasource.removeFavorite(productId);
  }

  Future<bool> isFavorite(int productId) async {
    return favoriteDatasource.isFavorite(productId);
  }

  Future<List<Product>> getFavorites() async {
    return favoriteDatasource.getAllFavorites();
  }
}
