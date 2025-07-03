import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touchins/model/codeCountry.dart';
import 'package:touchins/model/database.dart';
import 'package:touchins/model/dependencyInjection.dart';
import 'package:touchins/model/user.dart';

import 'home.dart';


class LoginSignup extends StatefulWidget{
  int setColor;
  LoginSignup(this.setColor);
  _LoginSignup createState()=> _LoginSignup();
}

class _LoginSignup extends State<LoginSignup> with TickerProviderStateMixin {
  TabController _tabController;
  TextEditingController dateCtl = TextEditingController();
  RegExp regExp = new RegExp(r'^[?:[a-zA-Z]+/s[a-zA-Z]+$',);
  RegExp passwordRegex = new RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  bool isNameValid=true,isEmailValid=true,isPasswordValid=false;
  bool isLoginEmailValid=true,isLoginPasswordValid=false;
  String fullName="",email="",password="";
  String validateEmail="",validatePassword="";
  bool isLoggedIn=false;
  String dob="";
  String country="";
  String county="";
  String city="";
  String street="";
  String credit="";
  bool valid=false;
  CodeCountries selectedCode;
  int _tabIndex;
  List<DropdownMenuItem<CodeCountries>> listDropName = [];
  List<CodeCountries> codeCountries = [];
  final dbHelper = DatabaseHelper.instance;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
      _tabController = TabController(
        initialIndex: 0,
        length: 2,
        vsync: this,
      );
    setState(() {
      this.isEmailValid=false;
      this.isNameValid=false;
      this.isPasswordValid=false;
      this.valid=false;
      codeCountries = CodeCountries.fromMap();
      codeCountries.forEach((element) {
        listDropName.add(DropdownMenuItem(
          child: Text(element.name.toString()), value: element,));
      });
      _tabIndex=0;
    });
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: getBackColour(),
          toolbarHeight: 130,
          title: Padding(padding: EdgeInsets.only(top: 30,left: MediaQuery.of(context).size.width*.35),
            child:Text("TouchIn",textAlign: TextAlign.center,) ,),
          bottom: TabBar(
            onTap: (value){
              setState(() {
                _tabIndex=value;
              });
            },
            isScrollable: true,
            controller: _tabController,
              tabs:[
                Tab(child: Container(
                  width: MediaQuery.of(context).size.width*.3,
                  child: Text("SIGN UP",textAlign: TextAlign.center,),
                ),),
                Tab(child: Container(
                  width: MediaQuery.of(context).size.width*.3,
                  child: Text("LOGIN",textAlign: TextAlign.center,),
                ),),
              ],
            indicatorWeight: 1,
            //labelPadding: EdgeInsets.symmetric(horizontal: 10.0),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            SignUp(),
            Login()
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: _tabIndex==1?Colors.green:Colors.purple,
          child: IconButton(icon: Icon(Icons.arrow_forward_outlined), onPressed: (){
            if(_tabController.index==0){
              if(_formKey.currentState.validate()){
                addUserDetailsToSF();
              }
            }else{
              if(_formKey2.currentState.validate()){
                validateLogin();
              }
            }
          }),
          elevation: 0,
        ),
      );
    }

    MaterialColor getBackColour(){
      return _tabController.index==0?Colors.purple:Colors.green;
    }

    Widget SignUp(){
      return Container(
        //color: Colors.brown[],
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(left: 40,right: 40),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        validator: (value) {
                          if (value=="" || !isNameValid) {
                            return 'Please enter valid name';
                          }
                          return null;
                        },
                        style: TextStyle(height: .5),
                        onChanged: _nameOnChanged,
                        decoration: InputDecoration(
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
                          errorText: (!isNameValid && fullName!="")?"Special Character,numbers are Not allowed.":null,
                        ),
                        maxLines: 1,
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value=="" || !isEmailValid) {
                            return 'Please enter valid email address';
                          }
                          return null;
                        },
                        style: TextStyle(height: .5),
                        onChanged: _emailOnChanged,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(hintText: "Your Email Address",
                            hintStyle: TextStyle(
                              fontSize: 8.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
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
                            return 'Please enter password';
                          }else if(!isPasswordValid){
                            return 'Password should be combination of alphabets,digit and special character';
                          }
                          return null;
                        },
                        style: TextStyle(height: .5),
                        onChanged: (value){_passwordOnChanged(value);},
                        keyboardType: TextInputType.text,
                        obscureText: true, // because it's a password
                        decoration: InputDecoration(
                            hintText: "Your password",
                            hintStyle:  TextStyle(
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1,color: Colors.pink),
                            ),
                            border: OutlineInputBorder(borderSide: BorderSide(width: 1,color: Colors.pink),),
                            labelText: "Your password",
                            labelStyle: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                            errorMaxLines: 2
                        ),
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      Text("Personal Information"),
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
                          controller: dateCtl,
                          style: TextStyle(height: .5),
                          onChanged: (value){_dateOfBirth(dateCtl.text);},
                          keyboardType: TextInputType.datetime,
                          cursorHeight: 20,
                          decoration: InputDecoration(
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

                            dateCtl.text = date.toString().split(" ")[0];
                            dob = dateCtl.text;}
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      DropdownButtonHideUnderline(child: DropdownButtonFormField<CodeCountries>(
                        validator: (value) {
                          if (this.selectedCode==null) {
                            return "* Required";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: "Country",
                          labelStyle: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                          border: OutlineInputBorder(borderSide: BorderSide(width: 1,color: Colors.pink),),
                        ),
                        isDense: true,
                        items: listDropName,
                        value: selectedCode,
                        isExpanded: true,
                        onChanged: (CodeCountries newValue) {
                          setState(() {
                            this.selectedCode = newValue;
                            this.country = newValue.name;
                          });
                        },
                      ),),
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
                        style: TextStyle(height: .5),
                        onChanged: (value){_countyChanged(value);},
                        keyboardType: TextInputType.text,
                        cursorHeight: 20,
                        decoration: InputDecoration(
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
                        style: TextStyle(height: .5),
                        onChanged: (value){_cityChanged(value);},
                        keyboardType: TextInputType.text,
                        cursorHeight: 20,
                        decoration: InputDecoration(
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
                        style: TextStyle(height: .5),
                        onChanged: (value){_streetChanged(value);},
                        keyboardType: TextInputType.text,
                        cursorHeight: 20,
                        decoration: InputDecoration(
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
      );
    }

    Widget Login(){
      return Container(
        child: SingleChildScrollView(
          child:Form(
            key: _formKey2,
            child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.only(left: 40,right: 40),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      style: TextStyle(height: .5),
                      validator: (value) {
                        if (value=="" || !isLoginEmailValid) {
                          return 'Please enter valid email';
                        }
                        return null;
                      },
                      onChanged: (value){_loginEmailOnChanged(value);},
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(hintText: "Your Email Address",
                        hintStyle: TextStyle(
                          fontSize: 8.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
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
                        //errorText: (!isLoginEmailValid && validateEmail!="")?"Please enter valid email":null
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      style: TextStyle(height: .5),
                      validator: (value) {
                        if (value=="" || !isLoginPasswordValid) {
                          return 'Please enter valid password';
                        }
                        return null;
                      },
                      onChanged: (value){_loginPasswordOnChanged(value);},
                      keyboardType: TextInputType.text,
                      obscureText: true, // because it's a password
                      decoration: InputDecoration(
                          hintText: "Your password",
                          hintStyle:  TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1,color: Colors.pink),
                          ),
                          border: OutlineInputBorder(borderSide: BorderSide(width: 1,color: Colors.pink),),
                          labelText: "Your password",
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
                height: MediaQuery.of(context).size.height*.59,
              ),
            ],
          ),)
        ),
      );
    }

  Future<dynamic> _onSignUp() async{
    return Navigator.push(
        context, MaterialPageRoute(builder: (context) => Home()));
  }

  void _nameOnChanged(String name){
    if(name.isNotEmpty){
      if(name.contains(RegExp(r'[0-9]'),0) || name==null || name.contains(RegExp(r'[@#$&%!~]'),0)){
        isNameValid=false;
      }else{
        isNameValid=true;
      }
    }
    setState(() {
      fullName=name;
    });
  }

  void _emailOnChanged(String emailID){
    if(emailID.isNotEmpty){
      if(EmailValidator.validate(emailID)){
        isEmailValid=true;
      }else{
        isEmailValid=false;
      }
    }
    setState(() {
      email=emailID;
      validateEmail = emailID;
    });
  }
  void _dateOfBirth(String text){
    setState(() {
      dob=text;
    });
  }
  void _loginEmailOnChanged(String emailID){
    if(emailID.isNotEmpty){
      if(EmailValidator.validate(emailID)){
        isLoginEmailValid=true;
      }else{
        isLoginEmailValid=false;
      }
    }
    setState(() {
      validateEmail = emailID;
    });
  }

  void _countryChange(String text){
    setState(() {
      country=text;
    });
  }

  void _countyChanged(String text){
    setState(() {
      county=text;
    });
  }

  void _cityChanged(String text){
    setState(() {
      city=text;
    });
  }

  void _streetChanged(String text){
    setState(() {
      street=text;
    });
  }

  void _passwordOnChanged(String pass){
    if(pass.isNotEmpty) {
      if (passwordRegex.hasMatch(pass)) {
        isPasswordValid = true;
        setState(() {
          password = pass;
          validatePassword=pass;
        });
      } else {
        isPasswordValid = false;
      }
    }
  }

  void _loginPasswordOnChanged(String pass){
    if(pass.isNotEmpty) {
      if (passwordRegex.hasMatch(pass)) {
        isLoginPasswordValid = true;
        setState(() {
          validatePassword=pass;
        });
      } else {
        isLoginPasswordValid = false;
      }
    }
  }

  addUserDetailsToSF() async{
    //storing data locally so that we can use this on Myprofile Screen and for
    //maintaining user state while restart
    var user = getIt.get<User>();
    try{
      Map<String, dynamic> row = {
        DatabaseHelper.columnFullName : this.fullName,
        DatabaseHelper.columnEmail  : this.email,
        DatabaseHelper.columnPassword  : this.password,
        DatabaseHelper.columnCountry  : this.country,
        DatabaseHelper.columnCounty  : this.county,
        DatabaseHelper.columnDob  : this.dob,
        DatabaseHelper.columnCity  : this.city,
        DatabaseHelper.columnStreet  : this.street,
        DatabaseHelper.columnCredit  : (this.fullName.length*2).toDouble().toString(),
      };
      var id =await dbHelper.insert(row);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("TouchInFullName",this.fullName);
        prefs.setString("TouchInPassWord",this.password);
        prefs.setString("TouchInEmail", this.email);
        prefs.setString("TouchInDob", this.dob);
        prefs.setString("TouchInCountry", this.country);
        prefs.setString("TouchInCounty", this.county);
        prefs.setString("TouchInCity", this.city);
        prefs.setString("TouchInStreet", this.street);
        prefs.setString("TouchInCredit", (this.fullName.length*2).toDouble().toString());
        prefs.setBool("TouchInisLoggedIn", true);
        print(prefs.getString("TouchInPassWord"));
        setState(() {
          user.fullName = this.fullName;
          user.street = this.street;
          user.city = this.city;
          user.county = this.county;
          user.credit = (this.fullName.length*2).toDouble().toString();
          user.country = this.country;
          user.dob = this.dob;
          user.email = this.email;
        });
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home()));
    }catch(e){
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Email already exists.'
        ,style: TextStyle(color: Colors.white),),backgroundColor: Colors.green,));
    }
  }

  validateLogin() async{
    print(validateEmail);
    User user;
    try{
      user = await User.getUserDetails(validateEmail);
      if(user.email==validateEmail && user.password==validatePassword){
        SharedPreferences prefs = await SharedPreferences.getInstance();
        print(user.fullName);
        prefs.setString("TouchInFullName",user.fullName);
        prefs.setString("TouchInPassWord",user.password);
        prefs.setString("TouchInEmail", user.email);
        prefs.setString("TouchInDob", user.dob);
        prefs.setString("TouchInCountry", user.country);
        prefs.setString("TouchInCounty", user.county);
        prefs.setString("TouchInCity", user.city);
        prefs.setString("TouchInStreet", user.street);
        prefs.setString("TouchInCredit", user.credit);
        prefs.setBool("TouchInisLoggedIn", true);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home()));
      }else{
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Please enter valid credentials'
          ,style: TextStyle(color: Colors.white),),backgroundColor: Colors.blue,));
      }
    } catch(e){
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please enter valid credentials'
        ,style: TextStyle(color: Colors.white),),backgroundColor: Colors.blue,));
    }
    print(this.isLoggedIn);
  }

}
