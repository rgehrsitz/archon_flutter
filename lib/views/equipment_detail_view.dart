import 'package:archon/models/equipment.dart';
import 'package:flutter/material.dart';
import '../models/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EquipmentDetailView extends ConsumerStatefulWidget {
  final Equipment? equipment;

  const EquipmentDetailView({super.key, this.equipment});

  @override
  ConsumerState<EquipmentDetailView> createState() =>
      EquipmentDetailViewState();
}

class EquipmentDetailViewState extends ConsumerState<EquipmentDetailView> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController typeController;
  late TextEditingController uuidController;
  late TextEditingController dateTimeCreatedController;
  late TextEditingController dateTimeUpdatedController;
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
    // Initialize controllers for read-only fields
    uuidController = TextEditingController(text: widget.equipment?.uuid);
    dateTimeCreatedController = TextEditingController(
        text: widget.equipment?.dateTimeCreated.toString());
    dateTimeUpdatedController = TextEditingController(
        text: widget.equipment?.dateTimeUpdated.toString());

    propertyControllers.clear(); // Clear existing controllers
    widget.equipment?.userDefinedProperties.forEach((key, value) {
      propertyControllers[key] = TextEditingController(text: value.toString());
    });
  }

  void _onUpdate(String updatedValue, String propertyName) {
    final equipment = widget.equipment;
    if (equipment != null) {
      setState(() {
        switch (propertyName) {
          case 'name':
            equipment.name = updatedValue;
            break;
          case 'description':
            equipment.description = updatedValue;
            break;
          case 'type':
            equipment.type = updatedValue;
            break;
          default:
            equipment.userDefinedProperties[propertyName] = updatedValue;
            break;
        }
      });
      // Use ref.read() to access the notifier and call its method
      ref.read(equipmentProvider.notifier).state = equipment;

      // Optionally, you can add the operation to the undoManager here
      // final undoManager = ref.read(undoManagerProvider);
      // undoManager.addOperation(() {
      //   // Code to revert the changes
      // });
    }
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
            _buildEditableField('Name', nameController, onUpdate: (newValue) {
              widget.equipment?.name = newValue;
            }, isMultiline: true),
            _buildEditableField('Description', descriptionController,
                onUpdate: (newValue) {
              widget.equipment?.description = newValue;
            }, isMultiline: true),
            _buildEditableField('Type', typeController, onUpdate: (newValue) {
              widget.equipment?.type = newValue;
            }, isMultiline: true),
            _buildReadOnlyField('UUID', uuidController),
            _buildReadOnlyField('Date Created', dateTimeCreatedController),
            _buildReadOnlyField('Date Updated', dateTimeUpdatedController),
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
      {bool isMultiline = false, required Function(String) onUpdate}) {
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
        onSubmitted: (value) {
          onUpdate(value);
        },
        onChanged: (value) {
          onUpdate(value);
        },
        onEditingComplete: () {
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }

  Widget _buildReadOnlyField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor:
              Colors.grey[200], // Optional: gives a distinct background color
        ),
        readOnly: true, // Set to true to make the field read-only
      ),
    );
  }

  List<Widget> _buildUserDefinedPropertyFields() {
    return propertyControllers.entries.map((entry) {
      return Row(
        children: [
          Expanded(
            child: _buildEditableField(
              entry.key,
              entry.value,
              onUpdate: (newValue) {
                setState(() {
                  widget.equipment?.userDefinedProperties[entry.key] = newValue;
                });
              },
            ),
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
