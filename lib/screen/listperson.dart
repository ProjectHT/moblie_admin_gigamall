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
    if (tmp.isNotEmpty) {
      Map<String, dynamic> buffer = jsonDecode(tmp);
      _modellistperson = ModelListPerson.fromJson(buffer);
      print(_modellistperson!.toJson());
      setState(() {});
    }
  }

  getData() {
    ModelPerson person = ModelPerson(
        id: 'id',
        code: 'code',
        firstname: 'firstName',
        lastname: 'lastName',
        group: 'group',
        area: 'area',
        position: 'position',
        image: 'image');
    List<ModelPerson> lstPerson = [];
    for (var i = 0; i < 10; i++) {
      lstPerson.add(person);
    }
    setState(() {
      _modellistperson = ModelListPerson(persons: lstPerson);
    });
  }

  Widget _myListView(BuildContext context) {
    if (_modellistperson == null) {
      return Center(
        child: Container(
          child: GestureDetector(
            onTap: () {
              Navigator.popUntil(
                  context, ModalRoute.withName(MenuView.routeName));
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
                Navigator.pushNamed(
                  context,
                  PersonView.routeName,
                  arguments: _modellistperson!.persons[index],
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            'https://node2.stvg.vn:51002/api/Image/' +
                                _modellistperson!.persons[index].image),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    _modellistperson!.persons[index].id,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    _modellistperson!.persons[index].firstname +
                                        " " +
                                        _modellistperson!
                                            .persons[index].lastname,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 5),
                              // decoration: BoxDecoration(border: Border.all(color: Colors.red, width: 1)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    _modellistperson!.persons[index].position,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    _modellistperson!.persons[index].group,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    _modellistperson!.persons[index].area,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                    )
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
    // hubConnection.on(
    //     'ListClient', (arguments) => handleListClientFunction(arguments!));
    // if (flag_connection) {
    //   hubConnection.invoke('ListClient', args: <Object>[]);
    // }
    getData();
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
        child: myAppBar('List person'),
      ),
      body: _myListView(context),
      floatingActionButton: FloatingActionButton(
        //onPressed: _incrementCounter,
        onPressed: () {
          if (flag_connection) {
            hubConnection.invoke('ListClient', args: <Object>[]);
          }
        },
        tooltip: 'Sync',
        child: const Icon(Icons.sync),
      ),
    );
  }
}
