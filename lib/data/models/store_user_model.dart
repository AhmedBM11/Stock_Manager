class StoreUserModel {
  final String storeId;
  final String userId;
  final int accessibility; // 0 = no access, 1 = read, 2 = read & write, 3 = admin

  StoreUserModel({
    required this.storeId,
    required this.userId,
    required this.accessibility,
  });

  // from Firestore to Model
  factory StoreUserModel.fromMap(Map<String, dynamic> map) {
    return StoreUserModel(
      storeId: map['storeId'] ?? '',
      userId: map['userId'] ?? '',
      accessibility: map['accessibility'] ?? 0,
    );
  }

  // from Firestore DocumentSnapshot to Model
  factory StoreUserModel.fromDocument(String id, Map<String, dynamic> map) {
    return StoreUserModel(
      storeId: map['storeId'] ?? '',
      userId: map['userId'] ?? '',
      accessibility: map['accessibility'] ?? 0,
    );
  }

  // from Model to Map (Firestore)
  Map<String, dynamic> toMap() {
    return {
      'storeId': storeId,
      'userId': userId,
      'accessibility': accessibility,
    };
  }
}
