import 'package:flutter/material.dart';
import 'package:flutter_task_systems/config/di/service_locator.dart';
import 'package:flutter_task_systems/config/my_app.dart';
import 'package:flutter_task_systems/data/models/product_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(ProductRatingAdapter());

  /// Setup dependency injection
  setupServiceLocator();

  runApp(const MyApp());
}
