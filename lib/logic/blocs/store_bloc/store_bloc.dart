import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sat/data/repositories/action_repository.dart';
import 'store_event.dart';
import 'store_state.dart';
import 'package:sat/data/repositories/store_repository.dart';
import 'package:sat/data/repositories/user_repository.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  final StoreRepository storeRepository;
  final UserRepository userRepository;

  StoreBloc(this.storeRepository,this.userRepository) : super(StoreInitial()) {

    on<LoadStores>((event, emit) async {
      emit(StoreLoading());
      try {
        final stores = await userRepository.getUserStores(event.userId);
        emit(StoreLoaded(stores));
      } catch (e) {
        emit(StoreError('Failed to load stores: $e'));
      }
    });

    on<AddStoreEvent>((event, emit) async {
      try {
        await storeRepository.addStore(event.userId, event.store,event.accessibility);
        add(LoadStores(event.userId));
      } catch (e) {
        emit(StoreError('Failed to add store: $e'));
      }
    });

    on<UpdateStoreEvent>((event, emit) async {
      try {
        await storeRepository.updateStore(event.userId, event.storeId, event.data);
        add(LoadStores(event.userId));
      } catch (e) {
        emit(StoreError('Failed to update store: $e'));
      }
    });

    on<DeleteStoreEvent>((event, emit) async {
      try {
        await storeRepository.deleteStore(event.storeId);
        add(LoadStores(event.userId));
      } catch (e) {
        emit(StoreError('Failed to delete store: $e'));
      }
    });

    on<GetStoreUsersEvent>((event, emit) async {
      emit(StoreLoading());
      try {
        final users = await storeRepository.getStoreUsers(event.storeId);
        emit(StoreUsersLoaded(users));
      } catch (e) {
        emit(StoreError('Failed to add store: $e'));
      }
    });

    on<AddStoreUserEvent>((event, emit) async {
      try {
        final user = await userRepository.getUserByEmail(event.mail);
        if (user != null) {
          await storeRepository.addStoreUser(user.id, event.storeId, event.accessibility);
        }
        add(GetStoreUsersEvent(storeId: event.storeId));
      } catch (e) {
        emit(StoreError('Failed to add store user : $e'));
      }
    });

    on<DeleteStoreUserEvent>((event, emit) async {
      try {
        await storeRepository.deleteStoreUser(event.userId, event.storeId);

        // refresh the store users list after deletion
        add(GetStoreUsersEvent(storeId: event.storeId));
      } catch (e) {
        emit(StoreError('Failed to delete store user: $e'));
      }
    });

    on<ConfirmBillEvent>((event, emit) async {
      try {
        final actionRepository = ActionRepository();
        await actionRepository.confirmBill(event.storeId, event.bill);
        emit(BillConfirmed());
      } catch (e) {
        emit(StoreError('Failed to confirm the bill : $e'));
      }
    });

    on<VerifyStorePasswordEvent>((event, emit) async {
      final stores = (state as StoreLoaded).stores;
      emit(StorePasswordChecking());
      try {

        final correctPassword = event.store.password;
        if (event.password == correctPassword) {
          emit(StorePasswordSuccess(event.store));
        } else {
          emit(StorePasswordFailure(stores, "Wrong password"));
        }
      } catch (e) {
        emit(StorePasswordFailure(stores, "Error verifying password: $e"));
      }
    });
  }
}
