import 'package:flutter/material.dart';
import 'package:flutter_task_systems/presentation/controllers/product_list_controller.dart';
import 'package:flutter_task_systems/presentation/pages/favorites_screen.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AppDrawer extends GetView<ProductListController> {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          /// Header
          Container(
            width: double.infinity,
            padding: const .symmetric(horizontal: 16, vertical: 50),
            decoration: BoxDecoration(
              color: Colors.teal,
              gradient: LinearGradient(colors: [Colors.teal, Colors.teal[700]!], begin: Alignment.topLeft, end: Alignment.bottomRight),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.shopping_bag, size: 48),
                const Gap(12),
                Text(
                  'App Menu',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          /// Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                /// Favorites Menu Item
                ListTile(
                  leading: const Icon(Icons.favorite_rounded),
                  title: const Text('My Favorites'),
                  subtitle: Obx(() {
                    return Text('${controller.favorites.length} items');
                  }),
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(() => const FavoritesScreen());
                  },
                ),
                const Divider(),

                /// Theme Toggle
                Obx(() {
                  return ListTile(
                    leading: Icon(
                      controller.isDarkMode.value ? Icons.light_mode : Icons.dark_mode,
                    ),
                    title: Text(
                      controller.isDarkMode.value ? 'Light Mode' : 'Dark Mode',
                    ),
                    trailing: Switch(
                      value: controller.isDarkMode.value,
                      onChanged: (_) => controller.toggleTheme(),
                      activeColor: Colors.teal,
                    ),
                    onTap: controller.toggleTheme,
                  );
                }),
              ],
            ),
          ),

          /// Footer Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
            child: Column(
              children: [
                Text(
                  'Flutter Task Systems',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const Gap(4),
                Text(
                  'v1.0.0',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
