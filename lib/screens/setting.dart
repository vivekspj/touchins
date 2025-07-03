import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touchins/screens/loginsignup.dart';
import 'package:touchins/screens/myProfile.dart';
import 'package:touchins/screens/resetPassword.dart';
import 'package:get/get.dart';
import 'package:touchins/model/myProfileController.dart';

import '../main.dart';

class Setting extends StatelessWidget{
  String emailID="",fullUserName="";
  bool isEmailValid=true,readOnlyModeEmail=true,readOnlyModeName=true,isNameValid=true;

  RegExp regExp = new RegExp(r'^[?:[a-zA-Z]+/s[a-zA-Z]+$',);
  setUserFullName(String name) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(name!=null){
      prefs.setString("Name",name);
    }
  }
  setUserEmail(String text) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(text!=null){
      prefs.setString("Email", text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[400],
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              ListTile(
                dense: true,
                trailing: IconButton(icon: Icon(Icons.cancel_outlined),color: Colors.white,onPressed: (){Navigator.pop(context);},),
              ),
              Text("Settings",
                style: TextStyle(color: Colors.white,fontSize: 30),textAlign: TextAlign.center,),
              Text("Kalipro Software",
                style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),textAlign: TextAlign.center,),
              SizedBox(
                height: 40,
              ),
              TextButton(onPressed: (){
                Get.to(()=>MyProfile(firstEntry: 0,countryChanged: 0,));
              }, child: Text("My Profile",
                style: TextStyle(color: Colors.white,fontSize: 15),textAlign: TextAlign.center,)),
              TextButton(onPressed: (){}, child: Text("Role",
                style: TextStyle(color: Colors.white,fontSize: 15),textAlign: TextAlign.center,)),
              TextButton(onPressed: (){}, child: Text("Grade",
                style: TextStyle(color: Colors.white,fontSize: 15),textAlign: TextAlign.center,)),
              TextButton(onPressed: (){}, child: Text("Contracted Hours",
                style: TextStyle(color: Colors.white,fontSize: 15),textAlign: TextAlign.center,)),
              TextButton(onPressed: (){}, child: Text("Manager Details",
                style: TextStyle(color: Colors.white,fontSize: 15),textAlign: TextAlign.center,)),
              TextButton(onPressed: (){}, child: Text("Site Details",
                style: TextStyle(color: Colors.white,fontSize: 15),textAlign: TextAlign.center,)),
              TextButton(onPressed: (){
               Get.to(()=>ResetPassword());
              }, child: Text("Reset Password",
                style: TextStyle(color: Colors.white,fontSize: 15),textAlign: TextAlign.center,)),
              TextButton(onPressed: (){}, child: Text("New Feature",
                style: TextStyle(color: Colors.white,fontSize: 15),textAlign: TextAlign.center,)),
              TextButton(onPressed: (){}, child: Text("Enhanced Feature",
                style: TextStyle(color: Colors.white,fontSize: 15),textAlign: TextAlign.center,)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        clipBehavior: Clip.hardEdge,
        color: Colors.blue[800],
        child: TextButton(child: Text("LogOut",style: TextStyle(color: Colors.white,)),onPressed: (){
          logOut();
        },),
        elevation: 0,
      ),
    );
  }


  logOut() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("TouchInisLoggedIn", false);
    Get.offAll(()=>LoginSignup(1));
  }
}