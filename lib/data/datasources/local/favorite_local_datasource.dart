import 'package:flutter_task_systems/core/helpers/app_logger.dart';
import 'package:flutter_task_systems/data/models/product_model.dart';
import 'package:hive/hive.dart';

class FavoriteLocalDatasource {
  static const String boxName = 'favorites';
  final HiveInterface hive;

  FavoriteLocalDatasource(this.hive);

  Future<void> addFavorite(Product? product) async {
    if (product == null) return;
    AppLogger.debug('Adding favorite: ${product.title}');
    try {
      final box = await hive.openBox<dynamic>(boxName);
      await box.put(product.id.toString(), product.toJson());
      AppLogger.debug('Favorite saved to Hive');
    } catch (e) {
      AppLogger.error('Error adding favorite: $e');
      rethrow;
    }
  }

  Future<void> removeFavorite(int productId) async {
    try {
      final box = await hive.openBox<dynamic>(boxName);
      AppLogger.debug('🗑Removing favorite: $productId');
      await box.delete(productId.toString());
      AppLogger.debug('Favorite removed from Hive');
    } catch (e) {
      AppLogger.error('  Error removing favorite: $e');
      rethrow;
    }
  }

  Future<bool> isFavorite(int productId) async {
    try {
      final box = await hive.openBox<dynamic>(boxName);
      final exists = box.containsKey(productId.toString());
      AppLogger.debug('Checking favorite...');
      return exists;
    } catch (e) {
      AppLogger.error('Error checking favorite: $e');
      return false;
    }
  }

  Future<List<Product>> getAllFavorites() async {
    try {
      final box = await hive.openBox<dynamic>(boxName);
      final favoritesData = box.values.toList();

      final products = <Product>[];

      for (final item in favoritesData) {
        try {
          final jsonData = _convertToStringDynamic(item);
          final product = Product.fromJson(jsonData);
          products.add(product);
          AppLogger.debug(' Parsed favorite: ${product.title}');
        } catch (e) {
          AppLogger.warning('Error parsing favorite: $e');
          AppLogger.warning('Item type: ${item.runtimeType}');
          continue;
        }
      }

      AppLogger.debug('uccessfully fetched');
      return products;
    } catch (e) {
      AppLogger.error('  Error getting all favorites: $e');
      return [];
    }
  }

  Future<void> clearAllFavorites() async {
    try {
      final box = await hive.openBox<dynamic>(boxName);
      AppLogger.debug('Clearing all favorites...');
      await box.clear();
      AppLogger.debug(' All favorites cleared');
    } catch (e) {
      AppLogger.error('Error clearing favorites: $e');
      rethrow;
    }
  }

  Map<String, dynamic> _convertToStringDynamic(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data;
    }

    if (data is Map) {
      final converted = <String, dynamic>{};
      data.forEach((key, value) {
        if (value is Map) {
          converted[key.toString()] = _convertToStringDynamic(value);
        } else if (value is List) {
          converted[key.toString()] = _convertListItems(value);
        } else {
          converted[key.toString()] = value;
        }
      });
      return converted;
    }

    throw TypeError();
  }

  List<dynamic> _convertListItems(List<dynamic> list) {
    return list.map((item) {
      if (item is Map) {
        return _convertToStringDynamic(item);
      } else if (item is List) {
        return _convertListItems(item);
      }
      return item;
    }).toList();
  }
}
