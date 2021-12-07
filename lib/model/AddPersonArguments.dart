import 'dart:io';

class AddPersonArguments {
  late String id = "";
  late String code = "";
  late String firstname = "";
  late String lastname = "";
  late String group = "";
  late String area = "";
  late String position = "";
  late File image;

  AddPersonArguments();

  String getID() {
    return this.id;
  }

  String getCode() {
    return this.code;
  }

  String getFirstName() {
    return this.firstname;
  }

  String getLastName() {
    return this.lastname;
  }

  String getGroup() {
    return this.group;
  }

  String getArea() {
    return this.area;
  }

  String getPosition() {
    return this.position;
  }

  File getImage() {
    return this.image;
  }

  void setId(String id) {
    this.id = id;
  }

  void setCode(String code) {
    this.code = code;
  }

  void setFirstName(String firstname) {
    this.firstname = firstname;
  }

  void setLastName(String lastname) {
    this.lastname = lastname;
  }

  void setGroup(String group) {
    this.group = group;
  }

  void setArea(String area) {
    this.area = area;
  }

  void setPosition(String position) {
    this.position = position;
  }

  void setImage(File file) {
    this.image = file;
  }
}