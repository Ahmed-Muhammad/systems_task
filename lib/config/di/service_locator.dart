import 'package:dio/dio.dart';
import 'package:flutter_task_systems/core/helpers/app_logger.dart';
import 'package:flutter_task_systems/data/datasources/local/favorite_local_datasource.dart';
import 'package:flutter_task_systems/data/datasources/local/product_local_datasource.dart';
import 'package:flutter_task_systems/data/datasources/remote/product_remote_datasource.dart';
import 'package:flutter_task_systems/data/repositories/product_repository.dart';
import 'package:flutter_task_systems/presentation/controllers/product_list_controller.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  AppLogger.debug(' Setting up Service Locator...');

  // Register Dio
  getIt.registerSingleton<Dio>(
    Dio(BaseOptions(connectTimeout: const Duration(seconds: 15), receiveTimeout: const Duration(seconds: 15), contentType: Headers.jsonContentType)),
  );

  // Register Remote Data Source
  getIt.registerSingleton<ProductRemoteDatasource>(ProductRemoteDatasource(getIt<Dio>()));

  // Hive Database
  getIt.registerSingleton<HiveInterface>(Hive);
  getIt.registerSingleton<FavoriteLocalDatasource>(FavoriteLocalDatasource(getIt<HiveInterface>()));
  getIt.registerSingleton<ProductLocalDatasource>(ProductLocalDatasource());

  // Repository
  getIt.registerSingleton<ProductRepository>(ProductRepository(getIt<ProductRemoteDatasource>(), getIt<FavoriteLocalDatasource>()));
  // Controller
  getIt.registerSingleton<ProductListController>(
    ProductListController(getIt<ProductRepository>(), getIt<ProductLocalDatasource>()),
  );
}
