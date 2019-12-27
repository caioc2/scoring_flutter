import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:io';
import 'package:web_socket_channel/status.dart' as status;


class WebSocketsController {

  final String _address;
  static String _port = "5050";
  static int _timeOut = 1000;
  final int _pingDuration = 200;//milliseconds

  var _m;
  String _token = "";
  ObserverList<Function> _listeners = new ObserverList<Function>();

  WebSocketsController(String address) : _address = "ws://" + address + ":" + _port;

  addListener(Function callback){
    _listeners.add(callback);
  }
  removeListener(Function callback){
    _listeners.remove(callback);
  }
  
  ///
  /// The WebSocket "open" channel
  ///
  IOWebSocketChannel _channel;
  WebSocket socket;

  ///
  /// Is the connection established?
  ///
  bool _isOn = false;
  /// ----------------------------------------------------------
  /// Initialization the WebSockets connection with the server
  /// ----------------------------------------------------------
  Future<bool> connect () async {
    reset();

    try {

      socket = await WebSocket.connect(_address).timeout(new Duration(milliseconds: _timeOut));
      _channel = IOWebSocketChannel(socket);
      _channel.stream.listen(_onReceptionOfMessageFromServer,
        onError: (e) { log("Failed"); },
        onDone:  () { log("Done"); },
      );
      return true;
    }on Exception catch(e){
      log(e.toString());
    }
    return false;
  }

  /// ----------------------------------------------------------
  /// Closes the WebSocket communication
  /// ----------------------------------------------------------
  void reset(){
    if (_channel != null){
      if (_channel.sink != null){
        _channel.sink.close();
        _isOn = false;
      }
    }
  }

  /// ---------------------------------------------------------
  /// Sends a message to the server
  /// ---------------------------------------------------------
  void send(String message){
    if (_channel != null){
      if (_channel.sink != null && _isOn){
        _channel.sink.add(message);
        return;
      }
    }
    _isOn = false;
  }

  /// ---------------------------------------------------------
  /// Adds a callback to be invoked in case of incoming
  /// notification
  /// ---------------------------------------------------------

  /// ----------------------------------------------------------
  /// Callback which is invoked each time that we are receiving
  /// a message from the server
  /// ----------------------------------------------------------
  _onReceptionOfMessageFromServer(message){
    _isOn = true;
    _m = jsonDecode(message);
    _listeners.forEach((Function callback){
      callback(_m);
    });
  }

  void close({int reason = status.normalClosure}) {
    if(_channel != null && _channel.sink != null) {
      _channel.sink.close(reason);
    }
    if(socket != null) {
      socket.close(reason);
    }
    _isOn = false;
  }

  void dispose() {
    close();
  }
}

enum SocketAction {Connect, Disconnect, AthleteData, PoomsaeStart, PoomsaeEnd, SendScore, Unknow}

SocketAction stringToEnumAction(String s) {
  List<SocketAction> act1 = SocketAction.values;
  List<String> act2 = (SocketAction.values).map((act) => act.toString());

  int idx = act2.indexOf(s);
  if(idx >= 0) {
    return act1[idx];
  }
  return SocketAction.Unknow;
}

class SocketMessage {

  static String EncodeLogin(String login) {
    return "{login:  $login, action: " + SocketAction.Connect.toString() + "}";
  }
}

