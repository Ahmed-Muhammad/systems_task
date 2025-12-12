import 'package:flutter/material.dart';
import 'package:flutter_task_systems/presentation/controllers/product_list_controller.dart';
import 'package:flutter_task_systems/presentation/widgets/loading_widget.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

/// Offline Status Indicator Widget
class OfflineStatusBanner extends GetView<ProductListController> {
  const OfflineStatusBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isOnline.value && !controller.isLoadingFromCache.value) {
        return const SizedBox.shrink();
      }

      if (!controller.isOnline.value) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          color: Colors.orange[700],
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              /// Offline icon with animation
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(50)),
                child: const Icon(Icons.cloud_off, color: Colors.white, size: 16),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.isLoadingFromCache.value ? 'You are offline' : 'No internet connection',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Showing cached data',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }

      if (controller.isRefreshingAfterReconnect.value) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          color: Colors.blue[700],
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(Icons.cloud_sync, color: Colors.white, size: 16),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Back Online!',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Syncing latest data...',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              LoadingWidget(scale: .75, insideColor: Colors.blue[700]),
            ],
          ),
        );
      }

      return const SizedBox.shrink();
    });
  }
}

///Offline Status Indicator (Mini version for AppBar)
class OfflineIndicator extends GetView<ProductListController> {
  const OfflineIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isOnline.value && !controller.isLoadingFromCache.value) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Tooltip(
          message: controller.isOnline.value ? 'Syncing data...' : 'You are offline - viewing cached data',
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: controller.isOnline.value ? Colors.blue[100] : Colors.orange[100],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: controller.isOnline.value ? Colors.blue[400]! : Colors.orange[400]!,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  controller.isOnline.value ? Icons.cloud_sync : Icons.cloud_off,
                  size: 14,
                  color: controller.isOnline.value ? Colors.blue[700] : Colors.orange[700],
                ),
                const Gap(4),
                Text(
                  controller.isOnline.value ? 'Syncing' : 'Offline',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: controller.isOnline.value ? Colors.blue[700] : Colors.orange[700],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

///Offline Empty State
class OfflineEmptyState extends StatelessWidget {
  final Function() onRetry;

  const OfflineEmptyState({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_off, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 24),
          Text(
            'You are Offline',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'No cached data available',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
