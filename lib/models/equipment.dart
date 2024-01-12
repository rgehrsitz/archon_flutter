import 'dart:convert';
import 'package:uuid/uuid.dart';

class Equipment {
  String uuid;
  String name;
  String type;
  String description;
  DateTime dateTimeCreated;
  DateTime dateTimeUpdated;
  Map<String, dynamic> userDefinedProperties;
  List<Equipment> children;

  Equipment({
    String? uuid,
    required this.name,
    required this.type,
    this.description = '',
    this.userDefinedProperties = const {},
    this.children = const [],
    DateTime? dateTimeCreated,
    DateTime? dateTimeUpdated,
  })  : uuid = uuid ?? const Uuid().v4(),
        dateTimeCreated = dateTimeCreated ?? DateTime.now(),
        dateTimeUpdated = dateTimeUpdated ?? DateTime.now();

  void updateDetails(String name, String description, String type,
      Map<String, dynamic> userDefinedProperties) {
    if (name.isNotEmpty) this.name = name;
    if (description.isNotEmpty) this.description = description;
    if (type.isNotEmpty) this.type = type;
    if (userDefinedProperties.isNotEmpty) {
      this.userDefinedProperties = userDefinedProperties;
    }
    dateTimeUpdated = DateTime.now();
  }

  void addChild(Equipment equipment) {
    children.add(equipment);
  }

  void removeChild(String uuid) {
    children.removeWhere((child) => child.uuid == uuid);
  }

  String toJSON() {
    return jsonEncode({
      'uuid': uuid,
      'name': name,
      'description': description,
      'type': type,
      'dateTimeCreated': dateTimeCreated.toIso8601String(),
      'dateTimeUpdated': dateTimeUpdated.toIso8601String(),
      'userDefinedProperties': userDefinedProperties,
      'children': children.map((child) => child.toJSON()).toList(),
    });
  }

  static Equipment fromJSON(Map<String, dynamic> json) {
    return Equipment(
      uuid: json['uuid'],
      name: json['name'],
      type: json['type'],
      description: json['description'],
      userDefinedProperties: json['userDefinedProperties'],
      children: List<Equipment>.from(json['children']
          .map((childJson) => Equipment.fromJSON(jsonDecode(childJson)))),
      dateTimeCreated: DateTime.parse(json['dateTimeCreated']),
      dateTimeUpdated: DateTime.parse(json['dateTimeUpdated']),
    );
  }
}
