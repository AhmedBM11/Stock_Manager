import 'package:cloud_firestore/cloud_firestore.dart';

class StoreModel {
  final String id;
  final String name;
  final String password;
  final int accessibility;

  StoreModel({
    required this.id,
    required this.name,
    required this.password,
    required this.accessibility,
  });

  //from firebase
  factory StoreModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return StoreModel(
      id: doc.id,
      name: data['name'] ?? '',
      password: data['password'] ?? '',
      accessibility: data['accessibility'] ?? 0,
    );
  }

  //to firebase
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'password': password,
      'accessibility': accessibility,
    };
  }
}
