import 'package:equatable/equatable.dart';

abstract class ActionEvent extends Equatable {
  const ActionEvent();

  @override
  List<Object?> get props => [];
}

// Event to load user actions when the page opens
class LoadUserActions extends ActionEvent {
  final String storeId;
  final String userId;

  const LoadUserActions({required this.storeId, required this.userId});

  @override
  List<Object?> get props => [storeId, userId];
}

class FilterActionsByDay extends ActionEvent {
  final String storeId;
  final String userId;
  final DateTime date;
  FilterActionsByDay(this.storeId, this.userId, this.date);
}

class FilterActionsByPeriod extends ActionEvent {
  final String storeId;
  final String userId;
  final String period;
  final DateTime? baseDate;

  FilterActionsByPeriod({required this.storeId, required this.userId, required this.period, this.baseDate});
}