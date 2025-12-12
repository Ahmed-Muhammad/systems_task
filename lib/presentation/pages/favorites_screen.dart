import 'package:flutter/material.dart';
import 'package:flutter_task_systems/core/components/custom_network_image.dart';
import 'package:flutter_task_systems/presentation/controllers/product_list_controller.dart';
import 'package:flutter_task_systems/presentation/pages/product_detail_page.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class FavoritesScreen extends GetView<ProductListController> {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Obx(() {
        /// Get all products that are favorites
        final favoriteProducts = controller.products.where((p) => controller.isFavorite(p.id)).toList();

        if (favoriteProducts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const Gap(16),
                Text(
                  'No Favorites Yet',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const Gap(8),
                Text(
                  'Add products to your favorites',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                  ),
                ),
                const Gap(32),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.shopping_bag),
                  label: const Text('Browse Products'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: favoriteProducts.length,
          itemBuilder: (context, index) {
            final product = favoriteProducts[index];
            return Card(
              elevation: .5,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: GestureDetector(
                onTap: () {
                  Get.to(
                    () => ProductDetailPage(product: product),
                    transition: Transition.rightToLeft,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Product Image
                      CustomNetworkImage(
                        imageUrl: product.image,
                        width: 80,
                        height: 80,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      const Gap(12),

                      /// Product Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Title
                            Text(
                              product.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Gap(8),

                            /// Category
                            Chip(
                              label: Text(
                                product.category.toUpperCase(),
                                style: const TextStyle(fontSize: 10),
                              ),
                              backgroundColor: Colors.teal.withOpacity(0.2),
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            const Gap(8),

                            /// Price & Rating
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: Colors.teal,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.star, size: 14, color: Colors.amber),
                                    const Gap(4),
                                    Text(
                                      product.rating.rate.toStringAsFixed(1),
                                      style: Theme.of(context).textTheme.labelSmall,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Gap(8),

                      /// Favorite Button
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              controller.toggleFavorite(product);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: [
                                  BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8),
                                ],
                              ),
                              padding: const EdgeInsets.all(8),
                              child: const Icon(Icons.favorite, color: Colors.red, size: 20),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
