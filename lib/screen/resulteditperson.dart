import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import '../main.dart';
import 'menu.dart';

class ResultEditPersonView extends StatefulWidget {
  ResultEditPersonView({Key? key}) : super(key: key);
  static const routeName = '/ResultEditPersonView';
  @override
  State<StatefulWidget> createState() => ResultEditPersonViewState();
}

class ResultEditPersonViewState extends State<ResultEditPersonView> {
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
              Text('Edid person'),
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
          child: GestureDetector(
            onTap: (){
              Navigator.popUntil(context, ModalRoute.withName(MenuView.routeName));
            },
            child: Icon(
              Icons.how_to_reg,
              color: Colors.green,
              size: MediaQuery.of(context).size.width * .4,
            ),
          ),
        ),
      ),
    );
  }
}