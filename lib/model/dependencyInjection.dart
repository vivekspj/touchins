import 'package:get_it/get_it.dart';
import 'package:touchins/model/myProfileController.dart';
import 'package:touchins/model/user.dart';
import 'package:touchins/model/controller.dart';
import 'codeCountry.dart';

GetIt getIt = GetIt.instance;

void getService(){
  getIt.registerSingleton<User>(User());
  getIt.registerFactory<CodeCountries>(()=>CodeCountries());
  getIt.registerSingleton<Controller>(Controller());
}