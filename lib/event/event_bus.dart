import 'package:event_bus/event_bus.dart';


EventBus eventBus = new EventBus();
class ApplicationEvent{
  String mp3Url;
  ApplicationEvent(this.mp3Url);
}