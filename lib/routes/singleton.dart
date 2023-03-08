import 'package:event_bus/event_bus.dart';

class Singleton {
  // 靜態變數指向自身
  static final EventBus _instance = EventBus();
  static EventBus getEventBusInstance() => _instance;
}
