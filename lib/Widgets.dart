import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter/material.dart';


class LeftButton extends StatefulWidget {

  final double _size;
  LeftButton({double size = 200}) :  _size = size;

  LeftButtonState createState() => LeftButtonState(_size);
}

class LeftButtonState extends State {

  double _size;
  LeftButtonState(double size) {
    _size = size;
  }

  int _count = 0;

  int getCount() {
    return _count;
  }

  void resetCount() {
    setState(() {
      _count = 0;
    });
  }
  @override
  Widget build(BuildContext context) {
    double _width = _size;
    double _height = _width * 0.75;
    double _circularBorder = _height * 0.5;
    double _padding = _width * 0.025;
    double _textPadding = _padding * 2.0;
    double _fontSize = _width * 0.25;
    double _boxSize = _height - 2.0 * _padding;

    return Container (
      width: _width * 1.4,
      height: _height + 2.0 * _padding,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.indigo,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(_circularBorder + _padding),
          bottomRight: Radius.circular(_circularBorder + _padding),
        ),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: _width,
            height: _height,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(_circularBorder),
                bottomRight: Radius.circular(_circularBorder),
              ),
            ),
            alignment: Alignment.centerRight,
            padding: EdgeInsets.all(_padding),
            child: SizedBox(
              width: _boxSize,
              height: _boxSize,

              child: FlatButton(
                onPressed: () {
                  setState(() {
                    _count++;
                  });
                },
                color: Colors.blue,
                padding: EdgeInsets.all(_textPadding),
                shape: CircleBorder(
                  side: BorderSide(color: Colors.lightBlueAccent, width: 1),
                ),
                child: Text("-0.3",
                  style: TextStyle(fontSize: _fontSize, color: Colors.lightBlueAccent),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Container(
            width: _width * 0.4,
            height: _height,
            padding: EdgeInsets.all(_padding),
            child: FlatButton(
              onPressed: () {
                setState(() {
                  _count = math.max(_count-1, 0);
                });
              },
              color: Colors.indigo,
              padding: EdgeInsets.all(_textPadding * 0.4),
              shape: CircleBorder(
                side: BorderSide(color: Colors.black54, width: 1),
              ),
              child: Text("$_count",
                style: TextStyle(fontSize: _fontSize * 0.8, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RightButton extends StatefulWidget {

  final double _size;
  RightButton({double size = 200}) :  _size = size;

  RightButtonState createState() => RightButtonState(_size);
}

class RightButtonState extends State {

  double _size;
  RightButtonState(double size) {
    _size = size;
  }

  int _count = 0;

  int getCount() {
    return _count;
  }

  void resetCount() {
    setState(() {
      _count = 0;
    });
  }
  @override
  Widget build(BuildContext context) {//Duplicated sizing
    double _width = _size;
    double _height = _width * 0.75;
    double _circularBorder = _height * 0.5;
    double _padding = _width * 0.025;
    double _textPadding = _padding * 2.0;
    double _fontSize = _width * 0.25;
    double _boxSize = _height - 2.0 * _padding;

    return Container (
      width: _width * 1.4,
      height: _height + 2.0 * _padding,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.indigo,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(_circularBorder + _padding),
          bottomLeft: Radius.circular(_circularBorder + _padding),
        ),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: _width * 0.4,
            height: _height,
            padding: EdgeInsets.all(_padding),
            child: FlatButton(
              onPressed: () {
                setState(() {
                  _count = math.max(_count-1, 0);
                });
              },
              color: Colors.indigo,
              padding: EdgeInsets.all(_textPadding * 0.4),
              shape: CircleBorder(
                side: BorderSide(color: Colors.black54, width: 1),
              ),
              child: Text("$_count",
                style: TextStyle(fontSize: _fontSize * 0.8, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
            width: _width,
            height: _height,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(_circularBorder),
                bottomLeft: Radius.circular(_circularBorder),
              ),
            ),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(_padding),
            child: SizedBox(
              width: _boxSize,
              height: _boxSize,

              child: FlatButton(
                onPressed: () {
                  setState(() {
                    _count++;
                  });
                },
                color: Colors.blue,
                padding: EdgeInsets.all(_textPadding),
                shape: CircleBorder(
                  side: BorderSide(color: Colors.lightBlueAccent, width: 1),
                ),
                child: Text("-0.1",
                  style: TextStyle(fontSize: _fontSize, color: Colors.lightBlueAccent),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TimerDisplay extends StatefulWidget {

  TimerState createState() => TimerState();
}

class TimerState extends State {

  final int _maxSeconds = 300;
  int _totalSeconds = 0;

  String _minutes = "0";
  String _seconds = "00";

  void setTime(int seconds) {
    if(seconds < 0)
      seconds = 0;

    if(seconds > 300)
      seconds = 300;

    _seconds = (seconds % 60).toString().padLeft(2,'0');
    _minutes = (seconds / 60).toString();
  }

  Widget build(BuildContext context) {//Duplicated sizing
    return Container (
        width: 200,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.black,
        ),
        padding: EdgeInsets.all(20.0),
        child: Align(
          alignment: Alignment.center,
          child: Text("$_minutes:$_seconds",
            style: TextStyle(fontSize: 60, color: Colors.white),
            //textAlign: TextAlign.center,
          ),
        ),
    );
  }
}

class CategoryDisplay extends StatelessWidget {

  final String _category;
  CategoryDisplay({String name = "None"}) : _category = name;


  Widget build(BuildContext context) {
    return Container (
      width: 200,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.black,
      ),
      padding: EdgeInsets.all(1.0),
      child: Align(
        alignment: Alignment.center,
        child: Text("$_category",
          style: TextStyle(fontSize: 20, color: Colors.white),
          //textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class RoundDisplay extends StatelessWidget {

  final String _name;
  RoundDisplay({String name = "None"}) : _name = name;


  Widget build(BuildContext context) {
    return Container (
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.black,
      ),
      padding: EdgeInsets.only(left: 1.0, right: 30.0, bottom: 1.0, top: 1.0,),
      alignment: Alignment.centerRight,
      child: Align(
        alignment: Alignment.centerRight,
        child: Text("$_name",
          style: TextStyle(fontSize: 20, color: Colors.white),
          textAlign: TextAlign.right,
        ),
      ),
    );
  }
}

class CompetitorNumberDisplay extends StatelessWidget {

  final String _number;
  CompetitorNumberDisplay({String number = "None"}) : _number = number;


  Widget build(BuildContext context) {
    return Container (
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.black,
      ),
      padding: EdgeInsets.only(left: 30.0, right: 1.0, bottom: 1.0, top: 1.0,),
      alignment: Alignment.centerLeft,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text("$_number",
          style: TextStyle(fontSize: 20, color: Colors.white),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }
}


class PoomsaeDisplay extends StatelessWidget {

  final String _name;
  final int _number;
  PoomsaeDisplay({String name = "None", int number = 1}) : _name = name, _number = number;


  Widget build(BuildContext context) {//Duplicated sizing
    return Container (
      width: 200,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.black,
      ),
      padding: EdgeInsets.all(1.0),
      child: Align(
        alignment: Alignment.center,
        child: Text("$_number - $_name",
          style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
          //textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class JudgeDisplay extends StatelessWidget {

  final String _name;
  JudgeDisplay({String name = "None"}) : _name = name;


  Widget build(BuildContext context) {//Duplicated sizing
    return Container (
      width: 200,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.black,
      ),
      padding: EdgeInsets.all(1.0),
      child: Align(
        alignment: Alignment.center,
        child: Text("$_name",
          style: TextStyle(fontSize: 15, color: Colors.blue, fontWeight: FontWeight.bold),
          //textAlign: TextAlign.center,
        ),
      ),
    );
  }
}


class ScoreRecognizedDisplay extends StatefulWidget {

  ScoreRecognizedState createState() => ScoreRecognizedState();
}

class ScoreRecognizedState extends State {

  final double maxAccuracy = 4.0;
  final double maxPresentation = 6.0;

  double _accuracy = 0.0;
  double _presentation = 0.0;
  
  String _acc = "0.0";
  String _pres = "0.0";
  String _total = "0.0";

  void setAccuracy(double value) {
    setState(() {
      _accuracy = math.max(math.min(value, maxAccuracy), 0.0);
      _acc = _accuracy.toStringAsFixed(1);
      _total = (_accuracy + _presentation).toStringAsFixed(1);
    });
  }

  void setPresentation(double value) {
    setState(() {
      _presentation = math.max(math.min(value, maxPresentation), 0.0);
      _pres = _presentation.toStringAsFixed(1);
      _total = (_accuracy + _presentation).toStringAsFixed(1);
    });
  }

  Widget build(BuildContext context) {//Duplicated sizing
    return Container (
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.black,
      ),
      padding: EdgeInsets.all(0.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("$_total",
                style: TextStyle(fontSize: 60, color: Colors.yellow),

              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text("$_acc",
                style: TextStyle(fontSize: 40, color: Colors.orange),

              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text("$_pres",
                style: TextStyle(fontSize: 40, color: Colors.orangeAccent),

              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AthleteDisplay extends StatelessWidget {

  final String _name;
  final String _origin;
  final String _flag;
  AthleteDisplay({String name = "None", String origin = "None", String flag = "br"}) : _name = name, _origin = origin, _flag = flag;


  Widget build(BuildContext context) {
    return Container (
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.black,
      ),
      padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0, top: 20.0,),
      alignment: Alignment.centerRight,
      child: Column(
        children: <Widget>[
          Container(
            height: 30,
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Icon(
                  IconData(0xe153, fontFamily: 'MaterialIcons'),
                  color: Colors.white,
                  size: 20.0,
                ),
                Text("$_origin",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
          Container(
            height: 30,
            alignment: Alignment.centerRight,
            child: Text("$_name",
              style: TextStyle(fontSize: 20, color: Colors.white),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class AccuracyDisplay extends StatefulWidget {

  AccuracyState createState() => AccuracyState();
}

class AccuracyState extends State {

  final double maxAccuracy = 4.0;
  double _accuracy = 0.0;
  String _acc = "0.0";

  void setAccuracy(double value) {
    setState(() {
      _accuracy = math.max(math.min(value, maxAccuracy), 0.0);
      _acc = _accuracy.toStringAsFixed(1);
    });
  }

  Widget build(BuildContext context) {//Duplicated sizing
    return Container (
      height: 50,
      width: 300,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.black,
      ),
      child: Row(
        children: <Widget>[
        Container (
          height: 50,
          width: 230,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            gradient: LinearGradient(
              colors: <Color>[
                Colors.black,
                Colors.lightBlue,
                Colors.black,
              ],
            ),
          ),
          padding: EdgeInsets.only(
            top: 2.0,
            bottom: 2.0,
          ),
          child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.black,
              ),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text("Accuracy",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
          ),
          Container(
            height: 50,
            width: 70,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.redAccent,
              border: Border.all(
                color: Colors.redAccent,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "$_acc",
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}

class PresentationDisplay extends StatefulWidget {

  PresentationState createState() => PresentationState();
}

class PresentationState extends State {

  final double maxItem = 2.0;
  double _speed = 0.0;
  double _tempo = 0.0;
  double _energy = 0.0;

  void setSpeed(double value) {
    setState(() {
      _speed = math.max(math.min(value, maxItem), 0.0);
    });
  }

  void setTempo(double value) {
    setState(() {
      _tempo = math.max(math.min(value, maxItem), 0.0);
    });
  }

  void setEnergy(double value) {
    setState(() {
      _energy = math.max(math.min(value, maxItem), 0.0);
    });
  }

  double getSpeed(double value) {
    return _speed;
  }

  double getTempo(double value) {
    return _tempo;
  }

  double getEnergy(double value) {
    return _energy;
  }

  Widget build(BuildContext context) {//Duplicated sizing
    return Container (
      height: 180,
      width: 300,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.black,
      ),
      child:Container (
            height: 180,
            width: 300,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              gradient: LinearGradient(
                colors: <Color>[
                  Colors.black,
                  Colors.lightBlue,
                  Colors.black,
                ],
              ),
            ),
            padding: EdgeInsets.only(
              top: 2.0,
              bottom: 2.0,
            ),
            child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.black,
                ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 300,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.black,
                    ),
                    child: Row(
                      children: <Widget>[
                        Container (
                          height: 50,
                          width: 230,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.black,
                          ),
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(
                            left: 10.0,
                            right: 10.0,
                          ),
                          child: Text("Speed & Power",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 70,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.redAccent,
                            border: Border.all(
                              color: Colors.redAccent,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<double>(
                              value: _speed,
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 0,
                              elevation: 16,
                              onChanged: (double newValue) {
                                setState(() {
                                  _speed = newValue;
                                });
                              },
                              items: <double>[0.0 , 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0,
                                            1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2.0]
                                            .map<DropdownMenuItem<double>>((double value) {
                                              return DropdownMenuItem<double>(
                                                value: value,
                                                child: Text(value.toStringAsFixed(1), style: TextStyle(fontSize: 30, color: Colors.black38,),
                                                ),
                                              );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 300,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.black,
                    ),
                    child: Row(
                      children: <Widget>[
                        Container (
                          height: 50,
                          width: 230,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.black,
                          ),
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(
                            left: 10.0,
                            right: 10.0,
                          ),
                          child: Text("Rythm & Tempo",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 70,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.redAccent,
                            border: Border.all(
                              color: Colors.redAccent,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<double>(
                              value: _tempo,
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 0,
                              elevation: 16,
                              onChanged: (double newValue) {
                                setState(() {
                                  _tempo = newValue;
                                });
                              },
                              items: <double>[0.0 , 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0,
                                1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2.0]
                                  .map<DropdownMenuItem<double>>((double value) {
                                return DropdownMenuItem<double>(
                                  value: value,
                                  child: Text(value.toStringAsFixed(1), style: TextStyle(fontSize: 30, color: Colors.black38,),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 300,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.black,
                    ),
                    child: Row(
                      children: <Widget>[
                        Container (
                          height: 50,
                          width: 230,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.black,
                          ),
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(
                            left: 10.0,
                            right: 10.0,
                          ),
                          child: Text("Expression of Energy",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 70,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.redAccent,
                            border: Border.all(
                              color: Colors.redAccent,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<double>(
                              value: _energy,
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 0,
                              elevation: 16,
                              onChanged: (double newValue) {
                                setState(() {
                                  _energy = newValue;
                                });
                              },
                              items: <double>[0.0 , 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0,
                                1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2.0]
                                  .map<DropdownMenuItem<double>>((double value) {
                                return DropdownMenuItem<double>(
                                  value: value,
                                  child: Text(value.toStringAsFixed(1), style: TextStyle(fontSize: 30, color: Colors.black38,),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}