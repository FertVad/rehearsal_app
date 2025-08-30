import 'package:flutter/foundation.dart';
import 'calendar_state.dart';

/// A minimal controller maintaining an anchor date.
class CalendarController extends ChangeNotifier {
  CalendarController();

  CalendarState _state = CalendarState(anchor: DateTime.now());
  CalendarState get state => _state;

  void nextMonth() {
    _state = CalendarState(
        anchor: DateTime(_state.anchor.year, _state.anchor.month + 1, 1));
    notifyListeners();
  }

  void previousMonth() {
    _state = CalendarState(
        anchor: DateTime(_state.anchor.year, _state.anchor.month - 1, 1));
    notifyListeners();
  }
}
