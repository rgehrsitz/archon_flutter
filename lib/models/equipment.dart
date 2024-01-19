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
  Equipment? parent; //track the parent for drag and drop

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
      uuid: json['uuid'] as String? ?? const Uuid().v4(),
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
      description: json['description'] as String? ?? '',
      userDefinedProperties:
          json['userDefinedProperties'] as Map<String, dynamic>? ?? {},
      children: (json['children'] as List? ?? [])
          .map((childJson) =>
              Equipment.fromJSON(childJson as Map<String, dynamic>))
          .toList(),
      dateTimeCreated: DateTime.parse(json['dateTimeCreated'] as String),
      dateTimeUpdated: DateTime.parse(json['dateTimeUpdated'] as String),
    );
  }
}
