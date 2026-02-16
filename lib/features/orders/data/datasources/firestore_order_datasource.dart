import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:treintaypico/core/network/exceptions/exceptions.dart';
import '../models/order_model.dart';
import '../models/order_item_model.dart';
import 'order_datasource.dart';

class FirestoreOrderDatasource implements OrderDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<OrderModel> getOrderById(String id) async {
    final query = await _firestore
        .collection('orders')
        .where('order_number', isEqualTo: id)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      throw NotFoundException();
    }

    final doc = query.docs.first;
    final data = doc.data();

    // Buscar nombre del cliente
    String userName = 'Cliente';
    final userId = data['user_id'] ?? '';
    if (userId.isNotEmpty) {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        userName = userDoc.data()?['name'] ?? 'Cliente';
      }
    }

    return OrderModel(
      id: doc.id,
      eventId: data['event_id'] ?? '',
      userId: userId,
      userName: userName,
      companyId: data['company_id'] ?? '',
      items: _parseItems(data['items']),
      totalAmount: (data['total_amount'] ?? 0).toInt(),
      status: data['status'] ?? 'pending',
      isPaid: data['isPaid'] ?? false,
      paymentMethod: data['payment_method'],
      orderNumber: data['order_number'] ?? '',
      createdAt: _parseTimestamp(data['created_at']),
      updatedAt: _parseTimestamp(data['updated_at']),
      deliveredAt: data['delivered_at'] != null
          ? _parseTimestamp(data['delivered_at'])
          : null,
    );
  }

  @override
  Future<void> markOrderAsPaid({
    required String orderId,
    required String paymentMethod,
  }) async {
    await _firestore.collection('orders').doc(orderId).update({
      'status': 'paid',
      'isPaid': true,
      'payment_method': paymentMethod,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> cancelOrder(String orderId) async {
    await _firestore.collection('orders').doc(orderId).update({
      'status': 'cancelled',
      'isOrderActive': false,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  List<OrderItemModel> _parseItems(dynamic itemsData) {
    if (itemsData == null || itemsData is! List) return [];
    return itemsData.map<OrderItemModel>((item) {
      return OrderItemModel(
        productId: item['category_id'] ?? '',
        productName: item['product_name'] ?? '',
        quantity: (item['quantity'] ?? 0).toInt(),
        unitPrice: (item['unit_price'] ?? 0).toInt(),
        subtotal: (item['subtotal'] ?? 0).toInt(),
      );
    }).toList();
  }

  DateTime _parseTimestamp(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }
}
