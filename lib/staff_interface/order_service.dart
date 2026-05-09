// lib/services/order_service.dart
class OrderService {
  static final OrderService _instance = OrderService._internal();
  factory OrderService() => _instance;
  OrderService._internal();

  // ✅ Persistent list that survives navigation
  List<Map<String, dynamic>> currentOrders = [];

  void addItem(String name) {
    final existingIndex = currentOrders.indexWhere((item) => item['name'] == name);
    if (existingIndex != -1) {
      currentOrders[existingIndex]['count'] = (currentOrders[existingIndex]['count'] as int) + 1;
    } else {
      currentOrders.add({'name': name, 'count': 1});
    }
  }

  void incrementItem(int index) {
    if (index >= 0 && index < currentOrders.length) {
      currentOrders[index]['count'] = (currentOrders[index]['count'] as int) + 1;
    }
  }

  void decrementItem(int index) {
    if (index >= 0 && index < currentOrders.length) {
      final count = currentOrders[index]['count'] as int;
      if (count > 0) currentOrders[index]['count'] = count - 1;
    }
  }

  void removeItem(int index) {
    if (index >= 0 && index < currentOrders.length) {
      currentOrders.removeAt(index);
    }
  }

  void clearAll() {
    currentOrders.clear();
  }

  bool get isEmpty => currentOrders.isEmpty;
  List<Map<String, dynamic>> get orders => List.unmodifiable(currentOrders);
}