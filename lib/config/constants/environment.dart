import 'dart:io';

enum EnvironmentType { mock, development, staging, production }

class Environment {
  static const EnvironmentType currentEnvironment = EnvironmentType.production;

  static String? get apiUrl {
    switch (currentEnvironment) {
      case EnvironmentType.mock:
        return null;
      case EnvironmentType.development:
        return Platform.isAndroid
            ? 'http://192.168.0.100:8080/devquizzer/api' // IP de tu red local si usás XAMPP
            : 'http://localhost:8080/devquizzer/api';
      case EnvironmentType.staging:
        return 'https://www.appedir.net/devquizzer_staging/api';
      case EnvironmentType.production:
        return 'https://www.appedir.net/devquizzer/api';
    }
  }

  /// Útil para alternar dependencias (por ejemplo entre mocks y reales)
  static T getDataSource<T>({
    required T mock,
    required T development,
    required T staging,
    required T production,
  }) {
    switch (currentEnvironment) {
      case EnvironmentType.mock:
        return mock;
      case EnvironmentType.development:
        return development;
      case EnvironmentType.staging:
        return staging;
      case EnvironmentType.production:
        return production;
    }
  }
}
