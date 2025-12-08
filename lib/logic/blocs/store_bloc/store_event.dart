import 'package:sat/data/models/store_model.dart';

import 'package:sat/data/models/bill_model.dart';

abstract class StoreEvent {}

class LoadStores extends StoreEvent {
  final String userId;
  LoadStores(this.userId);
}

class AddStoreEvent extends StoreEvent {
  final String userId;
  final StoreModel store;
  final int accessibility;
  AddStoreEvent({required this.userId, required this.store, required this.accessibility});
}

class UpdateStoreEvent extends StoreEvent {
  final String userId;
  final String storeId;
  final Map<String, dynamic> data;
  UpdateStoreEvent({required this.userId, required this.storeId, required this.data});
}

class DeleteStoreEvent extends StoreEvent {
  final String userId;
  final String storeId;
  DeleteStoreEvent({required this.userId, required this.storeId});
}

class UpdateUserAccessibilityEvent extends StoreEvent {
  final String userId;
  final String storeId;
  final int accessibility;

  UpdateUserAccessibilityEvent({required this.storeId, required this.userId, required this.accessibility,});
}

class GetStoreUsersEvent extends StoreEvent {
  final String storeId;
  GetStoreUsersEvent({required this.storeId});
}

class DeleteStoreUserEvent extends StoreEvent {
  final String userId;
  final String storeId;
  DeleteStoreUserEvent({required this.userId, required this.storeId});
}

class AddStoreUserEvent extends StoreEvent {
  final String storeId;
  final String mail;
  final int accessibility;
  AddStoreUserEvent({required this.mail, required this.storeId, required this.accessibility});
}

class ConfirmBillEvent extends StoreEvent {
  final String storeId;
  BillModel bill;

  ConfirmBillEvent({required this.storeId, required this.bill});
}

class VerifyStorePasswordEvent extends StoreEvent {
  final StoreModel store;
  final String password;

  VerifyStorePasswordEvent({required this.store, required this.password});
}
