class ModelListPerson {
  final List<ModelPerson> persons;

  ModelListPerson({required this.persons});

  factory ModelListPerson.fromJson(Map<String, dynamic> data) {
    final personsData = data['persons'] as List<dynamic>?;
    final persons = personsData != null ? personsData.map((personData) => ModelPerson.fromJson(personData)).toList() : <ModelPerson>[];
    return ModelListPerson(persons: persons);
  }

  Map<String, dynamic> toJson() {
    return {
      'persons': persons.map((person) => person.toJson()).toList(),
    };
  }
}

class ModelPerson {
  late String id = "";
  late String code = "";
  late String firstname = "";
  late String lastname = "";
  late String group = "";
  late String area = "";
  late String position = "";
  late String image ="";

  ModelPerson({required this.id, required this.code, required this.firstname, required this.lastname, required this.group, required this.area, required this.position, required this.image});

  factory ModelPerson.fromJson(Map<String, dynamic> json){
    final id = json['id'] as String;
    final code = json['code'] as String;
    final firstname = json['firstname'] as String;
    final lastname = json['lastname'] as String;
    final group = json['group'] as String;
    final area = json['area'] as String;
    final position = json['position'] as String;
    final image = json['image'] as String;
    return ModelPerson(id: id, code: code, firstname: firstname, lastname: lastname, group: group, area: area, position: position, image: image);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'firstname': firstname,
      'lastname': lastname,
      'group': group,
      'area': area,
      'position': position,
      'image': image,
    };
  }
}