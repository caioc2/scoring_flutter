import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:scoring_flutter/Widgets.dart';
import 'package:share/share.dart';
import 'package:flutter/scheduler.dart';
import 'package:scoring_flutter/ScoringRecognizedScreen.dart';


class ScoreFreestylePage extends StatefulWidget {

  final ScoreData _data;
  final bool _offline;
  ScoreFreestylePage({ScoreData data, Key key, bool offline = true})   : _data = data, _offline = offline,  super(key: key);
  @override
  ScoreFreestylePageState createState() => ScoreFreestylePageState();

}

class ScoreFreestylePageState extends State<ScoreFreestylePage> {

  final _presentationFSScore = new GlobalKey<PresentationFSState>();
  final _scoreDisplay = new GlobalKey<ScoreRecognizedState>();
  final _timerDisplay = new GlobalKey<TimerState>();
  final _technicalSkillScore = new GlobalKey<TechnicalSkillState>();

  final double _maxPresentation = 4.0;
  final double _maxTechnicalSkill = 6.0;
  double _ts, _pres;

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

  void share() {
    updateScore();
    Share.share(
        "Poomsae score\n" +
            "Total: " + (_ts + _pres).toStringAsFixed(1) + "\n" +
            "Technichal skill: " + _ts.toStringAsFixed(1) + "\n" +
            "Presentation: " + _pres.toStringAsFixed(1)
    );
  }

  void startStop() {
    _timerDisplay.currentState.toggle();
  }

  void reset() {
    _presentationFSScore.currentState.reset();
    _technicalSkillScore.currentState.reset();
    _timerDisplay.currentState.reset();
    updateScore();
  }

  void send() {

  }

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an score board'),
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
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: buildButtons(widget._offline,
                            () {reset();},
                            () {send();},
                            () {startStop();},
                            () {share();}),
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
