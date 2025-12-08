import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sat/data/models/action_model.dart';

DateTime _toDate(dynamic value) {
  if (value == null) return DateTime.fromMillisecondsSinceEpoch(0);

  if (value is DateTime) return value;

  if (value is Timestamp) return value.toDate();

  if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);

  if (value is String) {
    try {
      return DateTime.parse(value);
    } catch (_) {
      final maybeInt = int.tryParse(value);
      if (maybeInt != null) return DateTime.fromMillisecondsSinceEpoch(maybeInt);
    }
  }

  return DateTime.fromMillisecondsSinceEpoch(0);
}

DateTime getPeriodStartDate(String period, DateTime base) {
  final d = DateTime(base.year, base.month, base.day);

  switch (period) {
    case 'All Actions':
      return DateTime.fromMillisecondsSinceEpoch(0);
    case 'This Day':
      return d;
    case 'This Week':
      final weekStart = d.subtract(Duration(days: d.weekday - 1));
      return DateTime(weekStart.year, weekStart.month, weekStart.day);
    case 'This Month':
      return DateTime(d.year, d.month, 1);
    case 'This Year':
      return DateTime(d.year, 1, 1);
    default:
      try {
        final parsed = DateTime.parse(period);
        return DateTime(parsed.year, parsed.month, parsed.day);
      } catch (_) {
        return DateTime.fromMillisecondsSinceEpoch(0);
      }
  }
}

List<ActionModel> filterByDay(List<ActionModel> sortedNewestFirst, DateTime date) {
  final target = DateTime(date.year, date.month, date.day);
  final result = <ActionModel>[];

  for (final action in sortedNewestFirst) {
    final aDate = _toDate(action.bill.createdAt);
    final aDay = DateTime(aDate.year, aDate.month, aDate.day);
    if (aDay == target) {
      result.add(action);
    } else if (aDay.isBefore(target)) {
      break;
    } else {
      continue;
    }
  }
  return result;
}

List<ActionModel> filterFromStartInclusive(List<ActionModel> sortedNewestFirst, DateTime startDate) {
  final result = <ActionModel>[];
  for (final action in sortedNewestFirst) {
    final aDate = _toDate(action.bill.createdAt);
    if (!aDate.isBefore(startDate)) {
      result.add(action);
    } else {
      break;
    }
  }
  return result;
}

List<ActionModel> sortActionsByDate(List<ActionModel> actions) {

  actions.sort((a, b) {
    final da = _toDate(a.bill.createdAt);
    final db = _toDate(b.bill.createdAt);
    return db.compareTo(da); // newest first
  });

  return actions;
}