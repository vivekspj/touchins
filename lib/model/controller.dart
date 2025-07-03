import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:touchins/model/codeCountry.dart';
import 'package:touchins/model/dependencyInjection.dart';
import 'package:touchins/model/user.dart';
import 'package:intl/intl.dart';

class Controller extends GetxController{
  int pageIndex = 0;
  int selectedIndex = 0;
  PageController pageController;
  PageController homePageController;
  CalendarController calendarController;
  Map<String, double> dataMap,dataMapShift;
  String currentMonth;
  String oldPassword;
  String newpassword="",confirmPassword="";
  String validatePassword="";
  bool oldPasswordMatch=false,isLoginPasswordValid=false;

  @override
  void onInit() { // called immediately after the widget is allocated memory
    pageController = PageController();
    homePageController = PageController();
    calendarController = CalendarController();
    currentMonth = DateFormat.yMMMM().format(DateTime.now());
    oldPassword="";
    validatePassword="";
    newpassword="";
    confirmPassword="";
    dataMap = {
      'Total':100,
      'Shift':40,
      'Credit':40
    };
    dataMapShift = {
      'Shift':40,
      'total':60,
    };
    super.onInit();
  }

  @override
  void onReady() { // called after the widget is rendered on screen
    super.onReady();
  }

  @override
  void onClose() { // called just before the Controller is deleted from memory
    pageController.dispose();
    calendarController.dispose();
    super.onClose();
  }

  void setPageIndex(int index) => pageIndex=index;
  void setSelectedBarIndex(int index) {
    selectedIndex = index;
    update();
  }

  void setPrevCurrentDate(){
    this.calendarController.previousPage();
    currentMonth = DateFormat.yMMMM().format(this.calendarController.focusedDay);
    update();
  }

  void setNextCurrentDate(){
    this.calendarController.nextPage();
    currentMonth = DateFormat.yMMMM().format(this.calendarController.focusedDay);
    update();
  }

  void setOldPassword(String oldPass){
    oldPassword = oldPass;
    update();
  }
  void setNewPassword(String newPass){
    newpassword = newPass;
    isLoginPasswordValid = true;
    update();
  }
  void setConfirmPass(String confirmPass){
    confirmPassword = confirmPass;
    update();
  }
  void setValidatePass(String validatePass){
    validatePassword = validatePass;
    update();
  }

  void setOldPasswordMatch(bool value){
    oldPasswordMatch = value;
    update();
  }

  void setLoginPasswordValid(bool value){
    isLoginPasswordValid=value;
    update();
  }



    void setUser(String name, String emailID, String birthDate, String country,
        String county, String city, String street){
      User user = getIt.get<User>();
      user.fullName = name;
      user.street = street;
      user.city = city;
      user.county = county;
      user.country = country;
      user.dob = birthDate;
      user.email = emailID;
      update();
    }
}