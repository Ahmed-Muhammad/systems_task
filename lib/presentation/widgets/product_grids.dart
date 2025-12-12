import 'package:flutter/material.dart';
import 'package:flutter_task_systems/data/models/product_model.dart';
import 'package:flutter_task_systems/presentation/widgets/product_grids_item.dart';

class ProductGrids extends StatelessWidget {
  final List<Product> products;
  final Function(Product) onProductTap;
  final Function() onRefresh;
  final Function(int) isFavorite;
  final Function(Product) onFavoriteTap;

  const ProductGrids({
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
      child: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductGridItem(
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
