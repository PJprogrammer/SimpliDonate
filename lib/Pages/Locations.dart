import 'package:flutter/material.dart';
import 'package:simpli_donate/drawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationsPage extends StatefulWidget {
  @override
  _LocationsPageState createState() => new _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  GoogleMapController myController;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor:Colors.indigo[100],
      body: Column(
        children: <Widget>[
          Container(
            height: 500.0,
            width: double.maxFinite,
            child: GoogleMap(
              onMapCreated: (controller) {
                setState(() {
                  myController = controller;
                });
              },
              initialCameraPosition: CameraPosition(
                  target: LatLng(40.71573, -74.04078),
                  zoom: 19.5
              ),
              //scrollGesturesEnabled: false,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          FlatButton(
            child: Text('Find Nearby Centers'),
            color: Colors.blue,
            onPressed: () {

            },
          )
        ],
      ),
      appBar: AppBar(
        title: Text("Nearby Locations"),
      ),
      drawer: SideDrawer(),
    );
  }
}