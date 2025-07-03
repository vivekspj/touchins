import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:touchins/model/user.dart';

import 'codeCountry.dart';
import 'dependencyInjection.dart';

class MyProfileController extends GetxController{
  String name;
  String email;
  String dob;
  String country;
  String county;
  String city;
  String street;
  bool isNameValid=true,isEmailValid=true,isPasswordValid=false;
  CodeCountries selectedCode;
  List<DropdownMenuItem<CodeCountries>> listDropName = [];
  List<CodeCountries> codeCountries = [];
  TextEditingController dateCtl;
  User user = getIt.get<User>();
  @override
  void onInit(){
    codeCountries = CodeCountries.fromMap();
    codeCountries.forEach((element) {
      listDropName.add(DropdownMenuItem(
        child: Text(element.name.toString()), value: element,));
    });
    dateCtl = TextEditingController(text: user.dob);
    name = user.fullName;
    street = user.street;
    city = user.city;
    county = user.county;
    country = user.country;
    dob = user.dob;
    email = user.email;
    super.onInit();
  }
  @override
  void onClose(){
    super.onClose();
  }
  void setFullName(String value){
    name = value;
    update();
  }
  void setEmail(String value){
    email = value;
    update();
  }
  void setDOB(String value){
    dob = value;
    update();
  }
  void setCountry(String value){
    country = value;
    update();
  }
  void setCounty(String value){
    county = value;
    update();
  }
  void setCity(String value){
    city = value;
    update();
  }
  void setStreet(String value){
    street = value;
    update();
  }
  void setSelectedCode(CodeCountries code){
    selectedCode = code;
    update();
  }
  void setIsNameValid(bool value){
    isNameValid = value;
    update();
  }
  void setIsEmailValid(bool value){
    isEmailValid = value;
    update();
  }
  void setPasswordValid(bool value){
    isPasswordValid = value;
    update();
  }
}