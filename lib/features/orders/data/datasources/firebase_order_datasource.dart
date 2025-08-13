import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:treintaypico/features/orders/data/datasources/order_datasource.dart';
import 'package:treintaypico/features/orders/data/models/order_model.dart';

class FirebaseOrderDatasource implements OrderDatasource {
  FirebaseOrderDatasource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('orders_events');

  @override
  Future<OrderModel> getOrderById(String id) async {
    try {
      final trimmed = id.trim();

      // 1) Intento por docId
      final byId = await _col.doc(trimmed).get();
      if (byId.exists && byId.data() != null) {
        return OrderModel.fromDocument(byId);
      }

      // 2) Fallback por order_number (QR)
      final byNumber = await _col
          .where('order_number', isEqualTo: trimmed)
          .limit(1)
          .get();

      if (byNumber.docs.isEmpty) {
        throw Exception('Order not found with id: $id');
      }

      return OrderModel.fromDocument(byNumber.docs.first);
    } catch (e) {
      throw Exception('Error fetching order: $e');
    }
  }

  @override
  Future<void> markOrderAsPaid({
    required String orderId,
    required String paymentMethod,
  }) async {
    try {
      final ref = await _resolveRefByIdOrOrderNumber(orderId);
      await ref.update({
        'status': 'paid',
        'isPaid': true,
        'isOrderActive': false,
        'payment_method': paymentMethod, // 'cash' | 'card' | 'transfer'
        'updated_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error marking order as paid: $e');
    }
  }

  @override
  Future<void> cancelOrder(String orderId) async {
    try {
      final ref = await _resolveRefByIdOrOrderNumber(orderId);
      await ref.update({
        'status': 'cancelled',
        'isPaid': false,
        'isOrderActive': false,
        'updated_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error cancelling order: $e');
    }
  }

  // ---------- helpers ----------
  Future<DocumentReference<Map<String, dynamic>>> _resolveRefByIdOrOrderNumber(
    String idOrOrderNumber,
  ) async {
    final trimmed = idOrOrderNumber.trim();

    // DocId directo
    final byIdRef = _col.doc(trimmed);
    final byIdSnap = await byIdRef.get();
    if (byIdSnap.exists) return byIdRef;

    // Fallback por order_number
    final q = await _col
        .where('order_number', isEqualTo: trimmed)
        .limit(1)
        .get();
    if (q.docs.isEmpty) {
      throw Exception('Order not found with id: $idOrOrderNumber');
    }
    return q.docs.first.reference;
  }
}
