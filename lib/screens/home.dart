import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:touchins/model/controller.dart';
import 'package:touchins/model/database.dart';
import 'package:touchins/model/user.dart';
import 'package:touchins/screens/setting.dart';
import 'package:intl/intl.dart';
import 'package:touchins/model/dependencyInjection.dart';

class Home extends StatelessWidget{
  String credit;
  final dbHelper = DatabaseHelper.instance;
  final Map<DateTime, List> _holidays = {
    DateTime(2021, 3, 1): ['New Year\'s Day'],
    DateTime(2021, 3, 2): ['Epiphany'],
    DateTime(2021, 4, 14): ['Valentine\'s Day'],
    DateTime(2021, 4, 15): ['Easter Sunday'],
    DateTime(2021, 5, 25): ['Easter Monday'],
  };

  List<String> notification=["Lorem ipsum dolor sit amet,conse fjgtn","Lorem ipsum dolor sit amet,conse fjgtn",
    "Lorem ipsum dolor sit amet,conse fjgtn","Lorem ipsum dolor sit amet,conse fjgtn"];

  var user = getIt.get<User>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        toolbarHeight: 80,
        leading: Image.asset("assets/images/touchIn.PNG",alignment: Alignment.centerRight,),
        title: Column(
          children: <Widget>[
            Text("TouchIns",textAlign: TextAlign.center,),
            SizedBox(
              height: 10,
            ),
            Text("Kalipro Software",textAlign: TextAlign.center)
          ],
        ),
        centerTitle: true,

