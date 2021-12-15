import 'package:get_it/get_it.dart';
import 'package:my_expenses/services/ocr_api.dart';

import 'app_api.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => Api());
  locator.registerLazySingleton(() => OcrApi());
}