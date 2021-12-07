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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
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
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  File? imageFile;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  void _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxHeight: MediaQuery.of(context).size.width * .6,
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
    /*
    flutterBlue = FlutterBlue.instance;
    flutterBlue.startScan(timeout: const Duration(seconds: 120));
    var subscription = flutterBlue.scanResults.listen((results) async {
      for (ScanResult r in results) {
        if(!devicesList.contains(r.device)) {
          devicesList.add(r.device);
          if(r.device.id.toString().compareTo(macDevice) == 0) {
            try {
              await r.device.connect(timeout: const Duration(seconds: 10), autoConnect: true);
            } catch (e) {

            }
            connectedDevice = r.device;
            flutterBlue.stopScan();
            List<BluetoothService> services = await connectedDevice.discoverServices();
            services.forEach((service) async {
              if(service.uuid.toString().compareTo(service_uuid) == 0) {
                for(BluetoothCharacteristic c in service.characteristics) {
                  if(c.uuid.toString().compareTo(characteristic_uuid) == 0) {
                    await c.setNotifyValue(true);
                    c.value.listen((value) {
                      bleHadData(value);
                    });
                  }
                }
              }
            });
          }
        }
      }
    });

     */
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
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
