import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sat/data/models/store_model.dart';
import 'package:sat/data/models/store_user_model.dart';
import 'package:sat/data/models/user_model.dart';

class StoreRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //add store to a user
  Future<void> addStore(String userId, StoreModel store,int? accessibility) async {
    final storeRef = await _db.collection('stores').add(store.toMap());
    await _db.collection('store_users').add(StoreUserModel(storeId: storeRef.id, userId: userId, accessibility: accessibility??3).toMap());
  }

  //update user's store
  Future<void> updateStore(String userId, String storeId, Map<String, dynamic> data) async {
    await _db.collection('users').doc(userId).collection('stores').doc(storeId).update(data);
  }

  //delete user's store
  Future<void> deleteStore(String storeId) async {
    await _db.collection('stores').doc(storeId).delete();
    final querySnapshot = await _db
        .collection('store_user')
        .where('storeId', isEqualTo: storeId)
        .get();

    for (final doc in querySnapshot.docs) {
      await doc.reference.delete();
      }
    }

  Future<List<Map<String, dynamic>>> getStoreUsers(String storeId) async {
    List<Map<String, dynamic>> storeUsersList = [];

    final storeUsersDocs = await _db
        .collection('store_users')
        .where('storeId', isEqualTo: storeId)
        .get();

    for (var doc in storeUsersDocs.docs) {
      final data = doc.data();
      final userId = data['userId'];
      final accessibility = data['accessibility'] ?? 0;

      final userDoc = await _db.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final userData = userDoc.data()!;
        storeUsersList.add({
          'id': userDoc.id,
          'name': UserModel.fromMap(userData, userDoc.id).name,
          'accessibility': accessibility,
          'email': UserModel.fromMap(userData, userDoc.id).email,
        });
      }
    }

    return storeUsersList;
  }

  Future<void> updateUserAccess(String storeId, String userId, int accessibility) async {

    final storeUserQuery = await _db
        .collection('store_users')
        .where('storeId', isEqualTo: storeId)
        .where('userId', isEqualTo: userId)
        .get();

    if (storeUserQuery.docs.isNotEmpty) {
      // Update existing
      await _db
          .collection('store_users')
          .doc(storeUserQuery.docs.first.id)
          .update({'accessibility': accessibility});
    } else {
      // Create new entry if doesn't exist
      await _db.collection('store_users').add({
        'storeId': storeId,
        'userId': userId,
        'accessibility': accessibility,
      });
    }
  }

  Future<void> addStoreUser(String userId, String storeId, int accessibility) async {
    try {
      // Create the store user model
      final storeUser = StoreUserModel(
        userId: userId,
        storeId: storeId,
        accessibility: accessibility,
      );

      // Add to Firestore
      await _db.collection('store_users').add(storeUser.toMap());
    } catch (e) {
      throw Exception("Failed to add store user: $e");
    }
  }

  Future<void> deleteStoreUser(String userId, String storeId) async {
    try {
      // Query the store_users collection to find the document
      final query = await _db
          .collection('store_users')
          .where('userId', isEqualTo: userId)
          .where('storeId', isEqualTo: storeId)
          .get();

      // Delete all matching documents (usually one)
      for (var doc in query.docs) {
        await _db.collection('store_users').doc(doc.id).delete();
      }
    } catch (e) {
      throw Exception("Failed to delete store user: $e");
    }
  }
}
