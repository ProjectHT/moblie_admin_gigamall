import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:moblie_admin_gigamall/model/ItemPerson.dart';
import 'package:moblie_admin_gigamall/screen/person.dart';

import '../main.dart';

class ReadInfoCardView extends StatefulWidget {
  Timer? _timer;

  ReadInfoCardView({Key? key}) : super(key: key);

  static const routeName = '/ReadInfoCardView';
  @override
  State<StatefulWidget> createState() => ReadInfoCardViewState();
}

class ReadInfoCardViewState extends State<ReadInfoCardView> {
  int _waittime = 0;
  String _card = '';
  bool flag_read = false;

  void callbackTimer(Timer timer) {
    if(flag_refresh_msg_ble) {
      _card = msg_ble;
      flag_refresh_msg_ble = false;
      if((_card[0] == '<')&&(_card[_card.length-3] == '>')){
        if(flag_read) {
          flag_read = false;
          hubConnection.invoke('ReadCodeClient', args: <Object>[
            _card,
          ]);
        }
      }
    } else {
      setState(() {
        _waittime+=1;
      });
    }
  }

  void handleReadCodeClientFunction(List<Object> parameters) {
    String tmp = parameters[0] as String;
    print(tmp);
    if(tmp.isEmpty) {
      flag_read= true;
      flag_refresh_msg_ble = false;
    } else if(tmp.compareTo('fail-user') == 0) {
        flag_read= true;
        flag_refresh_msg_ble = false;
    } else {
      Map<String, dynamic> buffer = jsonDecode(tmp);
      ModelPerson _modelperson = ModelPerson.fromJson(buffer);
      Navigator.pushReplacementNamed(context,
        PersonView.routeName,
        arguments: _modelperson,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    flag_refresh_msg_ble = false;
    flag_read = true;
    hubConnection.on('ReadCodeClient',(arguments) => handleReadCodeClientFunction(arguments!));
    widget._timer = Timer.periodic(Duration(seconds: 1), callbackTimer);
  }

  @override
  void deactivate() {
    print("Cancel Timer!");
    hubConnection.off('ReadCodeClient');
    widget._timer!.cancel();
    super.deactivate();
  }
  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    color: on_off_ble ? Colors.red : Colors.grey,
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