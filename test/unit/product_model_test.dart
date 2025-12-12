import 'package:flutter_task_systems/data/models/product_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Product Model Tests', () {
    test('Product equality should work correctly', () {
      // Arrange & Act
      const product1 = Product(
        description: "description",
        id: 1,
        title: 'Test Product',
        price: 29.99,
        image: 'https://example.com/product.jpg',
        category: 'electronics',
        rating: ProductRating(rate: 4.5, count: 100),
      );

      const product2 = Product(
        description: "description",
        id: 1,
        title: 'Test Product',
        price: 29.99,
        image: 'https://example.com/product.jpg',
        category: 'electronics',
        rating: ProductRating(rate: 4.5, count: 100),
      );

      const product3 = Product(
        description: "description",
        id: 2,
        title: 'Different Product',
        price: 39.99,
        image: 'https://example.com/other.jpg',
        category: 'clothing',
        rating: ProductRating(rate: 3.8, count: 50),
      );

      // Assert
      expect(product1, product2);
      expect(product1 == product3, false);
    });

    test('Product hash should be consistent', () {
      // Arrange & Act
      const product1 = Product(
        id: 1,
        title: 'Hashable Product',
        description: "description",
        price: 49.99,
        image: 'https://example.com/hash.jpg',
        category: 'electronics',
        rating: ProductRating(rate: 4.7, count: 200),
      );

      const product2 = Product(
        description: "description",
        id: 1,
        title: 'Hashable Product',
        price: 49.99,
        image: 'https://example.com/hash.jpg',
        category: 'electronics',
        rating: ProductRating(rate: 4.7, count: 200),
      );

      // Assert
      expect(product1.hashCode, product2.hashCode);
    });

    test('Rating equality should work correctly', () {
      // Arrange & Act
      const rating1 = ProductRating(rate: 4.5, count: 100);
      const rating2 = ProductRating(rate: 4.5, count: 100);
      const rating3 = ProductRating(rate: 3.8, count: 50);

      // Assert
      expect(rating1, rating2);
      expect(rating1 == rating3, false);
    });

    test('Product should serialize to JSON correctly', () {
      // Arrange
      const product = Product(
        id: 1,
        description: "description",
        title: 'Serializable Product',
        price: 29.99,
        image: 'https://example.com/serializable.jpg',
        category: 'electronics',
        rating: ProductRating(rate: 4.5, count: 100),
      );

      // Act
      final json = product.toJson();

      // Assert
      expect(json['id'], 1);
      expect(json['title'], 'Serializable Product');
      expect(json['price'], 29.99);
      expect(json['image'], 'https://example.com/serializable.jpg');
      expect(json['category'], 'electronics');
      expect(json['rating']['rate'], 4.5);
      expect(json['rating']['count'], 100);
    });

    test('Product should deserialize from JSON correctly', () {
      // Arrange
      final json = {
        'id': 2,
        'title': 'Deserializable Product',
        'price': 39.99,
        'image': 'https://example.com/deserializable.jpg',
        'category': 'clothing',
        'rating': {'rate': 4.2, 'count': 50},
      };

      // Act
      final product = Product.fromJson(json);

      // Assert
      expect(product.id, 2);
      expect(product.title, 'Deserializable Product');
      expect(product.price, 39.99);
      expect(product.image, 'https://example.com/deserializable.jpg');
      expect(product.category, 'clothing');
      expect(product.rating.rate, 4.2);
      expect(product.rating.count, 50);
    });


    test('Product string representation should be meaningful', () {
      // Arrange & Act
      const product = Product(
        id: 1,
        title: 'Test Product',
        description: "description",
        price: 29.99,
        image: 'https://example.com/test.jpg',
        category: 'electronics',
        rating: ProductRating(rate: 4.5, count: 100),
      );

      final toString = product.toString();

      // Assert
      expect(toString, isNotEmpty);
      expect(toString.contains('Product'), true);
    });

    test('Product price should be non-negative', () {
      // Arrange & Act & Assert
      expect(
        () => const Product(
          id: 1,
          description: "description",
          title: 'Invalid Product',
          price: -10.0,
          image: 'https://example.com/invalid.jpg',
          category: 'test',
          rating: ProductRating(rate: 4.0, count: 10),
        ),
        returnsNormally,
      );
    });

    test('Rating count should be non-negative', () {
      // Arrange & Act & Assert
      expect(
        () => const ProductRating(rate: 4.5, count: -5),
        returnsNormally,
      );
    });

    test('Product rating should be between 0 and 5', () {
      // Arrange & Act & Assert
      const validRating1 = ProductRating(rate: 0.0, count: 10);
      const validRating2 = ProductRating(rate: 5.0, count: 10);

      expect(validRating1.rate, 0.0);
      expect(validRating2.rate, 5.0);
    });

    test('Category should handle various string cases', () {
      // Arrange & Act
      const product1 = Product(
        id: 1,
        title: 'Product 1',
        description: "description",
        price: 29.99,
        image: 'https://example.com/1.jpg',
        category: 'electronics',
        rating: ProductRating(rate: 4.5, count: 100),
      );

      const product2 = Product(
        id: 2,
        title: 'Product 2',
        price: 39.99,
        description: "description",

        image: 'https://example.com/2.jpg',
        category: 'CLOTHING',
        rating: ProductRating(rate: 4.2, count: 50),
      );

      // Assert
      expect(product1.category, 'electronics');
      expect(product2.category, 'CLOTHING');
    });
  });
}
