import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:moblie_admin_gigamall/screen/listperson.dart';
import 'package:moblie_admin_gigamall/screen/login.dart';
import 'package:moblie_admin_gigamall/screen/person.dart';
import 'package:moblie_admin_gigamall/screen/readinfocard.dart';
import 'package:moblie_admin_gigamall/screen/resultaddperson.dart';
import 'package:moblie_admin_gigamall/screen/resultdeleteperson.dart';
import 'package:moblie_admin_gigamall/screen/resulteditperson.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:moblie_admin_gigamall/screen/addperson.dart';
import 'package:moblie_admin_gigamall/screen/menu.dart';
import 'package:moblie_admin_gigamall/screen/readcard.dart';

FlutterBlue? flutterBlue;
final List<BluetoothDevice> devicesList = <BluetoothDevice>[];
BluetoothDevice? connectedDevice;
late List<BluetoothService> servicesDevice;
late String macDevice = '00:13:AA:00:CA:91';
final String service_uuid = '0000ffe0-0000-1000-8000-00805f9b34fb';
final String characteristic_uuid = '0000ffe1-0000-1000-8000-00805f9b34fb';
bool flag_ble = false;
bool on_off_ble = false;
String msg_ble = '';
bool flag_refresh_msg_ble = false;

final hubProtLogger = Logger("SignalR - hub");
final transportProtLogger = Logger("SignalR - transport");
final serverUrl = "https://tempdevice.stvg.vn:65000/adminclient";
final connectionOptions = HttpConnectionOptions;
final httpOptions = new HttpConnectionOptions(logger: transportProtLogger, transport: HttpTransportType.WebSockets);
final hubConnection = HubConnectionBuilder().withUrl(serverUrl, options: httpOptions).configureLogging(hubProtLogger).build();

String username = '';
String password = '';
bool flag_connection = false;

void handleLoginFunction(List<Object> parameters) {
  String tmp_mac = parameters[0] as String;
  String tmp_service_uuid = parameters[1] as String;
  String tmp_characteristic_uuid = parameters[2] as String;
  print('SignalR login : ' + parameters.toString());
  if(flag_connection == false) {
    if(tmp_mac.isNotEmpty) {
      flag_connection = true;
    }
  }
}

Future<void> connectSignalR() async {
  hubConnection.start();
  // hubConnection.on("Login", (arguments) => handleLoginFunction(arguments!));
  Timer.periodic(const Duration(seconds: 10), (timer) {
    //print(DateTime.now());
    if(hubConnection.state == HubConnectionState.Connected) {
      print('SignalR connected!');
      if(flag_connection == false) {
        if((username.isNotEmpty) && (password.isNotEmpty)) {
          hubConnection.invoke('Login',args: <Object>[
              username,
              password,
            ],
          );
        }
      }
    } else if(hubConnection.state == HubConnectionState.Connecting) {
      flag_connection = false;
      print('SignalR connecting!');
    } else if(hubConnection.state == HubConnectionState.Disconnected) {
      print('SignalR disconnect!');
      flag_connection = false;
      hubConnection.start();
    } else if(hubConnection.state == HubConnectionState.Disconnecting) {
      print('SignalR disconnecting!');
    } else if(hubConnection.state == HubConnectionState.Reconnecting) {
      print('SignalR reconnecting!');
      flag_connection = false;
    }
  });
}

Widget myAppBar (String name) {
  return AppBar (
    automaticallyImplyLeading: false,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(name),
        SizedBox(width: 5),

      ],
    ),

    actions: [ flag_ble ? StreamBuilder<BluetoothDeviceState>(
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
    ),],
  );
}

void main() {
  flag_connection = true;
  hubConnection.onclose(({error}) {
    flag_connection = false;
  });
  username = '';
  password = '';
  connectSignalR();
  runApp(const MyApp());
}
void bleHadData(List<int> data) {
  //print("Had data : " + data.toString());
  msg_ble = String.fromCharCodes(data);
  flag_refresh_msg_ble = true;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //initble();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.green,
      ),
      initialRoute: LoginView.routeName,
      routes: {
        LoginView.routeName : (context) => LoginView(),
        MenuView.routeName : (context) => MenuView(),
        AddPersonView.routeName : (context) => AddPersonView(),
        ReadCardView.routeName : (context) => ReadCardView(),
        ResultAddPersonView.routeName : (context) => ResultAddPersonView(),
        ListPersonView.routeName : (context) => ListPersonView(),
        PersonView.routeName : (context) => PersonView(),
        ResultEditPersonView.routeName : (context) => ResultEditPersonView(),
        ResultDeletePersonView.routeName : (context) => ResultDeletePersonView(),
        ReadInfoCardView.routeName : (context) => ReadInfoCardView(),
      },

    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  File? imageFile;

  void _incrementCounter() {
    setState(() {

      _counter++;
    });
  }

  void _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxWidth: MediaQuery.of(context).size.width * .6,
        imageQuality: 80,
    ) as XFile?;
    setState(() {
      imageFile = File(pickedFile!.path);
    });

  }

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            imageFile != null ?
            Container(
              child: Image.file(imageFile!),
            ): Container(
              child: Icon(
                Icons.camera_enhance_rounded,
                color: Colors.green,
                size: MediaQuery.of(context).size.width * .6,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        //onPressed: _incrementCounter,
        onPressed: _getFromCamera,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
