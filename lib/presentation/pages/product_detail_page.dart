import 'package:flutter/material.dart';
import 'package:flutter_task_systems/core/components/custom_network_image.dart';
import 'package:flutter_task_systems/data/models/product_model.dart';
import 'package:flutter_task_systems/presentation/controllers/product_list_controller.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductListController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Product Image
            Container(
              width: double.infinity,
              height: 300,
              color: Colors.grey[200],
              child: CustomNetworkImage(
                imageUrl: product.image,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Title
                  Text(
                    product.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Gap(12),

                  /// Category
                  Chip(
                    label: Text(
                      product.category.toUpperCase(),
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: Colors.teal.withOpacity(0.2),
                  ),
                  const Gap(12),

                  /// Rating
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '${product.rating.rate} (${product.rating.count} reviews)',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const Gap(16),

                  /// Price
                  Text(
                    "\$${product.price.toStringAsFixed(2)}",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(16),

                  /// Description
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Gap(8),
                  Text(
                    product.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Gap(24),

                  /// Add to Favorites Button
                  Obx(() {
                    final isFav = controller.isFavorite(product.id);
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          controller.toggleFavorite(product);
                        },
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                        ),
                        label: Text(
                          isFav ? 'Remove from Favorites' : 'Add to Favorites',
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
