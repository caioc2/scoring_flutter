import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:scoring_flutter/Widgets.dart';
import 'dart:developer';
import 'package:share/share.dart';
import 'package:flutter/scheduler.dart';

import 'WebSocketController.dart';
import 'WebSocketController.dart';


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
    String poomsae = "None", String round = "None", String category = "None", String poomsae_number = "None"}) :
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

class ScoreRecognizedPage extends StatefulWidget {

    final ScoreData _data;
    final bool _offline;
    final bool _enabled;
    final WebSocketsController _ws;

    bool _recognized;
    ScoreRecognizedPage({WebSocketsController ws, ScoreData data, Key key,bool recognized = true, bool enabled = true, bool offline = true}) :
          _ws = ws, _data = data, _recognized = recognized, _enabled = enabled, _offline = offline,  super(key: key);
    @override
    ScoreRecognizedPageState createState() => ScoreRecognizedPageState(_data);

}

enum ScoreBoardState {WaitingData, Ready, Running, Completed}

class ScoreRecognizedPageState extends State<ScoreRecognizedPage> {

  final _presentationScore = new GlobalKey<PresentationState>();
  final _majorAccuracy = new GlobalKey<LeftButtonState>();
  final _minorAccuracy = new GlobalKey<RightButtonState>();
  final _scoreDisplay = new GlobalKey<ScoreRecognizedState>();
  final _timerDisplay = new GlobalKey<TimerState>();
  final _accuracyDisplay = new GlobalKey<AccuracyState>();
  final _presentationFSScore = new GlobalKey<PresentationFSState>();
  final _technicalSkillScore = new GlobalKey<TechnicalSkillState>();

  double _acc, _pres, _ts;

  final double _maxPresentation = 6.0;
  final double _maxAccuracy = 4.0;
  final double _majorDiscount = 0.3;
  final double _minorDiscount = 0.1;
  final double _maxPresentationFS = 4.0;
  final double _maxTechnicalSkill = 6.0;

  ScoreData _data;

  ScoreRecognizedPageState(ScoreData data) : _data = data;


  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    SchedulerBinding.instance.addPostFrameCallback((_) => updateScore());
  }

  void updateScore() {
    if(widget._recognized) {
      updateScoreR();
    } else {
      updateScoreFS();
    }
  }

  void share() {
    if(widget._recognized) {
      shareR();
    } else {
      shareFS();
    }
  }

  void reset() {
    if(widget._recognized) {
      resetR();
    } else {
      resetFS();
    }
  }

  void send() {
    if(widget._recognized) {
      sendR();
    } else {
      sendFS();
    }
  }

  void setData(ScoreData data, {bool reset = false}) {
    if(reset) {
      this.reset();
    }
    setState(() {
      _data = data;
    });
  }

  void startStop() {
    _timerDisplay.currentState.toggle();
  }

///////////////////////Recognized//////////////////////////
  
  void updateScoreR() {
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

  void shareR() {
    updateScore();
    Share.share(
      "Poomsae score\n" +
      "Total: " + (_acc + _pres).toStringAsFixed(1) + "\n" +
      "Accuracy: " + _acc.toStringAsFixed(1) + "\n" +
      "Presentation: " + _pres.toStringAsFixed(1)
    );
  }



  void resetR() {
    _minorAccuracy.currentState.resetCount();
    _majorAccuracy.currentState.resetCount();
    _presentationScore.currentState.reset();
    _timerDisplay.currentState.reset();
    updateScore();
  }

  void sendR() {

  }

///////////////////////FreeStyle//////////////////////////

  void updateScoreFS() {
    _ts = _technicalSkillScore.currentState.getAcrobatic() +
        _technicalSkillScore.currentState.getBasic() +
        _technicalSkillScore.currentState.getHeight() +
        _technicalSkillScore.currentState.getKicks() +
        _technicalSkillScore.currentState.getSparring() +
        _technicalSkillScore.currentState.getSpins();
    _ts = math.max(math.min(_ts, _maxTechnicalSkill), 0.0);

    _pres = _presentationFSScore.currentState.getEnergy() +
        _presentationFSScore.currentState.getCoreography() +
        _presentationFSScore.currentState.getCreativity() +
        _presentationFSScore.currentState.getHarmony();

    _pres = math.max(math.min(_pres, _maxPresentation), 0.0);

    _scoreDisplay.currentState.setPresentation(_pres);
    _scoreDisplay.currentState.setAccuracy(_ts);
  }

  void shareFS() {
    updateScore();
    Share.share(
        "Poomsae score\n" +
            "Total: " + (_ts + _pres).toStringAsFixed(1) + "\n" +
            "Technichal skill: " + _ts.toStringAsFixed(1) + "\n" +
            "Presentation: " + _pres.toStringAsFixed(1)
    );
  }


  void resetFS() {
    _presentationFSScore.currentState.reset();
    _technicalSkillScore.currentState.reset();
    _timerDisplay.currentState.reset();
    updateScore();
  }

  void sendFS() {

  }

  ///////////////////////OnPop//////////////////////////

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit the score board'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.landscapeRight,
                DeviceOrientation.landscapeLeft,
                DeviceOrientation.portraitUp,
                DeviceOrientation.portraitDown,
              ]);
              },
            child: new Text('Yes'),
          ),
        ],
      ),
    ) ?? false;
  }

  Widget _buildScoreButtons() {
    if(widget._recognized) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: LeftButton(
              key: _majorAccuracy,
              onChanged: () {
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
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TechnicalSkillDisplay(
            key: _technicalSkillScore,
            onChanged: () {
              updateScore();
            },
          ),
          PresentationFSDisplay(
            key: _presentationFSScore,
            onChanged: ()
            {
              updateScore();
            },
          )
        ],
      );
    }
  }


  ///////////////////////Widget build//////////////////////////
  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
                      number: widget._enabled ? _data.number : "",
                    ),
                  ),
                  CategoryDisplay(
                    name: widget._enabled ? _data.category : "Category",
                  ),
                  Flexible(
                    child: RoundDisplay(
                      name: widget._enabled ? _data.round : "",
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: AthleteDisplay(
                      name: widget._enabled ? _data.athlete : "Waiting for data...",
                      origin: widget._enabled ? _data.origin : "",
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      TimerDisplay(
                        key: _timerDisplay,
                      ),
                      if(widget._recognized )
                        PoomsaeDisplay(
                        name: widget._enabled ? _data.poomsae : "Poomsae",
                        number: widget._enabled ? _data.poomsae_number : "#",
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
                      name: widget._enabled ? _data.judge : "Judge number #",
                    ),
                  ),
                ],
              ),
              _buildScoreButtons(),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: buildButtons(widget._offline,
                            reset,
                            send,
                            startStop,
                            share,)
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
