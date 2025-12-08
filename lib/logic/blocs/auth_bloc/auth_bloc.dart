import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_event.dart';
import 'auth_state.dart';
import 'package:sat/data/repositories/user_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository userRepository;

  AuthBloc(this.userRepository) : super(AuthInitialState()) {

    on<CheckCurrentUserEvent>((event, emit) async {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        try {
          final userData = await userRepository.getUserById(user.uid);
          emit(AuthenticatedState(
            uid: userData!.id,
            email: userData.email,
            name: userData.name,
          ));
        } catch (e) {
          emit(AuthErrorState("Failed to fetch user data: $e"));
        }
      } else {
        emit(UnauthenticatedState());
      }
    });

    on<LoginEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        final user = await userRepository.loginUser(
          email: event.email,
          password: event.password,
        );

        if (user != null) {
          final userData = await userRepository.getCurrentUser();
          if (userData != null) {
            emit(AuthenticatedState(
              uid: userData.id,
              email: userData.email,
              name: userData.name,
            ));
          } else {
            emit(AuthErrorState("User data not found in Firestore"));
          }
        } else {
          emit(AuthErrorState("Login failed"));
        }
      } catch (e) {
        emit(AuthErrorState(e.toString()));
      }
    });


    on<RegisterEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        final user = await userRepository.registerUser(
          email: event.email,
          password: event.password,
          name: event.name,
        );
        if (user != null) {
          emit(AuthenticatedState(
            uid: user.id,
            email: user.email,
            name: user.name,
          ));
        } else {
          emit(AuthErrorState("Registration failed"));
        }
      } catch (e) {
        emit(AuthErrorState(e.toString()));
      }
    });

    on<LogoutEvent>((event, emit) async {
      await userRepository.signOut();
      emit(UnauthenticatedState());
    });
  }
}
