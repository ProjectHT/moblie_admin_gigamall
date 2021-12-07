import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:moblie_admin_gigamall/model/ItemPerson.dart';
import 'package:moblie_admin_gigamall/screen/person.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../main.dart';
import 'menu.dart';

class ListPersonView extends StatefulWidget {
  ListPersonView({Key? key}) : super(key: key);
  static const routeName = '/ListPersonView';
  @override
  State<StatefulWidget> createState() => ListPersonViewState();
}

class ListPersonViewState extends State<ListPersonView> {
  ModelListPerson? _modellistperson;

  void handleListClientFunction(List<Object> parameters) {
    String tmp = parameters[0] as String;
    if(tmp.isNotEmpty) {
      Map<String, dynamic> buffer = jsonDecode(tmp);
      _modellistperson = ModelListPerson.fromJson(buffer);
      print(_modellistperson!.toJson());
      setState(() {

      });
    }
  }

  Widget _myListView(BuildContext context) {
    if(_modellistperson == null) {
      return Center(
        child: Container(
          child: GestureDetector(
            onTap: (){
              Navigator.popUntil(context, ModalRoute.withName(MenuView.routeName));
            },
            child: Icon(
              Icons.apps,
              color: Colors.green,
              size: MediaQuery.of(context).size.width * .4,
            ),
          ),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: _modellistperson!.persons.length,
        itemBuilder: (context, index) {
          return Card(
            child: InkWell(
              onTap: () {
                print(_modellistperson!.persons[index].id);
                Navigator.pushNamed(context,
                  PersonView.routeName,
                  arguments: _modellistperson!.persons[index],
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage('https://node2.stvg.vn:51002/api/Image/' + _modellistperson!.persons[index].image),
                      backgroundColor: Colors.transparent,
                    ),
                    SizedBox(width: 20,),
                    Column(
                      children: <Widget>[
                        Text(_modellistperson!.persons[index].id),
                        Text(_modellistperson!.persons[index].firstname + " " + _modellistperson!.persons[index].lastname),
                      ],
                    ),
                    SizedBox(width: 20,),
                    Column(
                      children: <Widget>[
                        Text(_modellistperson!.persons[index].position),
                        Text( _modellistperson!.persons[index].group),
                        Text(_modellistperson!.persons[index].area),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    hubConnection.on('ListClient',(arguments) => handleListClientFunction(arguments!));
    if(flag_connection) {
      hubConnection.invoke('ListClient',args: <Object>[

      ]);
    }
  }

  @override
  void deactivate() {
    hubConnection.off('ListClient');
    //widget._timer!.cancel();
    super.deactivate();
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
      body: _myListView(context),
      floatingActionButton: FloatingActionButton(
        //onPressed: _incrementCounter,
        onPressed: (){
          if(flag_connection) {
            hubConnection.invoke('ListClient',args: <Object>[

            ]);
          }
        },
        tooltip: 'Sync',
        child: const Icon(Icons.sync),
      ),
    );
  }
}