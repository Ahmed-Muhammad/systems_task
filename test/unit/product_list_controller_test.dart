import 'package:flutter_task_systems/data/datasources/local/product_local_datasource.dart';
import 'package:flutter_task_systems/data/models/product_model.dart';
import 'package:flutter_task_systems/data/repositories/product_repository.dart';
import 'package:flutter_task_systems/presentation/controllers/product_list_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'product_list_controller_test.mocks.dart';

@GenerateMocks([ProductRepository, ProductLocalDatasource])
void main() {
  group('ProductListController Tests', () {
    late ProductListController controller;
    late MockProductRepository mockRepository;
    late MockProductLocalDatasource mockHiveDS;

    setUp(() {
      mockRepository = MockProductRepository();
      mockHiveDS = MockProductLocalDatasource();
      controller = ProductListController(mockRepository, mockHiveDS);
      when(mockHiveDS.init()).thenAnswer((_) async {});
      when(mockHiveDS.getCacheCount()).thenAnswer((_) async => 0);

    });

    tearDown(() {
      controller.onClose();
    });

    test('loadProducts should fetch and assign products on success', () async {
      // Arrange
      final mockProducts = [
        const Product(
          id: 1,
          title: 'Test Product 1',
          price: 29.99,
          image: 'https://example.com/1.jpg',
          category: 'electronics',
          description: "description",
          rating: ProductRating(rate: 4.5, count: 100),
        ),
        const Product(
          id: 2,
          description: "description",

          title: 'Test Product 2',
          price: 39.99,
          image: 'https://example.com/2.jpg',
          category: 'clothing',
          rating: ProductRating(rate: 4.2, count: 50),
        ),
      ];

      when(mockRepository.getProducts(limit: 100)).thenAnswer((_) async => mockProducts);
      when(mockHiveDS.cacheProducts(mockProducts)).thenAnswer((_) async => true);

      // Act
      await controller.loadProducts();

      // Assert
      expect(controller.products.length, 2);
      expect(controller.products[0].title, 'Test Product 1');
      expect(controller.products[1].title, 'Test Product 2');
      expect(controller.isLoading.value, false);
      expect(controller.error.value, '');
    });

    test('toggleFavorite should add product to favorites', () async {
      // Arrange
      const product = Product(
        id: 1,
        title: 'Favorite Test',
        price: 49.99,
        image: 'https://example.com/fav.jpg',
        category: 'electronics',
        rating: ProductRating(rate: 4.7, count: 200),
        description: 'some text ',
      );

      when(mockRepository.addToFavorites(product)).thenAnswer((_) async => true);

      // Act
      await controller.toggleFavorite(product);

      // Assert
      expect(controller.favorites.contains(product.id), true);
      verify(mockRepository.addToFavorites(product)).called(1);
    });

    test('toggleFavorite should remove product from favorites', () async {
      // Arrange
      const product = Product(
        id: 1,
        title: 'Test',
        price: 29.99,
        description: "description",

        image: 'https://example.com/test.jpg',
        category: 'test',
        rating: ProductRating(rate: 4.0, count: 10),
      );

      controller.favorites.add(product.id);

      when(mockRepository.removeFromFavorites(product.id)).thenAnswer((_) async => true);

      // Act
      await controller.toggleFavorite(product);

      // Assert
      expect(controller.favorites.contains(product.id), false);
      verify(mockRepository.removeFromFavorites(product.id)).called(1);
    });

    test('isFavorite should return true for favorite products', () {
      // Arrange
      controller.favorites.add(1);

      // Act & Assert
      expect(controller.isFavorite(1), true);
      expect(controller.isFavorite(2), false);
    });

    test('toggleViewMode should toggle grid view', () {
      // Arrange
      final initialState = controller.isGridView.value;

      // Act
      controller.toggleViewMode();

      // Assert
      expect(controller.isGridView.value, !initialState);
    });

    test('loadProducts should handle offline mode', () async {
      // Arrange
      controller.isOnline.value = false;
      final cachedProducts = [
        const Product(
          id: 1,
          title: 'Cached Product',
          description: "description",

          price: 19.99,
          image: 'https://example.com/cached.jpg',
          category: 'books',
          rating: ProductRating(rate: 3.8, count: 75),
        ),
      ];

      when(mockHiveDS.getAllCachedProducts()).thenAnswer((_) async => cachedProducts);

      // Act
      await controller.loadProducts();

      // Assert
      expect(controller.products.length, 1);
      expect(controller.isLoadingFromCache.value, true);
      expect(controller.products[0].title, 'Cached Product');
    });

    test('loadProducts should set error when offline and no cache', () async {
      // Arrange
      controller.isOnline.value = false;
      when(mockHiveDS.getAllCachedProducts()).thenAnswer((_) async => []);

      // Act
      await controller.loadProducts();

      // Assert
      expect(controller.error.value, isNotEmpty);
      expect(controller.products.isEmpty, true);
    });

    test('clearCache should clear cache and reset count', () async {
      // Arrange
      controller.cacheCount.value = 10;
      when(mockHiveDS.clearCache()).thenAnswer((_) async => true);

      // Act
      await controller.clearCache();

      // Assert
      expect(controller.cacheCount.value, 0);
      verify(mockHiveDS.clearCache()).called(1);
    });

    test('refreshProducts should update products from repository', () async {
      // Arrange
      controller.isOnline.value = true;
      final newProducts = [
        const Product(
          id: 3,
          title: 'Refreshed Product',
          description: "description",

          price: 59.99,
          image: 'https://example.com/refresh.jpg',
          category: 'home',
          rating: ProductRating(rate: 4.9, count: 150),
        ),
      ];

      when(mockRepository.getProducts(limit: 100)).thenAnswer((_) async => newProducts);
      when(mockHiveDS.cacheProducts(newProducts)).thenAnswer((_) async => true);

      // Act
      await controller.refreshProducts();

      // Assert
      expect(controller.products.length, 1);
      expect(controller.products[0].title, 'Refreshed Product');
      expect(controller.error.value, '');
    });
  });
}
