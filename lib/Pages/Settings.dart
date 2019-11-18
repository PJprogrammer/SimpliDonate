import 'package:flutter/material.dart';
import 'package:simpli_donate/drawer.dart';
import 'package:card_settings/card_settings.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => new _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String name = "Paul";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.indigo[100],
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Form(
        key: _formKey,
        child: CardSettings(
          children: <Widget>[
            CardSettingsHeader(label: 'Bio'),
            CardSettingsText(
              label: 'Name',
              initialValue: name,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Title is required.';
              },
              onSaved: (value) => name = value,
            ),
          ],
        ),
      ),
      drawer: SideDrawer(),
    );
  }
}