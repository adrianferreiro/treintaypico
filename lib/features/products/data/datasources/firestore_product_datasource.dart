import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:treintaypico/features/products/data/datasources/product_datasource.dart';
import 'package:treintaypico/features/products/data/models/product_model.dart';

class FirestoreProductDatasource implements ProductDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<ProductModel>> getProductsByCategory(String categoryId) async {
    final query = await _firestore
        .collection('products')
        .where('categoryId', isEqualTo: categoryId)
        .get();

    return query.docs
        .map((doc) => ProductModel.fromJson(doc.id, doc.data()))
        .toList();
  }

  @override
  Future<void> createProduct({
    required String name,
    required int price,
    required String categoryId,
    String? imageUrl,
  }) async {
    await _firestore.collection('products').add({
      'name': name,
      'price': price,
      'categoryId': categoryId,
      'isActive': true,
      'imageUrl': imageUrl,
    });
  }

  @override
  Future<void> updateProduct({
    required String id,
    required String name,
    required int price,
    String? imageUrl,
  }) async {
    final data = <String, dynamic>{
      'name': name,
      'price': price,
    };
    if (imageUrl != null) {
      data['imageUrl'] = imageUrl;
    }
    await _firestore.collection('products').doc(id).update(data);
  }

  @override
  Future<void> toggleProductActive({
    required String id,
    required bool isActive,
  }) async {
    await _firestore.collection('products').doc(id).update({
      'isActive': isActive,
    });
  }
}
