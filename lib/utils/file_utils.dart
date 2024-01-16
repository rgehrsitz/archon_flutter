import 'package:file_selector/file_selector.dart';

Future<void> openFileDialog() async {
  const String jsonExtension = '.json';
  const XTypeGroup jsonTypeGroup = XTypeGroup(
    label: 'JSON files',
    extensions: [jsonExtension],
  );

  final XFile? file = await openFile(
    acceptedTypeGroups: [jsonTypeGroup],
  );

  if (file != null) {
    // Do something with the file (read it, display it, etc.)
    final String fileContent = await file.readAsString();
    // For example, you might want to use the file content or just print it:
    print(fileContent);
  }
}
