import 'package:flutter/material.dart';
import 'package:touchins/model/dependencyInjection.dart';

import 'database.dart';

class User {
  String fullName;
  String email;
  String dob;
  String password;
  String country;
  String county;
  String city;
  String street;
  String credit;

  User({
    this.fullName,
    this.email,
    this.dob,
    this.password,
    this.country,
    this.county,
    this.city,
    this.street,
    this.credit
  });

  String get _fullName => fullName;
  String get _email => email;
  String get _dob => dob;
  String get _country => country;
  String get _county => county;
  String get _city => city;
  String get _street => street;
  String get _credit => credit;


  factory User.fromJson(Map<String, dynamic> data) => new User(
    fullName: data["FullName"],
    email: data["Email"],
    dob: data["DOB"],
    country: data["Country"],
    county: data["County"],
    city: data["City"],
    street: data["Street"],
    credit: data["Credit"],
    password: data["Password"],
  );

  Map<String, dynamic> toJson() => {
    "FullName": fullName,
    "Email": email,
    "DOB": dob,
    "Country": country,
    "County": county,
    "City": city,
    "Street": street,
    "Credit" : credit,
    "Password" : password,
  };

  static User getUser(Map<String, dynamic> data){
    var user = getIt.get<User>();
    user.fullName =  data["FullName"];
    user.email= data["Email"];
    user.dob= data["DOB"];
    user.country= data["Country"];
    user.county= data["County"];
    user.city= data["City"];
    user.street= data["Street"];
    user.credit= data["Credit"];
    user.password= data["Password"];
    return user;
  }

  static Future<User> getUserDetails(String email) async{
    final dbHelper = DatabaseHelper.instance;
    List<Map<String, dynamic>> res = await dbHelper.queryAllRows(email);
    return getUser(res.first);
  }
}