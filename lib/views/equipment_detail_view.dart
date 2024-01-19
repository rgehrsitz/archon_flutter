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
    _initializeControllers();
  }

  void _initializeControllers() {
    nameController = TextEditingController(text: widget.equipment?.name);
    descriptionController =
        TextEditingController(text: widget.equipment?.description);
    typeController = TextEditingController(text: widget.equipment?.type);

    widget.equipment?.userDefinedProperties.forEach((key, value) {
      propertyControllers[key] = TextEditingController(text: value.toString());
    });
  }

  @override
  void didUpdateWidget(EquipmentDetailView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.equipment != oldWidget.equipment) {
      _initializeControllers();
    }
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
            _buildEditableField('Description', descriptionController,
                isMultiline: true),
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
            TextButton(
                onPressed: _addNewProperty,
                child: const Text('Add New Property')),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller,
      {bool isMultiline = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        maxLines: isMultiline ? null : 1,
        keyboardType:
            isMultiline ? TextInputType.multiline : TextInputType.text,
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
    return propertyControllers.entries.map((entry) {
      return Row(
        children: [
          Expanded(
            child: _buildEditableField(entry.key, entry.value),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _removeProperty(entry.key),
          ),
        ],
      );
    }).toList();
  }

  void _addNewProperty() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (BuildContext context) {
        return _AddPropertyDialog();
      },
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        var key = result.keys.first;
        var value = result[key]!;
        widget.equipment?.userDefinedProperties[key] = value;
        propertyControllers[key] = TextEditingController(text: value);
      });
    }
  }

  void _removeProperty(String key) {
    setState(() {
      propertyControllers.remove(key);
      widget.equipment?.userDefinedProperties.remove(key);
      // Implement any additional logic required when removing a property
    });
  }
}

class _AddPropertyDialog extends StatefulWidget {
  @override
  _AddPropertyDialogState createState() => _AddPropertyDialogState();
}

class _AddPropertyDialogState extends State<_AddPropertyDialog> {
  final keyController = TextEditingController();
  final valueController = TextEditingController();

  @override
  void dispose() {
    keyController.dispose();
    valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Property'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: keyController,
            decoration: const InputDecoration(labelText: 'Property Key'),
          ),
          TextField(
            controller: valueController,
            decoration: const InputDecoration(labelText: 'Property Value'),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Add'),
          onPressed: () {
            Navigator.of(context).pop({
              keyController.text: valueController.text,
            });
          },
        ),
      ],
    );
  }
}
