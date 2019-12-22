import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:scoring_flutter/Widgets.dart';
import 'dart:developer';

class ScoreData {
  final String number;
  final String athlete;
  final String origin;
  final String judge;
  final String poomsae;
  final String poomsae_number;
  final String round;
  final String category;

  ScoreData({String number = "-1", String athlete = "None", String origin = "None", String judge = "None",
    String poomsae = "None", String round = "None", String category = "None", String poomsae_number}) :
        this.number = number,
        this.athlete = athlete,
        this.origin = origin,
        this.judge = judge,
        this.poomsae = poomsae,
        this.round = round,
        this.category = category,
        this.poomsae_number = poomsae_number;

  @override
  String toString() {
    return "Number: " + number + "\n" +
           "Athlete: " + athlete + "\n" +
           "Origin: " + origin + "\n" +
           "Judge: " + judge + "\n" +
           "Poomsae: " + poomsae_number + " - " + poomsae + "\n" +
           "Round: " + round + "\n" +
           "Category: " + category + "\n";
  }
}

class ScorePage extends StatefulWidget {
  
    final ScoreData _data;
    ScorePage({ScoreData data, Key key})   : _data = data, super(key: key);
    @override
    ScorePageState createState() => ScorePageState();
}

class ScorePageState extends State<ScorePage> {

  final _presentationScore = new GlobalKey<PresentationState>();
  final _majorAccuracy = new GlobalKey<LeftButtonState>();
  final _minorAccuracy = new GlobalKey<RightButtonState>();
  final _scoreDisplay = new GlobalKey<ScoreRecognizedState>();
  final _timerDisplay = new GlobalKey<TimerState>();
  final _accuracyDisplay = new GlobalKey<AccuracyState>();

  double _acc, _pres;

  final double _maxPresentation = 6.0;
  final double _maxAccuracy = 4.0;
  final double _majorDiscount = 0.3;
  final double _minorDiscount = 0.1;
  
  void updateScore() {
    int c1 = _minorAccuracy.currentState.getCount();
    int c2 = _majorAccuracy.currentState.getCount();
    
    double p1 = _presentationScore.currentState.getEnergy();
    double p2 = _presentationScore.currentState.getSpeed();
    double p3 = _presentationScore.currentState.getTempo();

    _pres = math.max(math.min(_maxPresentation, p1+p2+p3), 0);
    _acc = math.max(math.min(_maxAccuracy, _maxAccuracy - (c1 * _minorDiscount + c2 * _majorDiscount)), 0);

    _accuracyDisplay.currentState.setAccuracy(_acc);
    _scoreDisplay.currentState.setAccuracy(_acc);
    _scoreDisplay.currentState.setPresentation(_pres);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.black,
            ),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: CompetitorNumberDisplay(
                      number: widget._data.number,
                    ),
                  ),
                  CategoryDisplay(
                    name: widget._data.category,
                  ),
                  Flexible(
                    child: RoundDisplay(
                      name: widget._data.round,
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: AthleteDisplay(
                      name: widget._data.athlete,
                      origin: widget._data.origin,
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      TimerDisplay(
                        key: _timerDisplay,
                      ),
                      PoomsaeDisplay(
                        name: widget._data.poomsae,
                        number: widget._data.poomsae_number,
                      ),
                    ],
                  ),
                  Flexible(
                    child: ScoreRecognizedDisplay(
                      key: _scoreDisplay,
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: JudgeDisplay(
                      name: widget._data.judge,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: LeftButton(
                      key: _majorAccuracy,
                      onChanged: (){
                        updateScore();
                      },
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      AccuracyDisplay(
                        key: _accuracyDisplay,
                      ),
                      Container(
                        height: 10,
                      ),
                      PresentationDisplay(
                        key: _presentationScore,
                        onChanged: () {
                          updateScore();
                        },
                      ),
                    ],
                  ),
                  Flexible(
                    child: RightButton(
                      key: _minorAccuracy,
                      onChanged: () {
                        updateScore();
                      },
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Container(
                    width: 100,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      border: Border.all(
                        color: Colors.white,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: FlatButton(
                      onPressed: () {
                        //TODO send
                      },
                      child: Text("Send",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}
