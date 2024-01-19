import 'package:archon/models/equipment.dart';
import 'package:flutter/material.dart';

class EquipmentDetailView extends StatefulWidget {
  final Equipment? equipment;

  const EquipmentDetailView({super.key, this.equipment});

  @override
  EquipmentDetailViewState createState() => EquipmentDetailViewState();
}

class EquipmentDetailViewState extends State<EquipmentDetailView> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController typeController;
  Map<String, TextEditingController> propertyControllers = {};

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.equipment?.name);
    descriptionController =
        TextEditingController(text: widget.equipment?.description);
    typeController = TextEditingController(text: widget.equipment?.type);

    // Initialize controllers for user-defined properties
    widget.equipment?.userDefinedProperties.forEach((key, value) {
      propertyControllers[key] = TextEditingController(text: value.toString());
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    typeController.dispose();
    propertyControllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.equipment == null) {
      return const Text('No equipment selected.');
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEditableField('Name', nameController),
            _buildEditableField('Description', descriptionController),
            _buildEditableField('Type', typeController),
            _buildReadOnlyField('UUID', widget.equipment!.uuid),
            _buildReadOnlyField(
                'Date Created', widget.equipment!.dateTimeCreated.toString()),
            _buildReadOnlyField(
                'Date Updated', widget.equipment!.dateTimeUpdated.toString()),
            const Divider(),
            const Text('User Defined Properties',
                style: TextStyle(fontWeight: FontWeight.bold)),
            ..._buildUserDefinedPropertyFields(),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        onChanged: (value) {
          // Implement logic to handle changes
        },
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        readOnly: true,
      ),
    );
  }

  List<Widget> _buildUserDefinedPropertyFields() {
    return widget.equipment!.userDefinedProperties.entries.map((entry) {
      return _buildEditableField(entry.key, propertyControllers[entry.key]!);
    }).toList();
  }
}
