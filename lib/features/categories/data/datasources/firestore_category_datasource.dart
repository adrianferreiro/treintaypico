import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:treintaypico/features/categories/data/datasources/category_datasource.dart';
import 'package:treintaypico/features/categories/data/models/category_model.dart';

class FirestoreCategoryDatasource implements CategoryDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<CategoryModel>> getCategoriesByVenue(String venueId) async {
    final query = await _firestore
        .collection('categories')
        .where('venueId', isEqualTo: venueId)
        .get();

    final categories = query.docs
        .map((doc) => CategoryModel.fromJson(doc.id, doc.data()))
        .toList();

    // Sort client-side to avoid requiring a composite index
    categories.sort((a, b) => a.order.compareTo(b.order));
    return categories;
  }

  @override
  Future<void> createCategory({
    required String name,
    required String venueId,
    required int order,
    String? imageUrl,
  }) async {
    await _firestore.collection('categories').add({
      'name': name,
      'venueId': venueId,
      'order': order,
      'isActive': true,
      'imageUrl': imageUrl,
    });
  }

  @override
  Future<void> updateCategory({
    required String id,
    required String name,
    String? imageUrl,
  }) async {
    final data = <String, dynamic>{'name': name};
    if (imageUrl != null) {
      data['imageUrl'] = imageUrl;
    }
    await _firestore.collection('categories').doc(id).update(data);
  }

  @override
  Future<void> toggleCategoryActive({
    required String id,
    required bool isActive,
  }) async {
    await _firestore.collection('categories').doc(id).update({
      'isActive': isActive,
    });
  }
}
