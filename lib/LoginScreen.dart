import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  final _login_form = GlobalKey<FormState>();

  String _login;
  String _ip_address;

  final loginController = TextEditingController();
  bool loginListenerState = false;
  final ipAddressController = TextEditingController();
  bool ipAddressListenerState = false;

  @override
  void initState() {
    super.initState();

   loginController.addListener(() {
      if(loginController.text != _login) {

        var text = replaceInvalidCharLogin(loginController.text);
        _login = text;
        var selection = new TextSelection.fromPosition(
                new TextPosition(offset: text.length));

        loginController.value = loginController.value.copyWith(text: text, selection: selection);
      }
   });
   ipAddressController.addListener(() {
     if(ipAddressController.text != _ip_address) {

       var text = replaceInvalidCharIPAddress(ipAddressController.text);
       _ip_address = text;
       var selection = new TextSelection.fromPosition(
           new TextPosition(offset: text.length));

       ipAddressController.value = ipAddressController.value.copyWith(text: text, selection: selection);
     }
   });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    loginController.dispose();
    ipAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Login"),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Form(//Column(
          key: _login_form,
          child: Column(
            children: <Widget>[
            Text(
              'Authentication Information',
              style: TextStyle(fontSize: 20),
            ),
            TextFormField(
                controller: loginController,
                keyboardType: TextInputType.text,
                onSaved: (String v) {_login = v;},
                decoration: InputDecoration(labelText: "Login")),
            TextFormField(
                controller: ipAddressController,
                keyboardType: TextInputType.number,
                onSaved: (String v) {_ip_address = v;},
                decoration: InputDecoration(labelText: "IP Address"),
                validator: validateIPAddress,
                //initialValue: "192.168.0.1",
                ),
            RaisedButton(child: Text("LOGIN"), onPressed: () {
                // Validate returns true if the form is valid, or false
                // otherwise.
                if (_login_form.currentState.validate()) {
                  log("VAlid");
                }
            }),
          ],
        ),
        ),
      ),
    );
  }
}

String validateIPAddress(String value) {
  log(value);
  Pattern ip = r'^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$';
  RegExp regex = new RegExp(ip);
  log("validating");
  if (!regex.hasMatch(value) || !checkIpNumbers(value)) {
    log("invalid");
    return 'Enter a valid IP Address';
  } else {
    return null;
  }
}

bool checkIpNumbers(String value) {
  List<String> split = value.split('.');

  if(split.length != 4)
    return false;
  try {
    for (int i = 0; i < split.length; ++i) {
      int n = int.parse(split[i]);
      if(n < 0 || n > 255) {
        return false;
      }
    }
  } on Exception {
    return false;
  }
  return true;
}


String validateLogin(String value){
  Pattern user = r'^[a-z0-9]{4,16}$';
  RegExp regex = new RegExp(user);
  if (!regex.hasMatch(value)) {
    return 'Enter a valid user login';
  } else {
    return null;
  }
}

String replaceInvalidCharLogin(String value) {
  Pattern invalid = r'[^a-z0-9]';
  value = value.toLowerCase();
  value = value.replaceAll(RegExp(invalid), '');
  value = value.substring(0, math.min(16, value.length));
  return value;
}

String replaceInvalidCharIPAddress(String value) {
  Pattern invalid = r'^\.|[^0-9\.]|(?<=\.)[\.]+';
  value = value.replaceAll(RegExp(invalid), '');

  int dotCount = 0;
  int lastDot = -1;
  int maxSize;
  for(int i = 0; i < value.length; ++i) {
    if(value[i] == '.') {
      dotCount++;
      lastDot = i;
    }
    if(i-lastDot > 3 && dotCount < 3) {
      value = value.substring(0,i) + '.' + value.substring(i);
      lastDot = i;
      dotCount++;
      i++;
    }
  }
  maxSize = (3-dotCount)*4 + 3 + lastDot + 1;
  value = value.substring(0, math.min(maxSize, value.length));
  return value;
}
