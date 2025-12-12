import 'package:flutter/material.dart';
import 'package:flutter_task_systems/core/components/offline_status_widget.dart';
import 'package:flutter_task_systems/presentation/controllers/product_list_controller.dart';
import 'package:flutter_task_systems/presentation/pages/app_drawer.dart';
import 'package:flutter_task_systems/presentation/pages/product_detail_page.dart';
import 'package:flutter_task_systems/presentation/widgets/error_widget.dart';
import 'package:flutter_task_systems/presentation/widgets/loading_widget.dart';
import 'package:flutter_task_systems/presentation/widgets/product_grids.dart';
import 'package:flutter_task_systems/presentation/widgets/product_list.dart';
import 'package:get/get.dart';

class ProductListPage extends GetView<ProductListController> {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        elevation: 0,
        actions: [
          // Grid/List Toggle
          Obx(() {
            return IconButton(
              icon: Icon(
                controller.isGridView.value ? Icons.list_rounded : Icons.grid_3x3_rounded,
              ),
              onPressed: controller.toggleViewMode,
              tooltip: 'Switch View',
            );
          }),
        ],
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          //  Offline Status Banner (Top of body)
          const OfflineStatusBanner(),

          // Main content
          Expanded(
            child: GetBuilder(
              init: Get.find<ProductListController>(),
              builder: (controller) {
                return Obx(() {
                  // 🔄 Loading state
                  if (controller.isLoading.value) {
                    return const Center(child: LoadingWidget());
                  }

                  //   Error and no products (with retry)
                  if (controller.error.value.isNotEmpty && controller.products.isEmpty) {
                    return ErrorHandler(
                      error: controller.error.value,
                      onRetry: controller.loadProducts,
                    );
                  }

                  // 💾 Offline with cached data
                  if (!controller.isOnline.value && controller.products.isEmpty) {
                    return OfflineEmptyState(
                      onRetry: controller.loadProducts,
                    );
                  }

                  //  Display products (grid or list)
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: controller.isGridView.value
                        ? ProductGrids(
                            key: const ValueKey('grid'),
                            products: controller.products,
                            onRefresh: controller.refreshProducts,
                            onProductTap: (product) {
                              Get.to(
                                () => ProductDetailPage(product: product),
                                transition: Transition.rightToLeft,
                              );
                            },
                            isFavorite: controller.isFavorite,
                            onFavoriteTap: (product) {
                              controller.toggleFavorite(product);
                            },
                          )
                        : ProductList(
                            key: const ValueKey('list'),
                            onRefresh: controller.refreshProducts,
                            products: controller.products,
                            onProductTap: (product) {
                              Get.to(
                                () => ProductDetailPage(product: product),
                                transition: Transition.rightToLeft,
                              );
                            },
                            isFavorite: controller.isFavorite,
                            onFavoriteTap: (product) {
                              controller.toggleFavorite(product);
                            },
                          ),
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
