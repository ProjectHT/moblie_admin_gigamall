import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:moblie_admin_gigamall/model/AddPersonArguments.dart';
import 'package:moblie_admin_gigamall/screen/resultaddperson.dart';

import '../main.dart';

class ReadCardView extends StatefulWidget {
  Timer? _timer;
  AddPersonArguments? agrs;
  ReadCardView({Key? key}) : super(key: key);

  static const routeName = '/ReadCardView';
  @override
  State<StatefulWidget> createState() => ReadCardViewState();
}

class ReadCardViewState extends State<ReadCardView> {
  int _waittime = 0;
  String _card = '';
  bool flag_read = false;

  void callbackTimer(Timer timer) {
    if(flag_refresh_msg_ble) {
      _card = msg_ble;
      flag_refresh_msg_ble = false;

      if((_card[0] == '<')&&(_card[_card.length-3] == '>')){
        print(_card);
        if(flag_read) {
          if(widget.agrs != null) {
            if(flag_connection) {
              print(_card);
              flag_read = false;
              hubConnection.invoke('CreateClient', args: <Object>[
                widget.agrs!.getID(),
                _card,
                widget.agrs!.getFirstName(),
                widget.agrs!.getLastName(),
                widget.agrs!.getGroup(),
                widget.agrs!.getArea(),
                widget.agrs!.getPosition(),
                base64Encode(widget.agrs!.getImage().readAsBytesSync()),
              ]);
            }
          }
        }
      }
    }
    setState(() {
      _waittime+=1;
    });
  }

  void handleCreateClientFunction(List<Object> parameters) {
    String tmp = parameters[0] as String;
    print('SignalR create client : ' + parameters.toString());
    if(tmp.compareTo('ok') == 0) {
      flag_connection = true;
      Navigator.pushReplacementNamed(context, ResultAddPersonView.routeName,arguments: null);
    } else {
      flag_read = true;
      flag_refresh_msg_ble = false;
    }
  }

  @override
  void initState() {
    super.initState();
    flag_refresh_msg_ble = false;
    flag_read = true;
    hubConnection.on('CreateClient',(arguments) => handleCreateClientFunction(arguments!));
    widget._timer = Timer.periodic(Duration(seconds: 1), callbackTimer);
  }

  @override
  void dispose() {
    print("Cancel Timer!");


    super.dispose();
  }

  @override
  void deactivate() {
    hubConnection.off('CreateClient');
    widget._timer!.cancel();
    super.deactivate();
  }


  @override
  Widget build(BuildContext context) {
    widget.agrs = ModalRoute.of(context)!.settings.arguments as AddPersonArguments;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(26.0),
        child: AppBar (
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Read card'),
              SizedBox(width: 20),
              flag_ble ? StreamBuilder<BluetoothDeviceState>(
                stream: connectedDevice!.state,
                initialData: BluetoothDeviceState.connecting,
                builder: (c, snapshot) {
                  VoidCallback? onPressed;
                  switch (snapshot.data) {
                    case BluetoothDeviceState.connected:
                      onPressed = () => print('DISCONNECT');
                      on_off_ble = true;
                      break;
                    case BluetoothDeviceState.disconnected:
                      onPressed = () => print('CONNECT');
                      on_off_ble = false;
                      break;
                    default:
                      onPressed = () => print('UNKNOWN');
                      on_off_ble = false;
                      break;
                  }
                  return Icon(
                    Icons.bluetooth_connected,
                    color: on_off_ble ? Colors.yellow : Colors.grey,
                  );
                },
              ) : Icon(
                Icons.bluetooth_connected,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Container(
          child: Icon(
            Icons.credit_card,
            color: (_waittime % 2) == 0 ? Colors.green : Colors.amber,
            size: MediaQuery.of(context).size.width * .4,
          ),
        ),
      ),
    );
  }
}