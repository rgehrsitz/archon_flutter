import 'package:archon/models/equipment.dart';
import 'package:archon/views/equipment_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';

class MyTreeView extends StatefulWidget {
  final Equipment equipmentTree;
  final Function(Equipment) onEquipmentSelected;

  const MyTreeView(
      {super.key,
      required this.equipmentTree,
      required this.onEquipmentSelected});

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
            // Find and pass the selected Equipment object
            Equipment? selectedEquipment =
                findEquipmentByUUID(widget.equipmentTree, entry.node.uuid);
            if (selectedEquipment != null) {
              widget.onEquipmentSelected(selectedEquipment);
            }
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

  // Utility function to find Equipment by UUID
  Equipment? findEquipmentByUUID(Equipment root, String uuid) {
    if (root.uuid == uuid) return root;
    for (var child in root.children) {
      var found = findEquipmentByUUID(child, uuid);
      if (found != null) return found;
    }
    return null; // Return null if not found
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
      uuid: equipment.uuid,
    );
  }
}
