// import 'package:flutter_task_systems/data/models/product_model.dart';
// import 'package:flutter_task_systems/data/repositories/product_repository.dart';
// import 'package:flutter_task_systems/presentation/controllers/product_list_controller.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
//
// // Generate mocks with build_runner
// class MockProductRepository extends Mock implements ProductRepository {}
//
// void main() {
//   late ProductListController controller;
//   late MockProductRepository mockRepository;
//
//   // Sample test data
//   final testProducts = [
//     const Product(
//       id: 1,
//       title: 'Test Product 1',
//       price: 99.99,
//       category: 'electronics',
//       description: 'A test product',
//       image: 'https://via.placeholder.com/200',
//       rating: ProductRating(rate: 4.5, count: 100),
//     ),
//     const Product(
//       id: 2,
//       title: 'Test Product 2',
//       price: 49.99,
//       category: 'books',
//       description: 'Another test product',
//       image: 'https://via.placeholder.com/200',
//       rating: ProductRating(rate: 4.0, count: 50),
//     ),
//   ];
//
//   group('ProductListController', () {
//     setUp(() {
//       mockRepository = MockProductRepository();
//       controller = ProductListController(mockRepository);
//     });
//
//     test('loadProducts loads all products at once', () async {
//       // Setup mock BEFORE calling the method
//       when(mockRepository.getProducts(limit: 100))
//           .thenAnswer((_) async => testProducts);
//
//       // Act
//       await controller.loadProducts();
//
//       // Assert
//       expect(controller.products.length, 2);
//       expect(controller.products[0].title, 'Test Product 1');
//       expect(controller.products[1].title, 'Test Product 2');
//       expect(controller.isLoading.value, false);
//       verify(mockRepository.getProducts(limit: 100)).called(1);
//     });
//
//     test('loadProducts shows error on failure', () async {
//       // Setup mock
//       when(mockRepository.getProducts(limit: 100))
//           .thenThrow(Exception('Network error'));
//
//       // Act
//       await controller.loadProducts();
//
//       // Assert
//       expect(controller.error.value.isNotEmpty, true);
//       expect(controller.products.isEmpty, true);
//       expect(controller.isLoading.value, false);
//     });
//
//     test('refreshProducts reloads all products', () async {
//       // Setup first call
//       when(mockRepository.getProducts(limit: 100))
//           .thenAnswer((_) async => testProducts);
//
//       // First load
//       await controller.loadProducts();
//       expect(controller.products.length, 2);
//
//       // Create new products for refresh
//       final newProducts = [
//         testProducts[0],
//         testProducts[1],
//         const Product(
//           id: 3,
//           title: 'New Product',
//           price: 29.99,
//           category: 'clothing',
//           description: 'A new product',
//           image: 'https://via.placeholder.com/200',
//           rating: ProductRating(rate: 5.0, count: 10),
//         ),
//       ];
//
//       // Setup second call (for refresh)
//       when(mockRepository.getProducts(limit: 100))
//           .thenAnswer((_) async => newProducts);
//
//       // Act refresh
//       await controller.refreshProducts();
//
//       // Assert
//       expect(controller.products.length, 3);
//       expect(controller.products[2].title, 'New Product');
//     });
//
//     test('toggleFavorite adds product to favorites', () async {
//       // Setup mock
//       when(mockRepository.addToFavorites(any))
//           .thenAnswer((_) async => {});
//       when(mockRepository.getFavorites()).thenAnswer((_) async => []);
//
//       // Act
//       await controller.toggleFavorite(testProducts[0]);
//
//       // Assert
//       expect(controller.favorites.contains(1), true);
//       verify(mockRepository.addToFavorites(any)).called(1);
//     });
//
//     test('toggleFavorite removes product from favorites', () async {
//       // Arrange
//       controller.favorites.add(1);
//       when(mockRepository.removeFromFavorites(1))
//           .thenAnswer((_) async => {});
//
//       // Act
//       await controller.toggleFavorite(testProducts[0]);
//
//       // Assert
//       expect(controller.favorites.contains(1), false);
//       verify(mockRepository.removeFromFavorites(1)).called(1);
//     });
//
//     test('loadFavorites loads saved favorites', () async {
//       // Setup mock
//       when(mockRepository.getFavorites())
//           .thenAnswer((_) async => [testProducts[0]]);
//
//       // Act
//       await controller.loadFavorites();
//
//       // Assert
//       expect(controller.favorites.length, 1);
//       expect(controller.favorites.contains(1), true);
//       verify(mockRepository.getFavorites()).called(1);
//     });
//
//     test('isFavorite returns correct state', () {
//       // Arrange
//       controller.favorites.add(1);
//
//       // Act & Assert
//       expect(controller.isFavorite(1), true);
//       expect(controller.isFavorite(2), false);
//     });
//
//     test('toggleViewMode toggles between grid and list', () {
//       // Arrange
//       expect(controller.isGridView.value, true);
//
//       // Act
//       controller.toggleViewMode();
//
//       // Assert
//       expect(controller.isGridView.value, false);
//
//       // Act again
//       controller.toggleViewMode();
//
//       // Assert
//       expect(controller.isGridView.value, true);
//     });
//
//     test('toggleTheme toggles between dark and light', () {
//       // Arrange
//       expect(controller.isDarkMode.value, false);
//
//       // Act
//       controller.toggleTheme();
//
//       // Assert
//       expect(controller.isDarkMode.value, true);
//
//       // Act again
//       controller.toggleTheme();
//
//       // Assert
//       expect(controller.isDarkMode.value, false);
//     });
//
//     test('loadFavorites handles empty favorites', () async {
//       // Setup mock
//       when(mockRepository.getFavorites()).thenAnswer((_) async => []);
//
//       // Act
//       await controller.loadFavorites();
//
//       // Assert
//       expect(controller.favorites.isEmpty, true);
//       verify(mockRepository.getFavorites()).called(1);
//     });
//
//     test('loadFavorites handles error gracefully', () async {
//       // Setup mock to throw
//       when(mockRepository.getFavorites())
//           .thenThrow(Exception('Hive error'));
//
//       // Act - should not throw
//       await controller.loadFavorites();
//
//       // Assert - favorites remain empty
//       expect(controller.favorites.isEmpty, true);
//     });
//
//     test('loadProducts clears previous products', () async {
//       // Arrange
//       controller.products.add(testProducts[0]);
//       expect(controller.products.length, 1);
//
//       when(mockRepository.getProducts(limit: 100))
//           .thenAnswer((_) async => [testProducts[1]]);
//
//       // Act
//       await controller.loadProducts();
//
//       // Assert
//       expect(controller.products.length, 1);
//       expect(controller.products[0].id, 2);
//     });
//   });
// }
