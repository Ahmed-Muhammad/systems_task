// import 'package:flutter_task_systems/data/datasources/local/favorite_local_datasource.dart';
// import 'package:flutter_task_systems/data/datasources/remote/product_remote_datasource.dart';
// import 'package:flutter_task_systems/data/models/product_model.dart';
// import 'package:flutter_task_systems/data/repositories/product_repository.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
//
// // Generate mocks
// class MockProductApi extends Mock implements ProductApi {}
//
// class MockFavoriteHiveDatasource extends Mock implements FavoriteHiveDatasource {}
//
// void main() {
//   late ProductRepository repository;
//   late MockProductApi mockApi;
//   late MockFavoriteHiveDatasource mockHiveDatasource;
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
//   group('ProductRepository', () {
//     setUp(() {
//       mockApi = MockProductApi();
//       mockHiveDatasource = MockFavoriteHiveDatasource();
//       repository = ProductRepository(
//         mockApi,
//         mockHiveDatasource,
//       );
//     });
//
//     test('getProducts returns list of products from API', () async {
//       // Setup mock
//       when(mockApi.fetchProducts(limit: 100)).thenAnswer((_) async => testProducts);
//
//       // Act
//       final result = await repository.getProducts(limit: 100);
//
//       // Assert
//       expect(result.length, 2);
//       expect(result[0].title, 'Test Product 1');
//       expect(result[1].title, 'Test Product 2');
//       verify(mockApi.fetchProducts(limit: 100)).called(1);
//     });
//
//     test('getProducts throws exception on API failure', () async {
//       // Setup mock
//       when(mockApi.fetchProducts(limit: 100)).thenThrow(Exception('API error'));
//
//       // Act & Assert
//       expect(
//         () => repository.getProducts(limit: 100),
//         throwsException,
//       );
//     });
//
//     test('addToFavorites saves product to Hive', () async {
//       // Setup mock
//       when(mockHiveDatasource.addFavorite(any)).thenAnswer((_) async => {});
//
//       // Act
//       await repository.addToFavorites(testProducts[0]);
//
//       // Assert
//       verify(mockHiveDatasource.addFavorite(any)).called(1);
//     });
//
//     test('removeFromFavorites deletes product from Hive', () async {
//       // Setup mock
//       when(mockHiveDatasource.removeFavorite(1)).thenAnswer((_) async => {});
//
//       // Act
//       await repository.removeFromFavorites(1);
//
//       // Assert
//       verify(mockHiveDatasource.removeFavorite(1)).called(1);
//     });
//
//     test('getFavorites returns list of favorite products', () async {
//       // Setup mock
//       when(mockHiveDatasource.getAllFavorites()).thenAnswer((_) async => [testProducts[0]]);
//
//       // Act
//       final result = await repository.getFavorites();
//
//       // Assert
//       expect(result.length, 1);
//       expect(result[0].id, 1);
//       verify(mockHiveDatasource.getAllFavorites()).called(1);
//     });
//
//     test('getFavorites returns empty list when no favorites', () async {
//       // Setup mock
//       when(mockHiveDatasource.getAllFavorites()).thenAnswer((_) async => []);
//
//       // Act
//       final result = await repository.getFavorites();
//
//       // Assert
//       expect(result.isEmpty, true);
//       verify(mockHiveDatasource.getAllFavorites()).called(1);
//     });
//
//     test('isFavorite returns true for saved favorites', () async {
//       // Setup mock
//       when(mockHiveDatasource.isFavorite(1)).thenAnswer((_) async => true);
//
//       // Act
//       final result = await repository.isFavorite(1);
//
//       // Assert
//       expect(result, true);
//       verify(mockHiveDatasource.isFavorite(1)).called(1);
//     });
//
//     test('isFavorite returns false for non-saved products', () async {
//       // Setup mock
//       when(mockHiveDatasource.isFavorite(999)).thenAnswer((_) async => false);
//
//       // Act
//       final result = await repository.isFavorite(999);
//
//       // Assert
//       expect(result, false);
//       verify(mockHiveDatasource.isFavorite(999)).called(1);
//     });
//   });
// }
