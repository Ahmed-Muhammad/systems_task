import 'package:flutter/material.dart';
import 'package:flutter_task_systems/data/models/product_model.dart';
import 'package:flutter_task_systems/presentation/widgets/product_list_item.dart';

class ProductList extends StatelessWidget {
  final List<Product> products;
  final Function(Product) onProductTap;
  final Function() onRefresh;
  final Function(int) isFavorite;
  final Function(Product) onFavoriteTap;

  const ProductList({
    super.key,
    required this.products,
    required this.onProductTap,
    required this.onRefresh,
    required this.isFavorite,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductListItem(
            product: product,
            onTap: () => onProductTap(product),
            isFavorite: isFavorite(product.id),
            onFavoriteTap: () => onFavoriteTap(product),
          );
        },
      ),
    );
  }
}
