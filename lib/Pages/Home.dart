import 'package:flutter/material.dart';
import 'package:simpli_donate/drawer.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:random_string/random_string.dart' as random;
import 'package:path_provider/path_provider.dart';


class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  final int port = 5000;
  final String ip = "10.0.0.9";

  //addDonationItem Dialog
  final TextEditingController _itemController = TextEditingController();
  List _requests = ["Food", "Clothing", "Other"];
  String _selectedRequest = "Food";
  List<DropdownMenuItem<String>> _dropDownMenuRequests;
  bool isChecked = false;

  //List Builder
  List _itemName = <String>[];
  List _itemPickup = <String>[];
  List _itemImage = <File>[];

  //Points system
  static SharedPreferences prefs;
  int points;
  String userID;

  //
  File _image;

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String request in _requests) {
      items.add(new DropdownMenuItem(value: request, child: new Text(request)));
    }
    return items;
  }

  void changeDropDownItem(String selectedReq) {
    _selectedRequest = selectedReq;
    Navigator.of(context, rootNavigator: true).pop();
    addDonationItem();
  }

  Future captureImage() async {
    File newImage = await ImagePicker.pickImage(
      source: ImageSource.camera
      //maxHeight: 50.0,
      //maxWidth: 50.0,
    );
    Directory appDocDir = await getApplicationDocumentsDirectory();
    _image = await newImage.copy(appDocDir.path + "/" + random.randomAlphaNumeric(10) + '.jpg');
    Navigator.of(context, rootNavigator: true).pop();
    addDonationItem();
  }

  List<Widget> getDynamicImageView() {
    if (_image == null) {
      return <Widget>[
        IconButton(
          alignment: Alignment.centerLeft,
          icon: Icon(Icons.camera_alt),
          color: Colors.black,
          iconSize: 35,
          onPressed: () {
            captureImage();
          },
        ),
        SizedBox(
          width: 20,
        ),
        Text("*optional\nTake a picture of the donation item\n"
            "to insure it is a valid item accepted\n"
            "by the donation center.")
      ];
    } else {
      return <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 35.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.file(
              _image,
              height: 75,
              alignment: Alignment.center,
            ),
          ),
        )
      ];
    }
  }

  void sendData() async{
    FormData formData = new FormData.from({
      "name": userID,
      "points": points,
      "itemName": _itemName.last,
      "itemPickup": _itemPickup.last,
      "file": new UploadFileInfo(_image, _itemImage.last.path.split("/").last),
    });
    Response response = await Dio().post("https://experthilarioussystemsoftware--pauljprogrammer.repl.co" + "/users/"+userID, data: formData);
    print("Resposne code: " + response.statusCode.toString());
  }

  //Dialog to add donation item
  void addDonationItem() {
    showDialog(
        context: context,
        builder: (_) => new SimpleDialog(
              contentPadding: EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              title: Image.asset(
                'assets/donate-food.png',
                //350 width
              ),
              titlePadding: EdgeInsets.zero,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 10.0),
                        child: Text("Item: ",
                            style: TextStyle(
                              fontSize: 18.0,
                            )),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 100.0, 10.0),
                        child: DropdownButton(
                          value: _selectedRequest,
                          items: _dropDownMenuRequests,
                          onChanged: changeDropDownItem,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 10.0),
                        child: Text("Pickup: ",
                            style: TextStyle(
                              fontSize: 18.0,
                            )),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 175.0, 10.0),
                        child: Checkbox(
                          value: isChecked,
                          onChanged: (value) {
                            isChecked = value;
                            Navigator.of(context, rootNavigator: true).pop();
                            addDonationItem();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Row(children: getDynamicImageView()),
                    SizedBox(
                      height: 16.0,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Wrap(
                        children: <Widget>[
                          FlatButton(
                            onPressed: () {},
                            child: Text("Next"),
                          ),
                          RaisedButton(
                            onPressed: () {
                              setState(() {
                                _itemImage.add(_image);
                                _itemName.add(_selectedRequest);
                                if (isChecked) {
                                  _itemPickup.add("Pickup");
                                  setPoints(50);
                                } else {
                                  _itemPickup.add("Drop-off");
                                  setPoints(100);
                                }
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                sendData();
                                _image = null;
                              });
                            },
                            child: Text("Finish"),
                          )
                        ],
                      ),
                    )
                  ],
                )
              ],
            ));
  }

  //Dialog to display card details
  void showDonationItem(int index) {}

  void setPoints(int earnedPoints) {
      prefs.setInt('points', points+earnedPoints);

      print("From set Points");
      //List<String> itemName = new List<String>();
      //_itemName.forEach((item) => itemName.add(item));
      prefs.setStringList("itemName", _itemName);

      //List<String> itemPickup = new List<String>();
      //_itemPickup.forEach((item) => print(item));
      prefs.setStringList("itemPickup", _itemPickup);
      //print(_itemPickup);
      //print(itemPickup);

      List filesPath = <String>[];
      _itemImage.forEach((file) => filesPath.add(file.path));
      prefs.setStringList("itemImage", filesPath);
      print("From setPoints: files path = $filesPath");
  }

  void initPrefs() async{
    if(prefs==null) {
      prefs = await SharedPreferences.getInstance();
    }

    //print("From init Preferences");
    //List
    if(prefs.getKeys().contains("itemName")) {
      //List<String> itemName = new List<String>();
      //itemName.forEach((item) => _itemName.add(item));
      //_itemName.addAll(prefs.get("itemName"));
      //print("From initPrefs $_itemName");
      _itemName = prefs.getStringList("itemName");
      //print("From initPrefs $_itemName");
      print("From init Prefs item$_itemName");
    }
    if(prefs.getKeys().contains("itemPickup")) {
//      List<String> itemPickup = new List<String>();
//      itemPickup.forEach((item) => _itemPickup.add(item));
      _itemPickup = prefs.getStringList("itemPickup");
    }
    if(prefs.getKeys().contains("itemImage")) {
      List filesPath = prefs.get("itemImage");
      filesPath.forEach((path) => _itemImage.add(new File(path)));
    }
    //print(_itemPickup);


    //Points
    if(!prefs.getKeys().contains("points")) {
      prefs.setInt('points', 0);
    }
    points = prefs.get("points");

    //App ID
    if(!prefs.getKeys().contains("userID")) {
      prefs.setString("userID", random.randomAlphaNumeric(10));
    }
    userID = prefs.get("userID");

    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    print("OK MOTOE");
    initPrefs();
    _dropDownMenuRequests = getDropDownMenuItems();
  }

  @override
  Widget build(BuildContext ctxt) {
    return Scaffold(
      backgroundColor:Colors.indigo[100],
      appBar: AppBar(
        title: Text("Home"),
      ),
      drawer: SideDrawer(),
      body: ListView.builder(
        padding: EdgeInsets.only(left: 1.0, top: 5.0, right: 1.0, bottom: 0.0),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: _itemImage.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              elevation: 8.0,
              margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Container(
                decoration:
                    BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  leading: Container(
                      padding: EdgeInsets.only(right: 12.0),
                      decoration: new BoxDecoration(
                          border: new Border(
                              right: new BorderSide(
                                  width: 1.0, color: Colors.white24))),
                      child: (_itemName[index] == "Food")
                          ? Icon(
                              MdiIcons.food,
                              color: Colors.white,
                              size: 40,
                            )
                          : Icon(MdiIcons.tshirtCrew,
                              color: Colors.white, size: 40)),
                  title: Row(
                    children: <Widget>[
                      Text(
                        _itemName[index],
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 50,
                        height: 25,
                      ),
                      Icon(
                        MdiIcons.file
                      )
                    ],
                  ),
                  subtitle: Row(
                    children: <Widget>[
                      (_itemPickup[index] == "Pickup")
                          ? Icon(MdiIcons.truck, color: Colors.white, size: 20)
                          : Icon(MdiIcons.mailboxOpen,
                              color: Colors.white, size: 20),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(_itemPickup[index],
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  trailing: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Image.file(
                      _itemImage[index],
                      height: 50,
                    ),
                  ),
                  onTap: () {
                    showDonationItem(index);
                  },
                ),
              ));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addDonationItem,
        tooltip: 'Donate',
        child: Icon(Icons.add),
      ),
    );
  }
}
