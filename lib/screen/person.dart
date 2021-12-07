import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:moblie_admin_gigamall/model/ItemPerson.dart';
import 'package:moblie_admin_gigamall/screen/resultdeleteperson.dart';
import 'package:moblie_admin_gigamall/screen/resulteditperson.dart';

import '../main.dart';
import 'menu.dart';

class PersonView extends StatefulWidget {
  PersonView({Key? key}) : super(key: key);
  static const routeName = '/PersonView';
  ModelPerson? agrs;
  @override
  State<StatefulWidget> createState() => PersonViewState();
}

class PersonViewState extends State<PersonView> {
  String _id = '';
  String _code = '';
  String _firstname = '';
  String _lastname = '';
  String _group = '';
  String _area = '';
  String _position = '';
  String _image = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void handleEditClientFunction(List<Object> parameters) {
    String tmp = parameters[0] as String;
    print(tmp);
    if(tmp.compareTo('ok') == 0) {
      //hubConnection.off('EditClient');
      Navigator.pushNamed(context, ResultEditPersonView.routeName);
    //  Navigator.popUntil(context, ModalRoute.withName(MenuView.routeName));
    } else {
      showDialog<String>(builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Edit error'),
            content: const Text('Edit info person fail!'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          );
        },
        context: context
      );
    }
  }

  void handleDeleteClientFunction(List<Object> parameters) {
    String tmp = parameters[0] as String;
    print(tmp);
    if(tmp.compareTo('ok') == 0) {
      //Navigator.pushNamed(context, ResultDeletePersonView.routeName);
      Navigator.popUntil(context, ModalRoute.withName(MenuView.routeName));
    } else {
      showDialog<String>(builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit delete'),
          content: const Text('Delete person fail!'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        );
      },
          context: context
      );
    }
  }

  @override
  void initState() {
    super.initState();
    hubConnection.on('EditClient', (arguments) => handleEditClientFunction(arguments!));
    hubConnection.on('DeleteClient', (arguments) => handleDeleteClientFunction(arguments!));
  }

  @override
  void deactivate() {
    hubConnection.off('EditClient');
    hubConnection.off('DeleteClient');
    //widget._timer!.cancel();
    super.deactivate();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    super.dispose();
  }

  Widget _showPerson(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children : <Widget>[
        Container(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network('https://node2.stvg.vn:51002/api/Image/' + widget.agrs!.image,),
          ),
          width: MediaQuery.of(context).size.width * .25 - 10,
          margin: const EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
          alignment: Alignment.topLeft
        ),
        Container(
          width: MediaQuery.of(context).size.width * .75,
          child:Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  style: TextStyle(fontSize: 10),
                  decoration: InputDecoration(
                    icon: Icon(Icons.account_circle),
                    hintText: 'Enter ID',
                    labelText: 'ID',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter code';
                    } else {
                      _id = value;
                    }
                    return null;
                  },
                  initialValue: _id,
                ),
                TextFormField(
                  style: TextStyle(fontSize: 10),
                  decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: 'Enter first name',
                    labelText: 'First Name',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter first name';
                    } else {
                      _firstname = value;
                    }
                    return null;
                  },
                  initialValue: _firstname,
                ),
                TextFormField(
                  style: TextStyle(fontSize: 10),
                  decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: 'Enter last name',
                    labelText: 'Last Name',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter last name';
                    } else {
                      _lastname = value;
                    }
                    return null;
                  },
                  initialValue: _lastname,
                ),
                TextFormField(
                  style: TextStyle(fontSize: 10),
                  decoration: InputDecoration(
                    icon: Icon(Icons.group),
                    hintText: 'Enter group',
                    labelText: 'Group',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter group';
                    } else {
                      _group = value;
                    }
                    return null;
                  },
                  initialValue: _group,
                ),
                TextFormField(
                  style: TextStyle(fontSize: 10),
                  decoration: InputDecoration(
                    icon: Icon(Icons.home),
                    hintText: 'Enter area',
                    labelText: 'Area',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter area';
                    } else {
                      _area = value;
                    }
                    return null;
                  },
                  initialValue: _area,
                ),
                TextFormField(
                  style: TextStyle(fontSize: 10),
                  decoration: InputDecoration(
                    icon: Icon(Icons.work),
                    hintText: 'Enter position',
                    labelText: 'Position',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter posistion';
                    } else {
                      _position = value;
                    }
                    return null;
                  },
                  initialValue: _position,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    widget.agrs = ModalRoute.of(context)!.settings.arguments as ModelPerson;

    _id = widget.agrs!.id;
    _code = widget.agrs!.code;
    _firstname = widget.agrs!.firstname;
    _lastname = widget.agrs!.lastname;
    _group = widget.agrs!.group;
    _area = widget.agrs!.area;
    _position = widget.agrs!.position;
    _image = widget.agrs!.image;

    return Scaffold(

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(26.0),
        child: AppBar (
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Person'),
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
      body: _showPerson(context),
      resizeToAvoidBottomInset: false,
      floatingActionButton: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton(
              onPressed: () async {
                if(flag_connection) {
                  if(flag_connection) {
                    if (_formKey.currentState!.validate()) {
                      await hubConnection.invoke('DeleteClient', args: <Object>[
                        _id,
                      ]);
                    }
                  }
                }
              },
              child: const Icon(Icons.delete),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: () async {
                if(flag_connection) {
                  if (_formKey.currentState!.validate()) {
                    print(_id);
                    await hubConnection.invoke('EditClient', args: <Object>[
                      _id,
                      _firstname,
                      _lastname,
                      _group,
                      _area,
                      _position,
                      _image,
                    ]);
                  }
                }
              },
              child: const Icon(Icons.edit),
            ),
          ),
        ],
      ),
    );
  }
}