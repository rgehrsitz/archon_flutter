import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/equipment.dart';
// Import any necessary tree view package if needed

// A provider that will hold the root of the equipment tree
final equipmentTreeProvider = StateProvider<Equipment?>((ref) => null);

class EquipmentView extends ConsumerStatefulWidget {
  const EquipmentView({super.key});

  @override
  ConsumerState<EquipmentView> createState() => _EquipmentViewState();
}

class _EquipmentViewState extends ConsumerState<EquipmentView> {
  late TextEditingController _filterController;
  String _filter = "";

  @override
  void initState() {
    super.initState();
    _filterController = TextEditingController();
  }

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the equipment tree from the Riverpod provider
    final equipmentTree = ref.watch(equipmentTreeProvider);

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _filterController,
              decoration: const InputDecoration(
                labelText: 'Filter Equipment',
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _filter = value;
                });
              },
            ),
          ),
          Expanded(
            child: Row(
              children: [
                // Hierarchical view of equipment on the left
                Expanded(
                  flex: 2,
                  child: EquipmentTreeView(
                    filter: _filter,
                    equipmentTree: equipmentTree,
                    onEquipmentSelected: (Equipment selectedEquipment) {
                      // Handle equipment selection
                    },
                  ),
                ),
                const VerticalDivider(width: 1),
                // Detailed view of the selected equipment on the right
                Expanded(
                  flex: 3,
                  child: equipmentTree != null
                      ? EquipmentDetailView(equipment: equipmentTree)
                      : const Text('Please select an equipment item.'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget for Equipment Tree View
class EquipmentTreeView extends StatelessWidget {
  final String filter;
  final Equipment? equipmentTree;
  final Function(Equipment) onEquipmentSelected;

  const EquipmentTreeView({
    super.key,
    required this.filter,
    required this.equipmentTree,
    required this.onEquipmentSelected,
  });

  @override
  Widget build(BuildContext context) {
    // You should replace this with your actual implementation of a tree view
    // which could be a custom widget or a package that you prefer.
    // It should use the equipmentTree and filter to display the data.
    return const Text('Tree View with filter');
  }
}

// Widget for Equipment Detail View
class EquipmentDetailView extends StatelessWidget {
  final Equipment? equipment;

  const EquipmentDetailView({super.key, this.equipment});

  @override
  Widget build(BuildContext context) {
    if (equipment == null) {
      return const Text('No equipment selected.');
    }

    // Here you would display the details of the selected equipment.
    // This could include name, type, description, and any user-defined properties.
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Equipment Details: ${equipment!.name}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          // Display other properties of the equipment
          // You can create a widget that displays each property, or use a loop to generate them
        ],
      ),
    );
  }
}
