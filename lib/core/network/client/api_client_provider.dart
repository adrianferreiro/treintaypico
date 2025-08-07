import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treintaypico/core/network/client/api_client.dart';
import 'package:treintaypico/core/providers/storage_providers.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = Dio();
  final localStorage = ref.read(localStorageRepositoryProvider);
  return ApiClient(dio: dio, localStorage: localStorage);
});
