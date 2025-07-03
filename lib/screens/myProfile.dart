import 'package:country_list_pick/country_list_pick.dart';
import 'package:country_list_pick/selection_list.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touchins/model/codeCountry.dart';
import 'package:touchins/model/controller.dart';
import 'package:touchins/model/myProfileController.dart';
import 'package:touchins/model/database.dart';
import 'package:touchins/model/dependencyInjection.dart';
import 'package:touchins/model/user.dart';
import 'package:touchins/screens/setting.dart';

import 'home.dart';


// ignore: must_be_immutable
class MyProfile extends StatelessWidget{
  int firstEntry;
  int countryChanged;
  MyProfileController ctrl;
  final dbHelper = DatabaseHelper.instance;
  final _formKey = GlobalKey<FormState>();

  RegExp regExp = new RegExp(r'^[?:[a-zA-Z]+/s[a-zA-Z]+$',);
  RegExp passwordRegex = new RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  User user;

  MyProfile({Key key, this.firstEntry,this.countryChanged}) : super(key: key);

    @override
  Widget build(BuildContext context) {
      ctrl = Get.put(MyProfileController());
      user = getIt.get<User>();
    return Scaffold(
      backgroundColor: Colors.lightBlue[400],
      body: Container(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),
                ListTile(
                  trailing: IconButton(icon: Icon(Icons.cancel_outlined),color: Colors.white,onPressed: (){Navigator.pop(context);},),
                ),
                Text("My Profile",style: TextStyle(color: Colors.white,fontSize: 30),textAlign: TextAlign.center),
                Text("Kalipro Software",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.only(left: 40,right: 40),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        validator: (value) {
                          if (value=="" || !ctrl.isNameValid) {
                            return 'Please enter valid name';
                          }
                          return null;
                        },
                        initialValue: user.fullName,
                        style: TextStyle(height: .5,),
                        onChanged: _nameOnChanged,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1,color: Colors.pink),
                          ),
                          border: OutlineInputBorder(borderSide: BorderSide(width: 1,color: Colors.pink),),
                          labelText: "Full Name",
                          labelStyle: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                          errorMaxLines: 1,
                        ),
                        maxLines: 1,
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value=="" || !ctrl.isEmailValid) {
                            return 'Please enter valid email address';
                          }
                          return null;
                        },
                        initialValue: user.email,
                        style: TextStyle(height: .5),
                        onChanged: _emailOnChanged,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1,color: Colors.pink),
                            ),
                            border: OutlineInputBorder(borderSide: BorderSide(width: 1,color: Colors.pink),),
                            labelText: "Email Address",
                            labelStyle: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                          validator: (value) {
                            if (value=="") {
                              return "* Required";
                            }
                            return null;
                          },
                          controller: firstEntry==1?ctrl.dateCtl:TextEditingController(text: user.dob),
                          style: TextStyle(height: .5),
                          onChanged: (value){_dateOfBirth(ctrl.dateCtl.text);},
                          keyboardType: TextInputType.datetime,
                          cursorHeight: 20,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1,color: Colors.pink),
                            ),
                            border: OutlineInputBorder(borderSide: BorderSide(width: 1,color: Colors.pink),),
                            labelText: "Date of birth",
                            labelStyle: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                          onTap: () async{
                            DateTime date = DateTime(1900);
                            FocusScope.of(context).requestFocus(new FocusNode());

                            date = await showDatePicker(
                                context: context,
                                initialDate:DateTime.now(),
                                firstDate:DateTime(1900),
                                lastDate: DateTime(2100));
                            ctrl.dateCtl.text = date.toString().split(" ")[0];
                            ctrl.setDOB(ctrl.dateCtl.text);
                            firstEntry = 1;
                          }
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 50,
                        child: DropdownButtonHideUnderline(child: DropdownButtonFormField<CodeCountries>(
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: user.country,
                            hintStyle: TextStyle(
                                color: Colors.black
                            ),
                          ),
                          isDense: true,
                          items: ctrl.listDropName,
                          value: countryChanged==1?ctrl.selectedCode:null,
                          isExpanded: true,
                          onChanged: (CodeCountries newValue) {
                            ctrl.setSelectedCode(newValue);
                            _countryChange(newValue.name);
                            countryChanged=1;
                          },
                        ),),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value=="") {
                            return "* Required";
                          }
                          return null;
                        },
                        initialValue: user.county,
                        style: TextStyle(height: .5),
                        onChanged: (value){_countyChanged(value);},
                        keyboardType: TextInputType.text,
                        cursorHeight: 20,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1,color: Colors.pink),
                          ),
                          border: OutlineInputBorder(borderSide: BorderSide(width: 1,color: Colors.pink),),
                          labelText: "County",
                          labelStyle: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value=="") {
                            return "* Required";
                          }
                          return null;
                        },
                        initialValue: user.city,
                        style: TextStyle(height: .5),
                        onChanged: (value){_cityChanged(value);},
                        keyboardType: TextInputType.text,
                        cursorHeight: 20,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1,color: Colors.pink),
                          ),
                          border: OutlineInputBorder(borderSide: BorderSide(width: 1,color: Colors.pink),),
                          labelText: "City",
                          labelStyle: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value=="") {
                            return "* Required";
                          }
                          return null;
                        },
                        initialValue: user.street,
                        style: TextStyle(height: .5),
                        onChanged: (value){_streetChanged(value);},
                        keyboardType: TextInputType.text,
                        cursorHeight: 20,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1,color: Colors.pink),
                          ),
                          border: OutlineInputBorder(borderSide: BorderSide(width: 1,color: Colors.pink),),
                          labelText: "Street",
                          labelStyle: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        )
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue[800],
        child: TextButton(child: Text("Upadte",style: TextStyle(color: Colors.white,)),onPressed: (){
          if(_formKey.currentState.validate()){
            update(context);
          }
        },),
        elevation: 0,
      ),
    );
  }

  CodeCountries selectedCountries(String name){
    return CodeCountries.fromMap().firstWhere((element) => element.name==name);
  }

  void _nameOnChanged(String name){
    if(name.isNotEmpty){
      if(name.contains(RegExp(r'[0-9]'),0) || name==null || name.contains(RegExp(r'[@#$&%!~]'),0)){
        print(name);
        ctrl.setIsNameValid(false);
      }else{
        ctrl.setIsNameValid(true);
      }
    }
    ctrl.setFullName(name);
  }

  void _emailOnChanged(String emailID){
    if(emailID.isNotEmpty){
      if(EmailValidator.validate(emailID)){
        ctrl.setIsEmailValid(true);
      }else{
        ctrl.setIsEmailValid(false);
      }
    }
    ctrl.setEmail(emailID);
  }
  void _dateOfBirth(String text){
    ctrl.setDOB(text);
  }

  void _countryChange(String text){
    ctrl.setCountry(text);
  }

  void _countyChanged(String text){
    ctrl.setCounty(text);
  }

  void _cityChanged(String text){
    ctrl.setCity(text);
  }

  void _streetChanged(String text){
    ctrl.setStreet(text);
  }

  update(BuildContext context) async{
      print(ctrl.name+":"+ctrl.dob);
      final Controller cnt = Get.find();
    try{
      Map<String, dynamic> row = {
        DatabaseHelper.columnFullName : ctrl.name,
        DatabaseHelper.columnEmail  : ctrl.email,
        DatabaseHelper.columnCountry  : ctrl.country,
        DatabaseHelper.columnCounty  : ctrl.county,
        DatabaseHelper.columnDob  : ctrl.dob,
        DatabaseHelper.columnCity  : ctrl.city,
        DatabaseHelper.columnStreet  : ctrl.street,
      };
      final id = await dbHelper.update(row,ctrl.email);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("TouchInFullName",ctrl.name);
      prefs.setString("TouchInEmail", ctrl.email);
      prefs.setString("TouchInDob", ctrl.dob);
      prefs.setString("TouchInCountry", ctrl.country);
      prefs.setString("TouchInCounty", ctrl.county);
      prefs.setString("TouchInCity", ctrl.city);
      prefs.setString("TouchInStreet", ctrl.street);
      prefs.setBool("TouchInisLoggedIn", true);
      print(prefs.getString("TouchInPassWord"));
      cnt.setUser(ctrl.name, ctrl.email, ctrl.dob, ctrl.country, ctrl.county, ctrl.city, ctrl.street);
      Get.offAll(()=>Home());
    }catch(e){
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('An Error occurred.Please try again.'
        ,style: TextStyle(color: Colors.white),),backgroundColor: Colors.green,));
    }
  }

}