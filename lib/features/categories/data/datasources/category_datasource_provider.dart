import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treintaypico/features/categories/data/datasources/category_datasource.dart';
import 'package:treintaypico/features/categories/data/datasources/firestore_category_datasource.dart';

final categoryDatasourceProvider = Provider<CategoryDatasource>((ref) {
  return FirestoreCategoryDatasource();
});
