import 'package:flutter/material.dart';
import 'package:simpli_donate/drawer.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simpli_donate/Pages/Home.dart';
import 'package:dio/dio.dart';

class PointsPage extends StatefulWidget {

  @override
  _PointsPageState createState() => new _PointsPageState();
}

class _PointsPageState extends State<PointsPage> with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController animationController;
  int _points;
  List userList = <String>[];
  List userPoints = <String>[];

  @override
  initState() {
    print("initState");
    getUsersData();
    super.initState();

    animationController =
        AnimationController(duration: Duration(seconds: 4), vsync: this);
    animation = IntTween(begin: 0, end: HomePageState.prefs.get("points")).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeOut));
    animationController.forward();
  }

  void getUsersData() async{
    Response response = await Dio().get("https://experthilarioussystemsoftware--pauljprogrammer.repl.co" + "/users/"+"getusers");
    print(response.data);

    //Response response = await Dio().post("http://10.0.0.9:5000/user/", data: formData);
    print(response.statusCode);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.indigo[100],
      appBar: AppBar(
        title: Text("Points"),
      ),
      body: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
                    child: Image.asset('assets/stars.png'),
                  ),
                ),
                Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(right: 15.0, top: 45.0),
                      child: AnimatedBuilder(
                          animation: animationController,
                          builder: (BuildContext context, Widget child) {
                            return
                                            Text(
                                              animation.value.toString(),
                                              style: TextStyle(
                                                  fontSize: 75,
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black),
                                            );

                          })
                    ))
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 15, top: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "LeaderBoard:",
                  style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.pinkAccent),
                ),
              ),
            ),
           Expanded(
             child:  ListView.builder(

               scrollDirection: Axis.vertical,
               shrinkWrap: true,
               itemCount: 10,
               itemBuilder: (BuildContext context, int index) {
                 return Card(
                   elevation: 8.0,
                   margin:
                   new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                   child: Container(
                     decoration:
                     BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                     child: ListTile(
                         contentPadding: EdgeInsets.symmetric(
                             horizontal: 20.0, vertical: 10.0),
                         leading: Container(
                           padding: EdgeInsets.only(right: 12.0),
                           decoration: new BoxDecoration(
                               border: new Border(
                                   right: new BorderSide(
                                       width: 1.0, color: Colors.white24))),
                           child: Icon(Icons.star, color: Colors.white),
                         ),
                         title: Text(
                           "Vincent Jia",
                           style: TextStyle(
                               color: Colors.white, fontWeight: FontWeight.bold),
                         ),
                         // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                         subtitle: Row(
                           children: <Widget>[
                             Icon(Icons.linear_scale,
                                 color: Colors.yellowAccent),
                             Text("",
                                 style: TextStyle(color: Colors.white))
                           ],
                         ),
                         trailing: Text("435",
                             style: TextStyle(color: Colors.white))),
                   ),
                 );
               },
             ),
           )
          ],
        ),

      drawer: SideDrawer(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
