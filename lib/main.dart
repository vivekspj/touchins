import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:touchins/model/dependencyInjection.dart';
import 'package:touchins/model/user.dart';
import 'package:touchins/screens/home.dart';
import 'package:touchins/screens/loginsignup.dart';

import 'model/controller.dart';

//get shared date for future reference on My profile page
String touchInsFullName,touchInsEmail;
String dob, country, county, city,street,credit;
bool isLoggedInTouchIns;
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  getService();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  touchInsFullName = await prefs.getString("TouchInFullName");
  touchInsEmail = await prefs.getString("TouchInEmail");
  dob = await prefs.getString("TouchInDob");
  country = await prefs.getString("TouchInCountry");
  county = await prefs.getString("TouchInCounty");
  city = await prefs.getString("TouchInCity");
  street = await prefs.getString("TouchInStreet");
  credit = await prefs.getString("TouchInCredit");
  isLoggedInTouchIns=await prefs.getBool("TouchInisLoggedIn")==null?false:prefs.getBool("TouchInisLoggedIn");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(getIt.get<Controller>());
    controller.setUser(touchInsFullName, touchInsEmail,dob,country,county,city,street);
    return GetMaterialApp(
      title: 'TouchIns',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isLoggedInTouchIns?Home():MyHomePage(),
    );
  }
}

/*class MyHomePage extends StatefulWidget {
  final String title;
  MyHomePage(this.title);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}*/

class MyHomePage extends StatelessWidget {

  final List<Widget> _pages = List.empty(growable: true);

  void setList(BuildContext context){
      _pages.add(page1(context));
      _pages.add(page2(context));
      _pages.add(page3(context));
  }

  @override
  Widget build(BuildContext context) {
    setList(context);
    return getInitialPages(context);
  }

  Widget getInitialPages(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.cyanAccent[50],
      body: _buildBody(context)
    );
  }

  Widget _buildBody(BuildContext context){
    final Controller ctrl = Get.find();
    return Container(
      child:Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height*0.90,
            child: PageView.builder(
              itemCount: 3,
              controller: ctrl.pageController,
              scrollDirection: Axis.horizontal,
              physics: ScrollPhysics(),
              itemBuilder: (BuildContext context,int index){
                return _pages[index];
              },
              onPageChanged: (index){
                ctrl.setPageIndex(index);
              },
            ),
          ),
          //Bottom Part of welcomescreens
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                TextButton(onPressed: (){
                  Get.off(()=>LoginSignup(1));
                }, child: Text("SKIP",style: TextStyle(
                    color: Colors.lightBlue,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                ),)),
                SizedBox(
                  width: MediaQuery.of(context).size.width*.22,
                ),
                SmoothPageIndicator(
                  count: 3,
                  controller: ctrl.pageController,
                  axisDirection: Axis.horizontal,
                  effect: ColorTransitionEffect(
                      activeDotColor: Colors.black
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width*.22,
                ),
                TextButton(onPressed: (){
                  if(ctrl.pageIndex==2){
                    Get.off(()=>LoginSignup(1));
                  }
                  ctrl.pageController.nextPage(duration: Duration(milliseconds: 1000), curve: Curves.ease);
                }, child: Text("NEXT",style: TextStyle(
                  color: Colors.lightBlue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),)),
              ],
            )
          ),
        ],
      )
    );
  }

  Widget page3(BuildContext context){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(top: 60),
              child: SizedBox(
                height: 35,
                child: Padding(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.25),
                  child: Row(
                    children: <Widget>[
                      Image.asset("assets/images/touchIn.PNG"),
                      SizedBox(
                        width: 10,
                      ),
                      Text("TouchIns",style: TextStyle(color: Colors.lightBlue,fontSize: 25,),)
                    ],
                  ),
                ),
              )
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              width: MediaQuery.of(context).size.width*1,
              height: MediaQuery.of(context).size.width*1,
              decoration: new BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*.25,right:MediaQuery.of(context).size.width*.22 ),
                  child: Flex(
                    direction: Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(child: Text("Birds eye view of your shift",style: TextStyle(
                          color: Colors.white,
                          fontSize: 25
                      ),textAlign: TextAlign.center,),)
                    ],
                  ),
                ),
              )
          ),
        ],
      ),
    );
  }

  Widget page2(BuildContext context){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(top: 60),
              child: SizedBox(
                height: 35,
                child: Padding(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.25),
                  child: Row(
                    children: <Widget>[
                      Image.asset("assets/images/touchIn.PNG"),
                      SizedBox(
                        width: 10,
                      ),
                      Text("TouchIns",style: TextStyle(color: Colors.lightBlue,fontSize: 25,),)
                    ],
                  ),
                ),
              )
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              width: MediaQuery.of(context).size.width*1,
              height: MediaQuery.of(context).size.width*1,
              decoration: new BoxDecoration(
                color: Colors.blue[600],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*.25,right:MediaQuery.of(context).size.width*.22 ),
                  child: Flex(
                    direction: Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(child: Text("Supervisor knows shift employees and every related aspect",style: TextStyle(
                          color: Colors.white,
                          fontSize: 25
                      ),textAlign: TextAlign.center),)
                    ],
                  ),
                ),
              )
          ),
        ],
      ),
    );
  }
  Widget page1(BuildContext context){
    return new Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 60),
            child: SizedBox(
              height: 35,
              child: Padding(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.25),
                child: Row(
                  children: <Widget>[
                    Image.asset("assets/images/touchIn.PNG"),
                    SizedBox(
                      width: 10,
                    ),
                    Text("TouchIns",style: TextStyle(color: Colors.lightBlue,fontSize: 25,),)
                  ],
                ),
              ),
            )
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              width: MediaQuery.of(context).size.width*1,
              height: MediaQuery.of(context).size.width*1,
              decoration: new BoxDecoration(
                color: Colors.lightBlue[600],
                shape: BoxShape.circle,
              ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*.25,right:MediaQuery.of(context).size.width*.25 ),
                child: Flex(
                  direction: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(child: Text("Employee knows his Shifts and every related aspect",style: TextStyle(
                        color: Colors.white,
                        fontSize: 25
                    ),textAlign: TextAlign.center),)
                  ],
                ),
              ),
            )
          ),
        ],
      ),
    );
  }
}
