import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treintaypico/features/categories/application/controllers/category_controller.dart';
import 'package:treintaypico/features/categories/application/states/category_state.dart';
import 'package:treintaypico/features/categories/application/usecases/create_category_usecase.dart';
import 'package:treintaypico/features/categories/application/usecases/get_categories_usecase.dart';
import 'package:treintaypico/features/categories/application/usecases/toggle_category_usecase.dart';
import 'package:treintaypico/features/categories/application/usecases/update_category_usecase.dart';
import 'package:treintaypico/features/categories/data/datasources/category_datasource_provider.dart';
import 'package:treintaypico/features/categories/data/repositories/category_repository_impl.dart';
import 'package:treintaypico/features/categories/domain/repositories/category_repository.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final datasource = ref.read(categoryDatasourceProvider);
  return CategoryRepositoryImpl(datasource: datasource);
});

final categoryControllerProvider =
    StateNotifierProvider<CategoryController, CategoryState>((ref) {
  return CategoryController(
    getCategoriesUseCase: ref.read(getCategoriesUseCaseProvider),
    createCategoryUseCase: ref.read(createCategoryUseCaseProvider),
    updateCategoryUseCase: ref.read(updateCategoryUseCaseProvider),
    toggleCategoryUseCase: ref.read(toggleCategoryUseCaseProvider),
  );
});
