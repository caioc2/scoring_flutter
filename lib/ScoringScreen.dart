import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class ScorePage extends StatefulWidget {
    @override
    _ScorePageState createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: LeftButton(size: 200),
        ),
    );
  }
}

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
    double _textPaddding = _padding * 2.0;
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
                  log("$_count");
                },
                color: Colors.blue,
                padding: EdgeInsets.all(_textPaddding),
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
                log("$_count");
              },
              color: Colors.indigo,
              padding: EdgeInsets.all(_textPaddding * 0.4),
              shape: CircleBorder(
                side: BorderSide(color: Colors.black54, width: 1),
              ),
              child: Text("$_count",
                style: TextStyle(fontSize: _fontSize * 0.4, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}