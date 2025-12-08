import 'bill_model.dart';

class ActionModel {

  final BillModel bill;
  final String storeId;
  final String userId;


  ActionModel({
    required this.bill,
    required this.storeId,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'storeId': storeId,
      'userId': userId,
      'bill': bill.toMap(),
    };
  }

  factory ActionModel.fromMap(Map<String, dynamic> map, String id) {
    return ActionModel(
      storeId: map['storeId'],
      userId: map['userId'],
      bill: BillModel.fromMap(map['bill']), // assuming you nest the bill
    );
  }

}