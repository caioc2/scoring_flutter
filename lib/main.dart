import 'package:flutter/material.dart';
import 'package:scoring_flutter/LoginScreen.dart';
import 'package:scoring_flutter/ScoringRecognizedScreen.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Poomsae Scoreboard',
      home: LoginPage(),
    );
  }
}
