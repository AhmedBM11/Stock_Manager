import 'package:sat/data/models/store_model.dart';

abstract class StoreState {}

class StoreInitial extends StoreState {}

class StoreLoading extends StoreState {}

class StoreLoaded extends StoreState {
  final List<StoreModel> stores;
  StoreLoaded(this.stores);
}

class StoreError extends StoreState {
  final String message;
  StoreError(this.message);
}

class StoreUsersLoading extends StoreState {}

class StoreUsersLoaded extends StoreState {
  final List<Map<String,dynamic>> users;
  StoreUsersLoaded(this.users);
}

class BillConfirmed extends StoreState {}

class StorePasswordChecking extends StoreState {}

class StorePasswordSuccess extends StoreState {
  final StoreModel store;

  StorePasswordSuccess(this.store);
}

class StorePasswordFailure extends StoreLoaded {
  final String message;

  StorePasswordFailure(super.stores, this.message);
}