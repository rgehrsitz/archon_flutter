import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/equipment.dart';
import '../models/providers.dart';

import 'equipment_detail_view.dart';
import 'my_tree_view.dart';

class EquipmentView extends ConsumerStatefulWidget {
  const EquipmentView({super.key});

  @override
  ConsumerState<EquipmentView> createState() => _EquipmentViewState();
}

class _EquipmentViewState extends ConsumerState<EquipmentView> {
  late TextEditingController _filterController;
  String _filter = "";
  Equipment? selectedEquipment;

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
    final equipmentTree = ref.watch(equipmentProvider);

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
                Expanded(
                  flex: 2,
                  child: equipmentTree != null
                      ? MyTreeView(
                          equipmentTree: equipmentTree,
                          onEquipmentSelected: (Equipment equipment) {
                            setState(() {
                              selectedEquipment = equipment;
                            });
                          },
                        )
                      : const Text('No equipment data loaded.'),
                ),
                const VerticalDivider(width: 1),
                Expanded(
                  flex: 3,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: selectedEquipment != null
                        ? SingleChildScrollView(
                            child: EquipmentDetailView(
                                equipment: selectedEquipment),
                          )
                        : const Text('Please select an equipment item.'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MyTreeNode {
  MyTreeNode({
    required this.title,
    required this.children,
    this.parent,
    this.isExpanded = false,
    required this.uuid,
  });

  final String title;
  List<MyTreeNode> children;
  final String uuid;
  MyTreeNode? parent;
  bool isExpanded;

  @override
  String toString() {
    // Providing a better string representation for debugging purposes
    return 'MyTreeNode(title: $title, children count: ${children.length}, isExpanded: $isExpanded)';
  }
}

// Debug function to print the Equipment structure
// void printEquipment(Equipment equipment, [int level = 0]) {
//   var indent = '  ' * level;
//   for (var child in equipment.children) {
//     printEquipment(child, level + 1); // Recurse into children
//   }
// }
