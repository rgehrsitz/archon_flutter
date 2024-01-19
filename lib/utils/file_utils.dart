import 'package:file_selector/file_selector.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:archon/models/equipment.dart';
import 'dart:convert';

// Define the provider for equipment data
final equipmentProvider = StateProvider<Equipment?>((ref) => null);

Future<void> openFileDialog(WidgetRef ref) async {
  const String jsonExtension = '.json';
  const XTypeGroup jsonTypeGroup = XTypeGroup(
    label: 'JSON files',
    extensions: [jsonExtension],
  );

  final XFile? file = await openFile(
    acceptedTypeGroups: [jsonTypeGroup],
  );
  if (file != null) {
    final String fileContent = await file.readAsString();
    final jsonData = jsonDecode(fileContent);
    final Equipment equipmentData = Equipment.fromJSON(jsonData);
    // Update the state with the new equipment data
    ref.read(equipmentProvider.notifier).state = equipmentData;
  }
}
