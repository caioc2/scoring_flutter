import 'package:flutter/material.dart';
import 'package:scoring_flutter/LoginScreen.dart';
import 'package:scoring_flutter/ScoringRecognizedScreen.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: LoginPage(),
      home: ScorePage(data: new ScoreData(
        number: "7",
        athlete: "Athlete Name",
        origin: "BR",
        category: "Male under 30",
        round: "Cut Off Final",
        poomsae: "Pyongwon",
        poomsae_number: "2",
        judge: "Judge number 2",
      )),
    );
  }
}
