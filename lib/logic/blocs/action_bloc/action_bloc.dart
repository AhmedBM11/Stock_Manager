import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sat/data/repositories/action_repository.dart';
import 'package:sat/logic/blocs/action_bloc/action_event.dart';
import 'package:sat/logic/blocs/action_bloc/action_state.dart';
import 'package:sat/logic/helpers/actions_helper.dart';

class ActionBloc extends Bloc<ActionEvent, ActionState> {
  final ActionRepository actionRepository;

  ActionBloc(this.actionRepository) : super(UserActionsInitial()) {
    on<LoadUserActions>((event, emit) async {
      emit(UserActionsLoading());
      try {
        final actions = await actionRepository.getUserActions(
          event.storeId,
          event.userId,
        );

        final sortedActions = sortActionsByDate(actions);

        emit(UserActionsLoaded(sortedActions));
      } catch (e) {
        emit(UserActionsError("Failed to load user actions: $e"));
      }
    });

    on<FilterActionsByDay>((event, emit) async{
      final actions = await actionRepository.getUserActions(
        event.storeId,
        event.userId,
      );
      final sortedActions = sortActionsByDate(actions);
      final filtered = filterByDay(sortedActions, event.date);
      emit(UserActionsLoaded(filtered));
    });

    on<FilterActionsByPeriod>((event, emit) async{
      final actions = await actionRepository.getUserActions(
        event.storeId,
        event.userId,
      );
      final sortedActions = sortActionsByDate(actions);
      if (actions.isEmpty) {
        emit(UserActionsLoaded([]));
        return;
      }

      final base = event.baseDate ?? DateTime.now();
      final start = getPeriodStartDate(event.period, base);

      if (event.period == 'This Day' || event.period == 'Day') {
        final filtered = filterByDay(sortedActions, base);
        emit(UserActionsLoaded(filtered));
      } else if (event.period == 'All Actions') {
        emit(UserActionsLoaded(List.unmodifiable(sortedActions)));
      } else {
        final filtered = filterFromStartInclusive(sortedActions, start);
        emit(UserActionsLoaded(filtered));
      }
    });
  }
}
