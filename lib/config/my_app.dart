import 'package:flutter/material.dart';
import 'package:flutter_task_systems/config/theme/app_theme.dart';
import 'package:flutter_task_systems/presentation/pages/product_list_page.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Task Systems',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      darkTheme: AppTheme.darkTheme,
      home: const ProductListPage(),
    );
  }
}
