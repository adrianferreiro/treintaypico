import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treintaypico/features/categories/application/states/category_state.dart';
import 'package:treintaypico/features/categories/application/usecases/create_category_usecase.dart';
import 'package:treintaypico/features/categories/application/usecases/get_categories_usecase.dart';
import 'package:treintaypico/features/categories/application/usecases/toggle_category_usecase.dart';
import 'package:treintaypico/features/categories/application/usecases/update_category_usecase.dart';

class CategoryController extends StateNotifier<CategoryState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final CreateCategoryUseCase createCategoryUseCase;
  final UpdateCategoryUseCase updateCategoryUseCase;
  final ToggleCategoryUseCase toggleCategoryUseCase;

  String? _currentVenueId;

  CategoryController({
    required this.getCategoriesUseCase,
    required this.createCategoryUseCase,
    required this.updateCategoryUseCase,
    required this.toggleCategoryUseCase,
  }) : super(CategoryInitial());

  Future<void> loadCategories(String venueId) async {
    _currentVenueId = venueId;
    state = CategoryLoading();
    final result = await getCategoriesUseCase(
      GetCategoriesParams(venueId: venueId),
    );
    state = result.fold(
      (failure) => CategoryError(failure.message),
      (categories) => CategoryLoaded(categories),
    );
  }

  Future<void> createCategory({
    required String name,
    required String venueId,
    required int order,
    String? imageUrl,
  }) async {
    final result = await createCategoryUseCase(
      CreateCategoryParams(
        name: name,
        venueId: venueId,
        order: order,
        imageUrl: imageUrl,
      ),
    );
    result.fold(
      (failure) => state = CategoryError(failure.message),
      (_) => loadCategories(_currentVenueId ?? venueId),
    );
  }

  Future<void> updateCategory({
    required String id,
    required String name,
    String? imageUrl,
  }) async {
    final result = await updateCategoryUseCase(
      UpdateCategoryParams(id: id, name: name, imageUrl: imageUrl),
    );
    result.fold(
      (failure) => state = CategoryError(failure.message),
      (_) {
        if (_currentVenueId != null) loadCategories(_currentVenueId!);
      },
    );
  }

  Future<void> toggleCategoryActive({
    required String id,
    required bool isActive,
  }) async {
    final result = await toggleCategoryUseCase(
      ToggleCategoryParams(id: id, isActive: isActive),
    );
    result.fold(
      (failure) => state = CategoryError(failure.message),
      (_) {
        if (_currentVenueId != null) loadCategories(_currentVenueId!);
      },
    );
  }
}
