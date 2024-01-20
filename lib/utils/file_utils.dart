import 'package:file_selector/file_selector.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:archon/models/equipment.dart';
import 'dart:convert';
import '../models/providers.dart';
import 'dart:io';

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
    ref.read(equipmentProvider.notifier).updateEquipment(equipmentData);
    ref.read(currentFilePathProvider.notifier).state =
        file.path; // Set the current file path
  }
}

Future<void> saveEquipment(WidgetRef ref, {bool saveAs = false}) async {
  final equipment = ref.read(equipmentProvider);
  if (equipment == null) {
    // Handle error: No equipment data to save
    return;
  }

  // Pretty-print JSON
  final String json =
      const JsonEncoder.withIndent('  ').convert(equipment.toJSON());
  String? filePath = ref.read(currentFilePathProvider);

  // If it's a new file or 'Save As', prompt for a file location
  if (filePath == null || saveAs) {
    const String jsonExtension = '.json';
    const String suggestedName = 'equipment.json';

    final FileSaveLocation? result = await getSaveLocation(
        suggestedName: suggestedName,
        acceptedTypeGroups: [
          const XTypeGroup(label: 'JSON files', extensions: [jsonExtension])
        ]);

    if (result == null) {
      // Operation was canceled by the user.
      return;
    }

    filePath = result.path;
    await File(filePath).writeAsString(json);
    ref.read(currentFilePathProvider.notifier).state =
        filePath; // Update the current file path
  } else {
    // Overwrite the existing file
    await File(filePath).writeAsString(json);
  }
}
