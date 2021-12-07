import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moblie_admin_gigamall/screen/menu.dart';
import 'package:signalr_netcore/hub_connection.dart';

import '../main.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);
  static const routeName = '/LoginView';
  @override
  State<StatefulWidget> createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final myUsernameController = TextEditingController();
  final myPasswordController = TextEditingController();

  void handleMLoginClientFunction(List<Object> parameters) {
    String tmp_mac = parameters[0] as String;
    String tmp_service_uuid = parameters[1] as String;
    String tmp_characteristic_uuid = parameters[2] as String;
    print('SignalR login : ' + parameters.toString());
    if(tmp_mac.isNotEmpty) {
      flag_connection = true;
      Navigator.pushReplacementNamed(context, MenuView.routeName,arguments: null);
    } else {
      print('Error login');
    }
  }

  @override
  void initState() {
    super.initState();
    hubConnection.start();
    hubConnection.on('Login', (arguments) => handleMLoginClientFunction(arguments!));
  }

  @override
  void dispose() {
    myUsernameController.dispose();
    myPasswordController.dispose();
    hubConnection.off('Login');
    hubConnection.on('Login', (arguments) => handleLoginFunction(arguments!));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usernameField = TextField(
      obscureText: false,
      style: style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Username",
        border:
        OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
      controller: myUsernameController,
    );
    final passwordField = TextField(
      obscureText: true,
      style: style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Password",
        border:
        OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
      controller: myPasswordController,
    );
    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.green,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          if(hubConnection.state == HubConnectionState.Connected) {
            username = myUsernameController.text;
            password = myPasswordController.text;
            // print(username);
            // print(password);
            hubConnection.invoke('Login',args: <Object>[
                username,
                password,
              ],
            );
          }
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 150.0,
                  child: Image.network('https://saca.com.vn/vnt_upload/partner/stvg-logo-1.png',
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 15.0),
                usernameField,
                SizedBox(height: 15.0),
                passwordField,
                SizedBox(
                  height: 25.0,
                ),
                loginButon,
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}