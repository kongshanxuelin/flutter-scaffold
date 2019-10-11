import 'package:event_bus/event_bus.dart';

class ApplicationEvent{
  static EventBus event;
}

class EvtHomeNavChange {
  int index;
  EvtHomeNavChange(this.index);
}
