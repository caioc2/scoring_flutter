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

  var _m;
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

  void reset(){
    if (_channel != null){
      if (_channel.sink != null){
        _channel.sink.close();
        _isOn = false;
      }
    }
  }

  void send(String message){
    if (_channel != null){
      if (_channel.sink != null && _isOn){
        _channel.sink.add(message);
        return;
      }
    }
    _isOn = false;
  }

  Future<RequestState> sendAndWait(Map data, {VoidCallback onTimeout}) async {

    RequestState result = RequestState.Denied;
    if(validateFields(data)) {
      Wait w = new Wait(action: data['action']);
      addListener(w.listener);
      send(json.encode(data).toString());
      result = await w.checkState();
      removeListener(w.listener);
    }else {
      throw new Exception("Unsuported data or action. Action: " + data.toString());
    }
    return result;
  }

  bool validateFields(Map data) {
    if(data.containsKey('action')) {
      switch(stringToEnumAction(data['action'])) {
        case SocketAction.Connect:
          if(data.length == 2 && data.containsKey('login')) return true;

          return false;
        case SocketAction.SendScore:
          if(data.length == 3 && data.containsKey('accuracy') && data.containsKey('presentation')) return true;

          return false;
        default:
          return false;
      }
    }
    return false;
  }


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

class Wait {
  bool _rec = false;
  final String _act;

  Wait({@required String action}) : _act = action;

  void listener(msg) {
    if(msg['action'] == _act) {
       _rec =  true;
    }
  }

  Future<RequestState> _checkState() {
    return new Future.delayed(Duration(milliseconds: 100), () {
      if(!_rec) {
        return _checkState();
      } else {
        return RequestState.Succeed;
      }
    });
  }

  Future<RequestState> checkState({int timeout = 2000}) {
    return _checkState().timeout(Duration(milliseconds: timeout), onTimeout: () {
      return RequestState.Timeout;
    });
  }
}

enum RequestState {Succeed, Denied, Timeout}


enum SocketAction {Connect, Disconnect, AthleteData, PoomsaeStart, PoomsaeEnd, SendScore, Unknow}

SocketAction stringToEnumAction(String s) {
  final List<SocketAction> act1 = SocketAction.values;
  final List<String> act2 = (SocketAction.values).map((act) => act.toString()).toList();

  int idx = act2.indexOf(s);
  if(idx >= 0) {
    return act1[idx];
  }
  return SocketAction.Unknow;
}

