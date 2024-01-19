import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/equipment.dart';
import '../models/providers.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';

import 'equipment_detail_view.dart';

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
                      ? MyTreeView(equipmentTree: equipmentTree)
                      : const Text('No equipment data loaded.'),
                ),
                const VerticalDivider(width: 1),
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

// Convert Equipment model to TreeNode model
MyTreeNode _convertEquipmentToTreeNode(Equipment equipment,
    [MyTreeNode? parent]) {
  // Convert children and set their parent to the newly created node
  var childrenNodes = equipment.children
      .map((child) => _convertEquipmentToTreeNode(child))
      .toList();

  // Create a node and assign the children directly
  return MyTreeNode(
    title: equipment.name,
    children: childrenNodes,
    parent: parent,
  );
}

// TreeView widget using flutter_fancy_tree_view
class MyTreeView extends StatefulWidget {
  final Equipment equipmentTree;

  const MyTreeView({super.key, required this.equipmentTree});

  @override
  MyTreeViewState createState() => MyTreeViewState();
}

class MyTreeViewState extends State<MyTreeView> {
  late final TreeController<MyTreeNode> treeController;
  late List<MyTreeNode> roots;

  @override
  void initState() {
    super.initState();
    //printEquipment(
    //    widget.equipmentTree); // Add this line to print the equipment structure

    // Convert your Equipment data to TreeNode data
    roots = [_convertEquipmentToTreeNode(widget.equipmentTree)];

    // Instantiate the TreeController with the root nodes
    treeController = TreeController<MyTreeNode>(
      roots: roots,
      childrenProvider: (MyTreeNode node) => node.children,
      parentProvider: (MyTreeNode node) => node.parent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TreeView<MyTreeNode>(
      treeController: treeController,
      nodeBuilder: (BuildContext context, TreeEntry<MyTreeNode> entry) {
        return InkWell(
          onTap: () {
            setState(() {
              // Toggle expansion state
              entry.node.isExpanded = !entry.node.isExpanded;
            });
            treeController.toggleExpansion(
                entry.node); // Make sure to toggle expansion in the controller
          },
          child: TreeIndentation(
            entry: entry,
            child: Row(
              children: [
                if (entry.node.children
                    .isNotEmpty) // Display an icon to indicate expandable nodes
                  Icon(
                    entry.node.isExpanded
                        ? Icons.expand_less
                        : Icons.expand_more,
                    size: 16.0,
                  ),
                Text(entry.node.title),
              ],
            ),
          ),
        );
      },
    );
  }
}

class MyTreeNode {
  MyTreeNode({
    required this.title,
    required this.children,
    this.parent,
    this.isExpanded = false,
  });

  final String title;
  List<MyTreeNode> children;
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
