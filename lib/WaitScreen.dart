import 'dart:developer';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:scoring_flutter/WebSocketController.dart';
import 'package:scoring_flutter/Widgets.dart';
import 'package:scoring_flutter/ScoringFreestyleScreen.dart';
import 'package:scoring_flutter/ScoringRecognizedScreen.dart';



class WaitPage extends StatefulWidget {

  final WebSocketsController _ws;
  WaitPage({@required WebSocketsController ws, String Competition, String Judge}) : _ws = ws;

  @override
  WaitPageState createState() => WaitPageState();
}

class WaitPageState extends State<WaitPage> {

  String _dots = "";

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit the wait screen'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: new Text('Yes'),
          ),
        ],
      ),
    ) ?? false;
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Waiting server data"),
        ),
        body: Container(
          child: Column (
            children: <Widget>[
              Text("Competition"),
              Text("Judge"),
              Text("Waiting $_dots"),
            ],
          ),
        ),
      )
    );
  }

}