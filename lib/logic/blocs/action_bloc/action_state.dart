import 'package:equatable/equatable.dart';
import 'package:sat/data/models/action_model.dart';

abstract class ActionState extends Equatable {
  const ActionState();

  @override
  List<Object?> get props => [];
}

class UserActionsInitial extends ActionState {}

class UserActionsLoading extends ActionState {}

class UserActionsLoaded extends ActionState {
  final List<ActionModel> actions;

  const UserActionsLoaded(this.actions);

  @override
  List<Object?> get props => [actions];
}

class UserActionsError extends ActionState {
  final String message;

  const UserActionsError(this.message);

  @override
  List<Object?> get props => [message];
}
