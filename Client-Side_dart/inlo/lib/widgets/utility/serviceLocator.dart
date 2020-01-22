
import 'package:get_it/get_it.dart';
import 'callMessage.dart';

GetIt locator = GetIt();

void setupLocator() {
  locator.registerSingleton(CallsAndMessagesService());
}