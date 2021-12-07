import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:moblie_admin_gigamall/screen/readinfocard.dart';

import '../main.dart';
import 'addperson.dart';
import 'listperson.dart';

class MenuView extends StatefulWidget {
  MenuView({Key? key}) : super(key: key);
  static const routeName = '/MenuView';
  @override
  State<StatefulWidget> createState() => MenuViewState();
}

class MenuViewState extends State<MenuView> {
  void initBLE() {
    if(flutterBlue == null) {
      print('Init BLE');
      flag_ble = false;
      flutterBlue = FlutterBlue.instance;
      FlutterBlue _flutterBlue = flutterBlue!;
      _flutterBlue.startScan(timeout: const Duration(seconds: 120));
      var subscription = _flutterBlue.scanResults.listen((results) async {
        for (ScanResult r in results) {
          if(!devicesList.contains(r.device)) {
            devicesList.add(r.device);
            print(r.device.id.toString());
            if(r.device.id.toString().compareTo(macDevice) == 0) {
              try {
                await r.device.connect(timeout: const Duration(seconds: 10), autoConnect: true);
                connectedDevice = r.device;
                _flutterBlue.stopScan();
                List<BluetoothService> services = await connectedDevice!.discoverServices();
                services.forEach((service) async {
                  if(service.uuid.toString().compareTo(service_uuid) == 0) {
                    for(BluetoothCharacteristic c in service.characteristics) {
                      if(c.uuid.toString().compareTo(characteristic_uuid) == 0) {
                        flag_ble = await c.setNotifyValue(true);
                        c.value.listen((value) {
                          bleHadData(value);
                        });
                        setState(() {

                        });
                      }
                    }
                  }
                });
              } catch (e) {
              }
            }
          }
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initBLE();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(26.0),
        child: AppBar (
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Menu"),
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
        child: Column (
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: (){
                Navigator.pushNamed(context,
                  AddPersonView.routeName,
                  // arguments: mArguments,
                );
              },
              child: Column (
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.queue,
                    color: Colors.green,
                    size: MediaQuery.of(context).size.width * .2,
                  ),
                  Text('Add person',style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: (){
                Navigator.pushNamed(context,
                  ListPersonView.routeName,
                  // arguments: mArguments,
                );
              },
              child: Column (
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.ballot,
                    color: Colors.green,
                    size: MediaQuery.of(context).size.width * .2,
                  ),
                  Text('List person',style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: (){
                Navigator.pushNamed(context,
                  ReadInfoCardView.routeName,
                );
              },
              child: Column (
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.credit_card,
                    color: Colors.green,
                    size: MediaQuery.of(context).size.width * .2,
                  ),
                  Text('Read card',style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: (){

              },
              child: Column (
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.table_view,
                    color: Colors.green,
                    size: MediaQuery.of(context).size.width * .2,
                  ),
                  Text('List person',style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
            ),
            // flag_ble ? StreamBuilder<BluetoothDeviceState>(
            //   stream: connectedDevice!.state,
            //   initialData: BluetoothDeviceState.connecting,
            //   builder: (c, snapshot) {
            //     VoidCallback? onPressed;
            //     switch (snapshot.data) {
            //       case BluetoothDeviceState.connected:
            //         onPressed = () => print('DISCONNECT');
            //         on_off_ble = true;
            //         break;
            //       case BluetoothDeviceState.disconnected:
            //         onPressed = () => print('CONNECT');
            //         on_off_ble = false;
            //         break;
            //       default:
            //         onPressed = () => print('UNKNOWN');
            //         on_off_ble = false;
            //         break;
            //     }
            //     // return FlatButton(
            //     //   onPressed: onPressed,
            //     //   child: Text(
            //     //     text,
            //     //     style: Theme.of(context)
            //     //         .primaryTextTheme
            //     //         .button
            //     //         ?.copyWith(color: Colors.white),
            //     //   )
            //     // );
            //     return Icon(
            //       Icons.bluetooth_connected,
            //       color: on_off_ble ? Colors.green : Colors.grey,
            //     );
            //   },
            // ) : SizedBox(height: 10),
            // // FlatButton(
            // //   onPressed: null,
            // //   child: Text(
            // //   'Test',
            // //   style: Theme.of(context)
            // //       .primaryTextTheme
            // //       .button
            // //       ?.copyWith(color: Colors.white),
            // //   )
            // // ),
          ],
        ),
      ),
    );
  }
}