import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treintaypico/features/products/data/datasources/firestore_product_datasource.dart';
import 'package:treintaypico/features/products/data/datasources/product_datasource.dart';

final productDatasourceProvider = Provider<ProductDatasource>((ref) {
  return FirestoreProductDatasource();
});
