import 'package:flutter/material.dart';
import 'package:simpli_donate/Pages/Home.dart';
import 'package:simpli_donate/Pages/Points.dart';
import 'package:simpli_donate/Pages/Locations.dart';
import 'package:simpli_donate/Pages/Settings.dart';

class SideDrawer extends StatelessWidget {
  int _points;

  SideDrawer() {

  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Home Page'),
            leading: Icon(Icons.home),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, new MaterialPageRoute(builder: (context) => HomePage()));

            },
          ),
          ListTile(
            title: Text('Nearby Locations'),
            leading: Icon(Icons.add_location),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, new MaterialPageRoute(builder: (context) => LocationsPage()));
            },
          ),
          ListTile(
            title: Text('Points'),
            leading: Icon(Icons.star),
            onTap: () {
              print("hoew many points: ");
              print(_points);
              print("end");
              Navigator.pop(context);
              Navigator.push(context, new MaterialPageRoute(builder: (context) => PointsPage()));
            },
          ),
          ListTile(
            title: Text('Settings'),
            leading: Icon(Icons.settings),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, new MaterialPageRoute(builder: (context) => SettingsPage()));
            },
          ),
        ],
      ),
    );
  }

}
