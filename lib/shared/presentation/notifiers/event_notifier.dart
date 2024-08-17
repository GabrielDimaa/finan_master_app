import 'package:flutter/cupertino.dart';

class EventNotifier extends ValueNotifier<EventType?> {
  EventNotifier() : super(null);

  void notify(EventType eventType) {
    value = eventType;
    notifyListeners();
  }
}

enum EventType {
  transfer,
  income,
  expense,
  creditCard,
  account,
}
