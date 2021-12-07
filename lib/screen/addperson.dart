import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moblie_admin_gigamall/model/AddPersonArguments.dart';
import 'package:moblie_admin_gigamall/screen/readcard.dart';

import '../main.dart';

class AddPersonView extends StatefulWidget {
  AddPersonView({Key? key}) : super(key: key);
  static const routeName = '/AddPersonView';
  @override
  State<StatefulWidget> createState() => AddPersonViewState();
}

class AddPersonViewState extends State<AddPersonView> {
  late String _id;
  late String _firstname;
  late String _lastname;
  late String _group;
  late String _area;
  File? _image;
  late String _position;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _addPerson() {
    if(_formKey.currentState!.validate()) {
      if(_image == null) {

      }else {
        AddPersonArguments mArguments = new AddPersonArguments();
        mArguments.setId(_id);
        mArguments.setFirstName(_firstname);
        mArguments.setLastName(_lastname);
        mArguments.setGroup(_group);
        mArguments.setArea(_area);
        if (_image != null) {
          File m_file = _image!;
          mArguments.setImage(m_file);
        }
        mArguments.setPosition(_position);
        Navigator.pushNamed(context,
          ReadCardView.routeName,
          arguments: mArguments,
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('Error Dialog'),
            content: Text('You should check data'),
          );
        },
      );
    }
    setState(() {

    });
  }

  void _getFromCamera() async {
    if (_image != null) {
      _image!.delete(recursive:  true);
    }
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: MediaQuery.of(context).size.width * .4,
      maxWidth: MediaQuery.of(context).size.width * .4,
      imageQuality: 100,
    ) as XFile?;
    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(26.0),
        child: myAppBar('Add person'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              style: TextStyle(fontSize: 15),
              decoration: const InputDecoration(
                icon: const Icon(Icons.account_circle),
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
            ),
            TextFormField(
              style: TextStyle(fontSize: 15),
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'Enter first name',
                labelText: 'First name',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter first name';
                } else {
                  _firstname = value;
                }
                return null;
              },
            ),
            TextFormField(
              style: TextStyle(fontSize: 15),
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'Enter last name',
                labelText: 'Last name',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter last name';
                } else {
                  _lastname = value;
                }
                return null;
              },
            ),
            TextFormField(
              style: TextStyle(fontSize: 15),
              decoration: const InputDecoration(
                icon: const Icon(Icons.group),
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
            ),
            TextFormField(
              style: TextStyle(fontSize: 15),
              decoration: const InputDecoration(
                icon: const Icon(Icons.home),
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
            ),
            TextFormField(
              style: TextStyle(fontSize: 15),
              decoration: const InputDecoration(
                icon: const Icon(Icons.work),
                hintText: 'Enter posistion',
                labelText: 'Posistion',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  //return 'Please enter posistion';
                  _position = '';
                  return null;
                } else {
                  _position = value;
                }
                return null;
              },
            ),
            SizedBox(height: 5),
            Center(
              child: GestureDetector(
                onTap: (){
                  _getFromCamera();
                },
                child: _image != null ?
                Container(
                  //child: Image.file(_image!),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.file(_image!),
                  ),
                  width: MediaQuery.of(context).size.width * .4,
                ): Container(
                  child: Icon(
                    Icons.face,
                    color: Colors.green,
                    size: MediaQuery.of(context).size.width * .4,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPerson,
        //onPressed: _getFromCamera,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}