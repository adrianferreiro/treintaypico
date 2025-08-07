import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:treintaypico/core/data/respositories/local_storage_repository_impl.dart';
import 'package:treintaypico/core/domain/repositories/local_storage_repository.dart';

// Provider para SharedPreferences
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Debe ser inicializado en main.dart');
});

// Provider para el repositorio de almacenamiento local
final localStorageRepositoryProvider = Provider<LocalStorageRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocalStorageRepositoryImpl(prefs);
});
