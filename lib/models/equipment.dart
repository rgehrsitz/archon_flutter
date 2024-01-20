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
    this.parent,
  })  : uuid = uuid ?? const Uuid().v4(),
        dateTimeCreated = dateTimeCreated ?? DateTime.now(),
        dateTimeUpdated = dateTimeUpdated ?? DateTime.now();

  Equipment clone() {
    return Equipment(
      uuid: uuid,
      name: name,
      type: type,
      description: description,
      dateTimeCreated: DateTime.fromMillisecondsSinceEpoch(
          dateTimeCreated.millisecondsSinceEpoch),
      dateTimeUpdated: DateTime.fromMillisecondsSinceEpoch(
          dateTimeUpdated.millisecondsSinceEpoch),
      userDefinedProperties: Map<String, dynamic>.from(userDefinedProperties),
      children: children
          .map((child) => child.clone())
          .toList(), // Clone children recursively
      parent: parent, // Keep the same parent reference
    );
  }

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

  Map<String, dynamic> toJSON() {
    var data = {
      'uuid': uuid,
      'name': name,
      'description': description,
      'type': type,
      'dateTimeCreated': dateTimeCreated.toIso8601String(),
      'dateTimeUpdated': dateTimeUpdated.toIso8601String(),
      'userDefinedProperties': userDefinedProperties,
    };

    // Only add 'children' if it's not empty
    if (children.isNotEmpty) {
      data['children'] = children.map((child) => child.toJSON()).toList();
    }

    return data;
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
