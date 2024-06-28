import 'package:get_it/get_it.dart';
import 'package:new_project/api/local_api.dart';
import 'package:new_project/api/remote_api.dart';
import 'package:new_project/socket_services.dart';

GetIt locator = GetIt.instance;
final localApi = locator<LocalApi>();
final api = locator<Api>();
final socketService = locator<SocketService>();

void setupLocator() {
  locator.registerSingleton<LocalApi>(LocalApi());
  locator.registerSingleton<Api>(Api());
  locator.registerSingleton<SocketService>(SocketService());
}
