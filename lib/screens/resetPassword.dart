import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touchins/model/controller.dart';
import 'package:touchins/model/database.dart';

import 'home.dart';

// ignore: must_be_immutable
class ResetPassword extends StatelessWidget{

  final RegExp passwordRegex = new RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  bool isLoginPasswordValid=false,oldPasswordMatch=false;
  final String fullName="",email="";
  Controller ctrl;
  @override
  Widget build(BuildContext context) {
    ctrl = Get.find();
    getOldPassword();
    return Scaffold(backgroundColor: Colors.blue[300],
      appBar: AppBar(
        title: Text("Reset Password",),
      ),
      body: GetBuilder<Controller>(
        builder: (ctr)=>SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Container(
            padding: EdgeInsets.only(top: 30,left: 40,right: 40),
            child: Column(
              children: <Widget>[
                TextField(
                  cursorHeight: 20,
                  style: TextStyle(height: .5),
                  onChanged: (value){_oldPassword(value);},
                  keyboardType: TextInputType.text,
                  obscureText: true, // because it's a password
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: "Old password",
                    hintStyle:  TextStyle(
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1,color: Colors.pink),
                    ),
                    border: OutlineInputBorder(borderSide: BorderSide(width: 1,color: Colors.pink),),
                    errorText: (!ctr.oldPasswordMatch)?"Invalid Old Password":null,
                    errorStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 15
                    ),
                  ),
                ),
                Divider(
                  color: Colors.white,
                  thickness: 2,
                ),
                TextField(
                  cursorHeight: 20,
                  style: TextStyle(height: .5),
                  onChanged: (value){_newPasswordOnChanged(value);},
                  keyboardType: TextInputType.text,
                  obscureText: true, // because it's a password
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "New Password",
                      hintStyle:  TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1,color: Colors.pink),
                      ),
                      border: OutlineInputBorder(borderSide: BorderSide(width: 1,color: Colors.pink),),
                      errorText: (!ctr.isLoginPasswordValid && ctr.newpassword!="")?"Password should have lowercase character,uppercase character"
                          ",special character and number  ":null,
                      errorStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 15
                      ),
                      errorMaxLines: 4
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  cursorHeight: 20,
                  style: TextStyle(height: .5),
                  onChanged: (value){_confirmPasswordOnChanged(value);},
                  keyboardType: TextInputType.text,
                  obscureText: true, // because it's a password
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: "Confirm Password",
                    hintStyle:  TextStyle(
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1,color: Colors.pink),
                    ),
                    border: OutlineInputBorder(borderSide: BorderSide(width: 1,color: Colors.pink),),
                    errorText: (ctr.confirmPassword!=ctr.newpassword && ctr.confirmPassword!="")?"New Password didn't match Password":null,
                    errorStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 15
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: GetBuilder<Controller>(
        builder: (ctr)=>BottomAppBar(
          clipBehavior: Clip.hardEdge,
          color: Colors.blue[800],
          child: TextButton(child: Text("Update Password",style: TextStyle(color: Colors.white,)),onPressed: (){
            print(!ctr.isLoginPasswordValid);
            print(ctr.oldPasswordMatch);
            print( ctr.newpassword==ctr.confirmPassword);
            print(ctr.newpassword!="");
            if(ctr.isLoginPasswordValid && ctr.oldPasswordMatch && ctr.newpassword==ctr.confirmPassword && ctr.newpassword!=""){
              setPassword();
              Get.offAll(()=>Home());
            }
          },),
          elevation: 0,
        ),
      )
    );
  }

  void _oldPassword(String pass){
    if(pass.isNotEmpty) {
      if (ctrl.validatePassword==pass) {
        ctrl.setOldPassword(pass);
        ctrl.setOldPasswordMatch(true);
        print(ctrl.validatePassword+":"+pass);
      } else {
        ctrl.setOldPasswordMatch(false);
      }
    }
  }

  void _newPasswordOnChanged(String pass){
    if(pass.isNotEmpty) {
      if (passwordRegex.hasMatch(pass)) {
        print(pass);
        ctrl.setNewPassword(pass);
      } else {
        ctrl.setLoginPasswordValid(false);
      }
    }
  }

  void _confirmPasswordOnChanged(String pass){
    ctrl.setConfirmPass(pass);
  }

  getOldPassword() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ctrl.setValidatePass(prefs.getString("TouchInPassWord"));
    print(ctrl.validatePassword);
  }

  setPassword() async{
    print("Done");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> row = {
      DatabaseHelper.columnPassword : ctrl.newpassword,
    };
    final dbHelper = DatabaseHelper.instance;
    final id = await dbHelper.update(row,prefs.getString("TouchInEmail"));
    prefs.setString("TouchInPassWord", ctrl.newpassword);
    ctrl.setOldPassword(prefs.getString("TouchInPassWord"));
  }
}