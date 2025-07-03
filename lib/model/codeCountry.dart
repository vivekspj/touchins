import 'package:country_list_pick/support/code_countries_en.dart';
import 'package:touchins/model/dependencyInjection.dart';

class CodeCountries{
  String name;
  String code;
  String dialCode;

  CodeCountries({this.name, this.code, this.dialCode});

  static List<Map> countries = countriesEnglish;

  static List<CodeCountries> fromMap(){
    List<CodeCountries> list = List.empty(growable: true);
    countries.forEach((element) {
      var codeCountries = getIt.get<CodeCountries>();
      codeCountries.name =element.values.elementAt(0);
      codeCountries.code = element.values.elementAt(2);
      codeCountries.dialCode = element.values.elementAt(1);
      list.add(codeCountries);
    });
    return list;
  }
}