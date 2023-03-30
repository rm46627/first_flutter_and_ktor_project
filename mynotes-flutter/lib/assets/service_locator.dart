import 'package:get_it/get_it.dart';

import '../data/database.dart';

final getIt = GetIt.instance;

void serviceLocatorInit() {
  getIt.registerSingleton(() => Database());
}