        actions: [
          IconButton(icon: Icon(Icons.menu,size: 40,),
              padding: EdgeInsets.only(right: 10,top: 5),
              alignment: Alignment.topLeft,
              onPressed: (){Get.to(()=>Setting());})
        ],
      ),
      body: GetBuilder<Controller>(
        builder: (ctr)=>getBody(ctr.selectedIndex,ctr,context),
      ),
      bottomNavigationBar: GetBuilder<Controller>(
        builder: (ctr)=>Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.lightBlueAccent,
              type: BottomNavigationBarType.fixed,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.timelapse),
                    label: "Shift"
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: "Holiday"
                ),
                BottomNavigationBarItem(icon: Icon(Icons.settings_outlined),label: "Shift Change"),
                BottomNavigationBarItem(icon: Icon(Icons.notifications),label: "Notifications"),
              ],
              currentIndex: ctr.selectedIndex,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white,
              selectedLabelStyle: TextStyle(
                fontSize: 10.0,
              ),
              unselectedLabelStyle: TextStyle(
                  fontSize: 10
              ),
              selectedIconTheme: IconThemeData(
                color: Colors.white,
              ),
              unselectedIconTheme: IconThemeData(
                  color: Colors.white70
              ),
              onTap: (index){
                ctr.setSelectedBarIndex(index);
              },
            ),
          ),
        ),
      )
    );
  }

  Widget getBody(int index,Controller ctrl,BuildContext context){
    if(ctrl.selectedIndex==0){
      return getHomeBarGraph();
    }else if(ctrl.selectedIndex==1){
      return getShiftBarGraph(ctrl.dataMapShift);
    }else if(ctrl.selectedIndex==2){
      return getCalendar();
    }else if(ctrl.selectedIndex==3){
      return getShiftChargeGraph(context);
    }else{
      return getNotification();
    }
  }

  Widget getNotification(){
    return Container(
      height: double.infinity,
      padding: EdgeInsets.only(top: 20,left: 30,right: 30),
      color: Colors.grey[300],
      child:ListView.builder(
          scrollDirection: Axis.vertical,
          physics: ClampingScrollPhysics(),
          itemCount: notification.length+1,
          itemBuilder: (BuildContext context,int index){
            return index==0?getPageView():Card(
              margin: EdgeInsets.only(top: 15),
              elevation: 0,
              color: Colors.white,
              child: ListTile(
                contentPadding: EdgeInsets.only(top: 15,left: 20,right: 20,bottom: 15),
                title: Text(notification[index-1],style: TextStyle(color: Colors.lightBlue),),
                subtitle: Text("1h ago",style: TextStyle(color: Colors.lightBlue,fontSize: 12),),
                trailing: Container(height: 45,width: 45,color: Colors.cyanAccent,),
              ),
            );
          }
      ),
    );
  }

  Widget getPageView(){
    final Controller ctrl = Get.find();
    return Container(//PageView and Indicator
        height: 350,
        child: Column(
          children: <Widget>[
            Container(//PageView
              height:300,
              child: PageView.builder(
                  controller: ctrl.homePageController,
                  scrollDirection: Axis.horizontal,
                  itemCount: notification.length,
                  itemBuilder: (BuildContext context,int index){
                    return Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 180,
                            color: Colors.lightBlueAccent,
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width:150,
                                  margin:EdgeInsets.only(top:30,left: 30),
                                  child: Text(notification[index],style: TextStyle(color: Colors.lightBlue),softWrap: true,),
                                ),
                                Padding(padding: EdgeInsets.only(top: 40),child: Icon(Icons.favorite,color: Colors.blue,),),
                                SizedBox(width: 2,),
                                Padding(padding: EdgeInsets.only(top: 40),child: Text("605",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),),),
                                SizedBox(width: 15,),
                                Padding(padding: EdgeInsets.only(top: 40),child: Icon(Icons.mode_comment,color: Colors.blue,),),
                                SizedBox(width: 2,),
                                Padding(padding: EdgeInsets.only(top: 40),child: Text("102",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),),),                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SmoothPageIndicator(
              count: 4,
              controller: ctrl.homePageController,
              axisDirection: Axis.horizontal,
              effect: ColorTransitionEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: Colors.lightBlue
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        )
    );
  }


  Widget getCalendar(){
    return GetBuilder<Controller>(builder: (ctrl)=>Container(
      child: Column(
        children: <Widget>[
          //Container for Calendar
          Container(
            height: 320,
            margin: EdgeInsets.only(top: 40,left: 40,right: 40),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(0, 0),
                  )
                ]
            ),
            child: Column(
              children: <Widget>[
                //Container for Calendar header
                Container(
                  height: 22,
                  margin: EdgeInsets.only(top: 12,bottom: 10,left: 10,right: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: Colors.blue,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: Offset(0, 0),
                        )
                      ]
                  ),
                  child: Row(
                    children: <Widget>[
                      IconButton(icon: Icon(Icons.arrow_back_ios,size: 10,),alignment: Alignment.centerLeft, onPressed: (){
                        ctrl.setPrevCurrentDate();
                      }),
                      Expanded(
                          child: Text(
                            ctrl.currentMonth,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),textAlign: TextAlign.center,
                          )),
                      IconButton(icon: Icon(Icons.arrow_forward_ios_outlined,size: 10,),alignment: Alignment.centerRight, onPressed: (){
                        ctrl.setNextCurrentDate();
                      })
                    ],
                  ),
                ),
                TableCalendar(
                  holidays: _holidays,
                  calendarController: ctrl.calendarController,
                  initialCalendarFormat: CalendarFormat.month,
                  headerVisible: false,
                  availableGestures: AvailableGestures.none,
                  builders: CalendarBuilders(
                    outsideHolidayDayBuilder: (context, date, _){
                      return Container();
                    },
                    weekendDayBuilder: (context, date, _){
                      return Container(
                        margin: const EdgeInsets.all(11.0),
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            shape: BoxShape.rectangle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.0, 1.0), // shadow direction: bottom right
                              )
                            ]
                        ),
                        child: Text(
                          '${date.day}',
                          textAlign: TextAlign.center,
                          style: TextStyle().copyWith(fontSize: 12.0,color: Colors.blue[900]),
                        ),
                      );
                    },
                    holidayDayBuilder: (context, date, _){
                      return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.rectangle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 1.0), // shadow direction: bottom right
                                )
                              ]
                          ),
                          child: Padding(padding: EdgeInsets.only(top: 5,left: 6,right: 6),
                            child: Text(
                              '${date.day}',
                              style: TextStyle().copyWith(fontSize: 12.0,color: Colors.white),
                            ),)
                      );
                    },

                    outsideWeekendDayBuilder: (context, date, _){
                      return;
                    },
                    //Weekday out of current month
                    outsideDayBuilder: (context, date, _){
                      return ;
                    },
                    dayBuilder: (context, date, _) {
                      return Container(
                        margin: const EdgeInsets.all(11.0),
                        decoration: BoxDecoration(
                            color: Colors.cyanAccent[100],
                            shape: BoxShape.rectangle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.0, 1.0), // shadow direction: bottom right
                              )
                            ]
                        ),
                        child: Text(
                          '${date.day}',
                          textAlign: TextAlign.center,
                          style: TextStyle().copyWith(fontSize: 14.0,color: Colors.blue[900]),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.only(top: 10,left: 50),
              child: Row(
                children: <Widget>[
                  //Calendar bottom Notations
                  Container(
                    height: 15,
                    width: 15,
                    color: Colors.blue,
                  ),
                  SizedBox(width: 2,),
                  Text("Holiday"),
                  SizedBox(width: 4,),
                  Container(
                    height: 15,
                    width: 15,
                    color: Colors.cyanAccent,
                  ),
                  SizedBox(width: 2,),
                  Text("Working Day"),
                  SizedBox(width: 4,),
                  Container(
                    height: 15,
                    width: 15,
                    color: Colors.grey[300],
                  ),
                  SizedBox(width: 2,),
                  Text("Non Working"),
                ],
              )
          )
        ],
      ),
    )
    );
  }

  Widget getHomeBarGraph(){
    final Controller ctrl  =  Get.find();
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 30,left: 30,right: 30),
            decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
                border: Border.all(width: 2,color: Colors.grey[100]),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(0, 0),
                )
              ]
            ),
            child: Container(
              margin: EdgeInsets.only(top: 30,left: 30,right: 30,bottom: 30),
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                border: Border.all(width: 2,color: Colors.white),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: Offset(0, 0),
                    )
                  ]
              ),
              child: Container(
                margin: EdgeInsets.only(top: 30,left: 30,right: 30,bottom: 30),
                child: PieChart(
                  colorList: [Colors.blue,Colors.lightBlueAccent,Colors.lightGreen],
                  legendOptions: LegendOptions(
                      showLegends: false
                  ),
                  dataMap: ctrl.dataMap,
                  chartValuesOptions: ChartValuesOptions(
                    showChartValues: false,
                    showChartValuesOutside: false,
                  ),
                ),
              )
            )
          ),
        ],
      )
    );
  }

  Widget getShiftBarGraph(Map<String,double> data){
    return Container(
        decoration: BoxDecoration(
            color: Colors.grey[200]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(top: 30,left: 30,right: 30),
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                    border: Border.all(width: 2,color: Colors.grey[100]),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(0, 0),
                      )
                    ]
                ),
                child: Container(
                    margin: EdgeInsets.only(top: 30,left: 30,right: 30,bottom: 30),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(width: 2,color: Colors.white),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: Offset(0, 0),
                          )
                        ]
                    ),
                    child: Container(
                      margin: EdgeInsets.only(top: 30,left: 30,right: 30,bottom: 30),
                      child: PieChart(
                        colorList: [Colors.blue,Colors.lightBlueAccent],
                        legendOptions: LegendOptions(
                            showLegends: false
                        ),
                        dataMap: data,
                        chartValuesOptions: ChartValuesOptions(
                          showChartValues: false,
                          showChartValuesOutside: false,
                        ),
                      ),
                    )
                )
            ),
          ],
        )
    );
  }

  Widget getShiftChargeGraph(BuildContext context){
    return Container(
      width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            color: Colors.grey[200]
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 400,
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*.1),
                decoration: BoxDecoration(
                    color: Colors.lightBlue[100],
                    borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: Container(
                    margin: EdgeInsets.only(left: 30,right: 30),
                    decoration: BoxDecoration(
                        color: Colors.lightBlue[50],
                        shape: BoxShape.circle,
                        border: Border.all(width: 2,color: Colors.grey[100]),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: Offset(0, 0),
                          )
                        ]
                    ),
                    child: Container(
                        margin: EdgeInsets.only(top: 20,left: 20,right: 20,bottom: 20),
                        decoration: BoxDecoration(
                            color: Colors.grey[50],
                            shape: BoxShape.circle,
                            border: Border.all(width: 2,color: Colors.white),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: Offset(0, 0),
                              )
                            ]
                        ),
                        child: Container(
                          margin: EdgeInsets.only(top: 50,left: 50,right: 50,bottom: 50),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      offset: Offset(0, 0),
                                    )
                                  ]
                              ),
                              child: Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*.13),
                              child: Text("\$ "+(user.fullName.length*2).toDouble().toString(),style: TextStyle(color: Colors.lightBlue,fontSize: 25,fontWeight: FontWeight.bold),),)
                          ),
                        )
                    )
                ),
              ),
            ],
          ),
        )
    );
  }
}