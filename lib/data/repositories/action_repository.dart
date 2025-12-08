import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sat/data/models/action_model.dart';
import 'package:sat/data/repositories/user_repository.dart';
import 'package:sat/data/models/bill_model.dart';

class ActionRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<BillModel> confirmBill(String storeId, BillModel bill) async {
    final storeRef = _db.collection('stores').doc(storeId);
    final userRepository = UserRepository();
    final user = await userRepository.getCurrentUser();

    final action = ActionModel(bill: bill, storeId: storeId, userId: user!.id);
    // Save Bill
    final billRef = await storeRef.collection('bills').add(action.toMap());
    final billSnap = await billRef.get();

    // Update product quantities
    for (var product in bill.billItems) {
      final productRef = storeRef.collection('products').doc(product.productId);
      await _db.runTransaction((transaction) async {
        final snapshot = await transaction.get(productRef);
        if (snapshot.exists) {
          final currentQty = snapshot['quantity'] ?? 0;
          transaction.update(productRef, {
            'quantity': currentQty - product.quantity,
          });
        }
      });
    }
    return BillModel.fromMap(billSnap.data()!);
  }

  Future<List<ActionModel>> getUserActions(String storeId, String userId) async {
    try {
      final querySnapshot = await _db
          .collection('stores')
          .doc(storeId)
          .collection('bills')
          .where('userId', isEqualTo: userId)

          .get();

      return querySnapshot.docs
          .map((doc) => ActionModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception("Failed to load user actions: $e");
    }
  }
}


