import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:scoring_flutter/Widgets.dart';

class ScorePage extends StatefulWidget {
    @override
    _ScorePageState createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {


  @override
  Widget build(BuildContext context) {

    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
        body: Container(
          child: PresentationDisplay(),
        ),
    );
  }
}
