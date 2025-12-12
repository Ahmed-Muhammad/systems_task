import 'package:dio/dio.dart';
import 'package:flutter_task_systems/core/helpers/api_constants.dart';
import 'package:flutter_task_systems/core/helpers/app_logger.dart';
import 'package:flutter_task_systems/data/models/product_model.dart';

class ProductRemoteDatasource {
  final Dio _dio;

  ProductRemoteDatasource(this._dio) {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 15);
    _dio.options.receiveTimeout = const Duration(seconds: 15);
    _dio.options.contentType = Headers.jsonContentType;

    _dio.interceptors.add(LoggingInterceptor());
  }

  Future<List<Product>> fetchProducts({int limit = 20}) async {
    try {
      final response = await _dio.get(ApiConstants.products, queryParameters: limit > 0 ? {'limit': limit} : null);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final products = data.map((json) => Product.fromJson(json)).toList();
        return products;
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } on DioException catch (e) {
      AppLogger.error('  Dio Error: ${e.message}');
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      AppLogger.error('Error: $e');
      throw Exception('Error: $e');
    }
  }

  Future<Product> fetchProductById(int id) async {
    try {
      final response = await _dio.get('${ApiConstants.products}/$id');

      if (response.statusCode == 200) {
        final product = Product.fromJson(response.data);
        AppLogger.debug('Fetched product Details: ${product.title}');
        return product;
      } else {
        throw Exception('Failed to load product: ${response.statusCode}');
      }
    } on DioException catch (e) {
      AppLogger.error('Dio Error: ${e.message}');
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      AppLogger.error('  Error: $e');
      throw Exception('Error: $e');
    }
  }
}

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.debug('📤 [${options.method}] ${options.path}');
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.debug('📥 [${response.statusCode}] ${response.requestOptions.path}');
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error('  [${err.type}] ${err.requestOptions.path}');
    return super.onError(err, handler);
  }
}
