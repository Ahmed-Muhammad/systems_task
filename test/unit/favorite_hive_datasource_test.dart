// import 'package:flutter_task_systems/data/datasources/local/favorite_local_datasource.dart';
// import 'package:flutter_task_systems/data/models/product_model.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:hive/hive.dart';
// import 'package:mockito/mockito.dart';
//
// // Generate mocks
// class MockBox extends Mock implements Box<dynamic> {}
//
// class MockHiveInterface extends Mock implements HiveInterface {}
//
// void main() {
//   late FavoriteHiveDatasource datasource;
//   late MockHiveInterface mockHive;
//   late MockBox mockBox;
//
//   // Sample test data
//   const testProduct = Product(
//     id: 1,
//     title: 'Test Product',
//     price: 99.99,
//     category: 'electronics',
//     description: 'A test product',
//     image: 'https://via.placeholder.com/200',
//     rating: ProductRating(rate: 4.5, count: 100),
//   );
//
//   group('FavoriteHiveDatasource', () {
//     setUp(() {
//       mockHive = MockHiveInterface();
//       mockBox = MockBox();
//       datasource = FavoriteHiveDatasource(mockHive);
//     });
//
//     test('addFavorite stores product in Hive box', () async {
//       // Setup mocks - the Box is returned, then operations on it
//       when(mockHive.openBox<dynamic>('favorites')).thenAnswer((_) async => mockBox);
//       when(mockBox.put(any, any)).thenAnswer((_) async {});
//
//       // Act
//       await datasource.addFavorite(testProduct);
//
//       // Assert
//       verify(mockHive.openBox<dynamic>('favorites')).called(1);
//       verify(mockBox.put(any, any)).called(1);
//     });
//
//     test('removeFavorite deletes product from Hive box', () async {
//       // Setup mocks
//       when(mockHive.openBox<dynamic>('favorites')).thenAnswer((_) async => mockBox);
//       when(mockBox.delete(any)).thenAnswer((_) async {});
//
//       // Act
//       await datasource.removeFavorite(1);
//
//       // Assert
//       verify(mockHive.openBox<dynamic>('favorites')).called(1);
//       verify(mockBox.delete(any)).called(1);
//     });
//
//     test('isFavorite returns true if product exists', () async {
//       // Setup mocks
//       when(mockHive.openBox<dynamic>('favorites')).thenAnswer((_) async => mockBox);
//       when(mockBox.containsKey(any)).thenReturn(true);
//
//       // Act
//       final result = await datasource.isFavorite(1);
//
//       // Assert
//       expect(result, true);
//       verify(mockHive.openBox<dynamic>('favorites')).called(1);
//       verify(mockBox.containsKey(any)).called(1);
//     });
//
//     test('isFavorite returns false if product does not exist', () async {
//       // Setup mocks
//       when(mockHive.openBox<dynamic>('favorites')).thenAnswer((_) async => mockBox);
//       when(mockBox.containsKey(any)).thenReturn(false);
//
//       // Act
//       final result = await datasource.isFavorite(999);
//
//       // Assert
//       expect(result, false);
//       verify(mockHive.openBox<dynamic>('favorites')).called(1);
//       verify(mockBox.containsKey(any)).called(1);
//     });
//
//     test('getAllFavorites returns empty list when box is empty', () async {
//       // Setup mocks
//       when(mockHive.openBox<dynamic>('favorites')).thenAnswer((_) async => mockBox);
//       when(mockBox.values).thenReturn([]);
//
//       // Act
//       final result = await datasource.getAllFavorites();
//
//       // Assert
//       expect(result.isEmpty, true);
//       verify(mockHive.openBox<dynamic>('favorites')).called(1);
//     });
//
//     test('getAllFavorites returns list of products', () async {
//       // Setup mocks
//       final productJson = testProduct.toJson();
//       when(mockHive.openBox<dynamic>('favorites')).thenAnswer((_) async => mockBox);
//       when(mockBox.values).thenReturn([productJson]);
//
//       // Act
//       final result = await datasource.getAllFavorites();
//
//       // Assert
//       expect(result.length, 1);
//       expect(result[0].id, 1);
//       verify(mockHive.openBox<dynamic>('favorites')).called(1);
//     });
//
//     test('clearAllFavorites removes all items from box', () async {
//       // Setup mocks
//       when(mockHive.openBox<dynamic>('favorites')).thenAnswer((_) async => mockBox);
//
//       // Act
//       await datasource.clearAllFavorites();
//
//       // Assert
//       verify(mockHive.openBox<dynamic>('favorites')).called(1);
//       verify(mockBox.clear()).called(1);
//     });
//
//     test('getAllFavorites handles type conversion correctly', () async {
//       // Setup mocks with dynamic map (like Hive returns)
//       final dynamicMap = <dynamic, dynamic>{
//         'id': 1,
//         'title': 'Test Product',
//         'price': 99.99,
//         'category': 'electronics',
//         'description': 'A test product',
//         'image': 'https://via.placeholder.com/200',
//         'rating': {
//           'rate': 4.5,
//           'count': 100,
//         },
//       };
//
//       when(mockHive.openBox<dynamic>('favorites')).thenAnswer((_) async => mockBox);
//       when(mockBox.values).thenReturn([dynamicMap]);
//
//       // Act
//       final result = await datasource.getAllFavorites();
//
//       // Assert
//       expect(result.length, 1);
//       expect(result[0].title, 'Test Product');
//       expect(result[0].rating.rate, 4.5);
//     });
//
//     test('addFavorite handles errors gracefully', () async {
//       // Setup mock to throw
//       when(mockHive.openBox<dynamic>('favorites')).thenThrow(Exception('Hive error'));
//
//       // Act & Assert
//       expect(
//         () => datasource.addFavorite(testProduct),
//         throwsException,
//       );
//     });
//   });
// }
