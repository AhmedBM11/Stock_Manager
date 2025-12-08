import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:sat/data/models/user_model.dart';
import 'package:sat/data/models/store_model.dart';

class UserRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<UserModel?> registerUser({
    required String email,
    required String password,
    required String name,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final userModel = UserModel(
      id: credential.user!.uid,
      name: name,
      email: email,
      createdAt: DateTime.now(),
    );

    await _db.collection('users').doc(userModel.id).set(userModel.toMap());

    return userModel;
  }

  Future<User?> loginUser({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<UserModel?> getCurrentUser() {
    final currentUser = _auth.currentUser;
    return getUserById(currentUser!.uid);
  }

  Future<UserModel?> getUserById(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return UserModel.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  Future<List<StoreModel>> getUserStores(String userId) async {
    List<StoreModel> storesList = [];

    // 1. Get all store-user relationships for this user
    final storeUserDocs = await _db
        .collection('store_users')
        .where('userId', isEqualTo: userId)
        .get();

    for (var doc in storeUserDocs.docs) {
      final data = doc.data();
      final storeId = data['storeId'];
      final accessibility = data['accessibility'] ?? 0;

      // 2. Fetch the store info
      final storeDoc = await _db.collection('stores').doc(storeId).get();
      if (storeDoc.exists) {
        final storeData = storeDoc.data()!;
        // 3. Convert to StoreModel and include accessibility
        storesList.add(StoreModel(
          id: storeDoc.id,
          name: storeData['name'],
          password: storeData['password'],
          accessibility: accessibility,
        ));
      }
    }

    return storesList;
  }

  Future<UserModel?> getUserByEmail(String email) async {
    try {
      // Query the 'users' collection for a matching email
      QuerySnapshot snapshot = await _db
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Convert the first document into a UserModel
        return UserModel.fromMap(
          snapshot.docs.first.data() as Map<String, dynamic>,
          snapshot.docs.first.id,
        );
      } else {
        return null; // No user found
      }
    } catch (e) {
      return null;
    }
  }
}
