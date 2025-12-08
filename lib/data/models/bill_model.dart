import 'package:sat/data/models/bill_item_model.dart';
import 'package:uuid/uuid.dart';

class BillModel {
  final String id;
  final String storeId;
  final String userId;
  final List<BillItemModel> billItems;
  final double totalPrice;
  final DateTime createdAt;

  BillModel({
    String? id,
    required this.storeId,
    required this.userId,
    required this.billItems,
    required this.totalPrice,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'storeId': storeId,
      'userId': userId,
      'billItems': billItems.map((item) => item.toMap()).toList(),
      'totalPrice': totalPrice,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory BillModel.fromMap(Map<String, dynamic> map) {
    return BillModel(
      id: map['id'],
      storeId: map['storeId'],
      userId: map['userId'],
      billItems: (map['billItems'] as List<dynamic>)
          .map((item) => BillItemModel.fromMap(item as Map<String, dynamic>))
          .toList(),
      totalPrice: map['totalPrice'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
