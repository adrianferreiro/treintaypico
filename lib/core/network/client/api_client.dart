import 'package:dio/dio.dart';
import 'package:treintaypico/core/domain/repositories/local_storage_repository.dart';
import 'package:treintaypico/core/network/api_paths.dart';
import 'package:treintaypico/core/network/auth_interceptor.dart';

class ApiClient {
  final Dio dio;

  ApiClient({required this.dio, required LocalStorageRepository localStorage}) {
    dio.options = BaseOptions(
      baseUrl: ApiPaths.baseUrl,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      validateStatus: (status) => true,
    );

    dio.interceptors.add(AuthInterceptor(localStorage));
    dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, error: true),
    );
  }
}
