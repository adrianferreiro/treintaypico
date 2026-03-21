import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardStats {
  final int totalSold;
  final int processedOrders;
  final int pendingOrders;

  const DashboardStats({
    required this.totalSold,
    required this.processedOrders,
    required this.pendingOrders,
  });
}

class FirestoreDashboardDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<DashboardStats> getOrderStats(String eventId, {Source? source}) async {
    final query = await _firestore
        .collection('orders')
        .where('event_id', isEqualTo: eventId)
        .get(source != null ? GetOptions(source: source) : null);

    int totalSold = 0;
    int processedOrders = 0;
    int pendingOrders = 0;

    for (final doc in query.docs) {
      final data = doc.data();
      final status = data['status'] as String? ?? '';
      final isPaid = data['isPaid'] as bool? ?? false;
      final totalAmount = ((data['total_amount'] ?? 0) as num).toInt();

      if (isPaid) {
        totalSold += totalAmount;
        processedOrders++;
      } else if (status == 'pending') {
        pendingOrders++;
      }
    }

    return DashboardStats(
      totalSold: totalSold,
      processedOrders: processedOrders,
      pendingOrders: pendingOrders,
    );
  }
}
