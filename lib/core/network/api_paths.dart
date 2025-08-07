import 'package:treintaypico/config/constants/environment.dart';

class ApiPaths {
  static String get baseUrl {
    final url = Environment.apiUrl;
    if (url == null) {
      throw Exception('API URL is not defined for the current environment.');
    }
    return url;
  }

  /// El único endpoint común para todas las acciones POST
  static const String baseEndpoint = '/index.php';

  /// Acciones permitidas por el backend
  static const String listProgrammingLanguages = 'language_listar';
  static const String getChallenge = 'question_aleatorias';
}
